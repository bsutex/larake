module LaRake
    class Job

        def self.checksum(files)
            content = files.map{|f| File.read(f)}.join
            MD5.md5(content).to_s
        end

        def initialize task
            @task = task
        end

        def run *args
            setup *args

            digest

            wrap build
        end

        def digest

        end

        def build
        end

        def wrap result

        end
    end
end
