module LaRake
  class Job
    def self.checksum(files)
      content = files.map{|f| File.read(f)}.join
      MD5.md5(content).to_s
    end

    def initialize(task)
      @task = task
    end

    def run(*args)
      setup *args

      copy_srcs job_dir

      digest

      wrap build
    end

    def job_dir(subdir = "")
      File.join(@task.task_dir, "#{self.class.name.split(":").last.downcase}", subdir)
    end

    def job_srcs
      job_dir("srcs")
    end

    def job_out
      job_dir("out")
    end

    private
    def copy_srcs(job_dir)
      FileUtils.mkdir_p(job_dir)

      instance_variables.each do |var|
        if src? var then
          copy_field(eval %{#{var}})
        end
      end
    end

    def copy_field(field)
      if field.is_a? Array then
        field.each do |item|
          copy item
        end
      else
        copy field
      end
    end

    def copy(item)
      to = File.join(job_srcs, File.basename(item))
      FileUtils.mkdir_p(to)
      from = File.expand_path(item)
      FileUtils.cp_r(from, to)
    end

    def src?(method)
      method = method.to_s
      ["@src_", "@srcs_"].map{|prefx| method.start_with?(prefx) || method.start_with?(prefx.gsub("_",'')) }.inject(false){|res, elem| res || elem}
    end

    def digest

    end

    def build
    end

    def wrap(result)
      result
    end
  end
end
