# Это надо сделать покрасивее
$: << "#{File.dirname(__FILE__)}/build"

require 'larake'


include LaRake

task :default => :view_pdf


task :view_pdf => :pdf do |t|
 #   [ 'evince', :pdf ].run
 p t.name
end

task :pdf => [ :images ] do |t|
    t.pdflatex('src/main.tex', :with_toc => true)
end

task :images do |t|
    ## do nothing for that moment
    p t.name
end


