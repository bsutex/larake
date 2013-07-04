module LaRake
    class Pdflatex < Job
        def setup srcs, opts = {}
            @srcs = Dir.glob("#{srcs}/**/*.tex")
            @srcs_deps = opts.delete(:deps) || []
            @opt_main = File.join(srcs, opts.delete(:main) || raise("No main file. Don't know what to do"))
        end

        def build

        end
    end
end
