module LaRake
    class Pdflatex < Job
        @@flag_mapping = {
            # Sets \pdfdraftmode so pdfTeX doesn't write a PDF and doesn't read any included images, thus speeding up execution.
            :draftmode => '-draftmode',
            # Enable the encTeX extensions. This option is only effective in combination with -ini. For documentation of the encTeX extensions see http://www.olsak.net/enctex.html.
            :enc => '-enc',
            # Print error messages in the form file:line:error which is similar to the way many compilers format them.
            :file_line_error => '-file-line-error',
            # Disable printing error messages in the file:line:error style.
            :no_file_line_error => '-no-file-line-error',
            # Exit with an error code when an error is encountered during processing.
            :halt_on_err => '-halt-on-error',
            # Enable the filename recorder. This leaves a trace of the files opened for input and output in a file with extension .fls.
            :recorder => '-recorder'
        }

        @@opt_mapping =
        {
            #Use name for the job name, instead of deriving it from the name of the input file.
            :jobname => '-jobname',
            # Set the output format mode, where format must be either pdf or dvi. This also influences the set of graphics formats understood by pdfTeX.
            :output_fmt => '-output-format',
            # directory instead of the current directory. Look up input files in directory first, the along the normal search path.
            :output_directory => '-output-directory'
        }
        def setup src_dir, opts = {}            
            @srcs = Dir.glob("#{src_dir}/**/*{.tex,.sty,.bib}")
            @srcs_deps = opts.delete(:deps) || []
            @opts_flags = opts.delete(:flags) || []
            raise("Unknown flags : #{flags.inspect}") unless check_flags @opts_flags
            @opt_main = File.join(src_dir, opts.delete(:main) || raise("No main file. Don't know what to do"))

            @opts = {}
            @opts[:jobname] = opts.delete(:jobname) || File.basename(@opt_main)
            @opts[:output_fmt] = opts.delete(:output_fmt) || 'pdf'
            @opts[:output_directory] = File.absolute_path(File.join(job_out, opts.delete(:output_directory) || ''))

            @opt_src_dir = src_dir
            
            raise("Unknown options : #{opts.inspect}") unless opts.empty?
        end

        def check_flags flags
            flags.select{|flag| !(@@flag_mapping.has_key?(flag))}.empty?
        end

        def build            
            FileUtils.mkdir_p(@opts[:output_directory])
            Dir.glob("#{job_srcs}/**/**").select{|entry| File.directory?(entry)}.map{|entry| entry.gsub(File.join(job_srcs, @opt_src_dir), job_out)}.each{|dir| FileUtils.mkdir_p(dir)}

            Dir.chdir(File.join(job_srcs, @opt_src_dir)) do
                # Пока собираем все два раза. Надо будет узнать как определять все ли мы собрали
                ['pdflatex', make_args(@opts_flags, @opts) ,@opt_main.gsub("#{@opt_src_dir}#{File::SEPARATOR}","")].run{|out| latex_pretty out}
                ['pdflatex', make_args(@opts_flags, @opts) ,@opt_main.gsub("#{@opt_src_dir}#{File::SEPARATOR}","")].run{|out| latex_pretty out}                
            end

            Product.new(Hash[*Dir.glob("#{job_out}/**/*.pdf").map{|entry| [entry, File.basename(entry)]}.flatten])
        end

        def make_args flags, opts
            [make_flags(flags), make_opts(opts)].join(" ")
        end
    
        def make_flags flags
            flags.map{|flag| @@flag_mapping[flag]}.join(" ")
        end

        def make_opts opts
            str = []
            opts.each do |k, v|
                str << [@@opt_mapping[k], v]
            end

            str.join(" ")
        end

        def latex_pretty line
            ## Ну здесь еще можно много чего наворотить
            print ["\t", line].join.gsub(/[Ww]arning/){|m| m.yellow.bold}.gsub("LaTeX"){|m| m.white.bold}.
                gsub(/(Fatal)|(error)/){|m| m.red.bold}
        end
    end
end
