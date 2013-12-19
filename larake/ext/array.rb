require 'pty'

class Array
  def run &block    
    cmd = self.map{|arg| arg.is_a?(Symbol) ? expand(arg) :  arg}.join(" ")
    begin
      PTY.spawn( cmd ) do |stdin, stdout, pid|
        begin
          # Do stuff with the output here. Just printing to show it works
          stdin.each { |line| block_given? ? yield(line) : print(line) }
        rescue Errno::EIO
          ## Errno:EIO error, but this probably just means 
          ##    that the process has finished giving output
          Process.wait(pid)
          raise("Error on \'#{cmd}\'") unless $?.exitstatus == 0
        end
        end
    end
  end
end    
  
