
module Rake
    include LaRake

    class Task
        alias old_execute execute

        def execute(args=nil)
            log(self.name, :task)
            begin
                old_execute
            rescue Exception => e
                log("Build failed @ #{self.name}", :error)
                raise e
            end
        end

        def task_dir
            File.join(LaRake.tmp_dir, self.name)
        end

        def method_missing(meth, *args, &block)
            clazz = Kernel.const_get(meth.capitalize)
            if clazz < LaRake::Job then
                ## Вообще, мне очень хочется передать туда и блок
                # но пока в этом необходимости нет, так что не будем
                clazz.new(self).run(*args)
            else
                super
            end
        end
    end
end
