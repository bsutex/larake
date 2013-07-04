module Rake
    class Application
        alias old_top top_level
        def top_level
            log("Build started ...", :milestone)
            old_top
        end
    end
end
