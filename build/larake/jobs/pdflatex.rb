module LaRake
    class Pdflatex < Job
        def setup src_dir, opts = {}
            @srcs = Dir.glob("#{src_dir}/**/*.tex")
            @srcs_deps = opts.delete(:deps) || []
            @opt_main = File.join(src_dir, opts.delete(:main) || raise("No main file. Don't know what to do"))
            @opt_src_dir = src_dir
        end

        def build
            Dir.chdir(File.join(job_srcs, @opt_src_dir)) do
                # Пока собираем все два раза. Надо будет узнать как определять все ли мы собрали
                ['pdflatex', @opt_main.gsub("#{@opt_src_dir}#{File::SEPARATOR}","")].run
                ['pdflatex', @opt_main.gsub("#{@opt_src_dir}#{File::SEPARATOR}","")].run
            end

            Product.new(Hash[*Dir.glob("#{job_srcs}/**/*.pdf").map{|entry| [entry, File.basename(entry)]}.flatten])
        end
    end
end
