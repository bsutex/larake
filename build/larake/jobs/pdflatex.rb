module LaRake
    class Pdflatex < Job
        def setup srcs, opts = {}
            puts srcs
            p opts
        end
    end
end
