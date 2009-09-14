require 'fileutils'
FileUtils.mkdir_p('data/man/man1')
system('rd2 -r rd/rd2man-lib.rb README > data/man/man1/svg2slides.1')
