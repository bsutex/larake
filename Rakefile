# Это надо сделать покрасивее
$: << "#{File.dirname(__FILE__)}/build"

require 'larake'


include LaRake

task :default => :view_pdf


task :view_pdf => :pdf do |t|
 #   [ 'evince', :pdf ].run
end

task :pdf => [ :images ] do |t|
    t.pdflatex('src', :main => 'main.tex', :deps => ['style'], :flags => [:halt_on_err]).export('out')
end

task :images do |t|
    ## do nothing for that moment
end


