require 'pty'

module LaRake
    class OutputFilter
        def initialize another_filter = nil , &block
          @another_filter = another_filter          
          @proc = block || Proc.new {|l| on_proc_line l}
        end                   
        def proc_line line
          @proc.call(@another_filter.nil? ? line : @another_filter.proc_line(line))
        end
    end   


    class PrintOutputFilter < OutputFilter
      def initialize another_filter = nil
        super(another_filter) {|l| puts l}
      end
    end    

    ## Обычно строки в LaTeX переносятся при достижении границы 80 символов
    ## это не очень информативно и занимает много места. 
    ## Будем соединять разбитые строки к    
    class ExpandLines < OutputFilter

      @@BRACES_REGEX = /[\]\[\<\>\(\)\{\}]/

      @@ACTIONS_RULES = {
        '{' => [:curly, +1 ], '(' => [:parentheses, +1], '<' => [:angles, +1],
        '}' => [:curly, -1 ], ')' => [:parentheses, -1], '>' => [:angles, -1]        
      }

      def initialize another_filter = nil , &block
        super(another_filter, &block) 
        clear_braces
        @redyline = ""
      end      
 
      def on_proc_line line 
        apply_actions(line.scan(@@BRACES_REGEX), @@ACTIONS_RULES)

        case check_braces
          when :all_fine
            result = [@redyline, line.chomp].join 
            @redyline = ""            
          when :continue
            @redyline << line.chomp 
            result = ''
          when :unbalanced
            clear_braces
            result = [@redyline, line.chomp].join("\n")
            @redyline = ""            
        end

        result
      end

      def apply_actions(actions, rules)
        actions.each do |action|
          rule = rules[action]  
          @braces[rule.first] = @braces[rule.first] + rule.last
        end
      end

      def check_braces
        sum = @braces.keys.inject(0){|sum, id| sum = sum + @braces[id]}
        sum == 0 ? :all_fine : (sum > 0 ? :continue : :unbalanced)
      end

      def clear_braces
        @braces = { :curly => 0, :parentheses => 0, :brakets => 0, :angles => 0 }  
      end
    end
end