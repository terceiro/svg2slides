mkdir_p('data/man/man1')
command('which rd2 > /dev/null')
command('rd2 -r rd/rd2man-lib.rb README | sed -e s/README/svg2slides/g | gzip - > data/man/man1/svg2slides.1.gz')
