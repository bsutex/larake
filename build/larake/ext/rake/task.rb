
module Rake
    include LaRake

    class Task
        alias :old_execute :execute

        def execute(args=nil)
            log(self.name, :task)
            FileUtils.mkdir_p(File.join(LaRake.tmp_dir, self.name))
            :old_execute
        end
    end
end
