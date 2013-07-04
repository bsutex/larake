class Array
    def run
        system(self.map{|arg| arg.is_a?(Symbol) ? expand(arg) :  arg}.join(" "))
    end
end
