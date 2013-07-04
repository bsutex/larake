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

            copy_srcs(job_dir)

            digest

            wrap build
        end

        private

        def job_dir
            File.join(@task.task_dir, "#{self.class.name.split(":").last.downcase}")
        end

        def copy_srcs(job_dir)
            FileUtils.mkdir_p(job_dir)

            instance_variables.each do |var|
                if opt_or_src? var then
                    copy_field(eval %{#{var}})
                end
            end
        end

        def copy_field(field)
            puts field
            if field.is_a? Array then
                field.each do |item|
                    copy_each item
                end
            else
                copy_each field
            end
        end

        def copy_each item
            to = File.join(job_dir, "srcs", File.dirname(item))
            FileUtils.mkdir_p(to)

            from = File.expand_path(item)

            FileUtils.cp_r(from, to)
        end

        def opt_or_src? method
            method = method.to_s
            ["@opt_", "@src_", "@srcs_"].map{|prefx| method.start_with?(prefx) || method.start_with?(prefx.gsub("_",'')) }.inject(false){|res, elem| res || elem}
        end

        def digest

        end

        def build
        end

        def wrap result

        end
    end
end
