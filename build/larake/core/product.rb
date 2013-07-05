module LaRake
    class Product
        def initialize h
            @h = h
        end

        def export out=""
            @h.each do |f, t|
                FileUtils.mkdir_p(File.join(out, File.dirname(t)))
                FileUtils.cp_r(f, File.join(out, t))
            end
        end
    end
end
