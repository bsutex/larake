
module Rake
    class Task
        alias :old_execute :execute

        def execute(args=nil)
            log(self.name, :task)
            :old_execute
        end
    end
end
