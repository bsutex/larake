module Rake
    include LaRake

    class Application
        alias old_top top_level
        def top_level
            log("Build started ...", :milestone)
            FileUtils.mkdir_p(LaRake.tmp_dir)
            old_top
        end
    end
end
