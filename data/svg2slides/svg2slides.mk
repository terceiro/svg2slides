SVG2SLIDES_SLIDES = $(foreach input, $(SVG2SLIDES_INPUT), $(shell seq -f "$(shell echo $(input) | sed -e 's/.svg$$//')-%03g.svg" 1 $(shell grep -c 'inkscape:groupmode="layer"' $(input))))

-include svg2slides.in.mk

%.svg2slides.stamp: %.svg
	svg2slides $< && touch $@

svg2slides.in.mk: $(SVG2SLIDES_INPUT)
	for file in $(SVG2SLIDES_SLIDES); do input=`echo $$file | sed -e 's/-[0-9]*.svg/.svg2slides.stamp/'`; echo "$$file: $$input" >> $@; done

clean::
	rm -rf $(SVG2SLIDES_SLIDES) svg2slides.in.mk *.svg2slides.stamp
