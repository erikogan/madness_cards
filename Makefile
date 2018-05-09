PNG_DPI ?= 1200
# I don’t think this works
PNG_THREADS ?= 8

# 512 MB
GS_MEMORY ?= 536870912
GS_BITMAP ?= $(GS_MEMORY)

all: cards.pdf
# For now just add a prerequisite of the first page, all of them will be created
png: cards/card-01.png

%.pdf: fonts/userconfig.xml %.fo images/*.png images/*.jpg
	fop -c $< $*.fo $@

# For some reason this XSLT causes a NPE in fop/xalan.
# Also Xalan has a bug that prevents the duration-value eval template from working.
%.fo: %-fo.xsl %.xml
	xsltproc -o $@ $< $*.xml

cards/%.png: cards.pdf
	mkdir -p cards
	gs -dBGPrint=true -dNumRenderingThreads=$(PNG_THREADS) -dSAFER -dBATCH -dNOPAUSE \
		-dNOPROMPT -dMaxBitmap=$(GS_BITMAP) -dAlignToPixels=0 -dGridFitTT=2 \
		-sDEVICE=png16m -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -r$(PNG_DPI)x$(PNG_DPI) \
		-sOutputFile=cards/card-%02d.png -c '$(GS_MEMORY) setvmthreshold' -fcards.pdf

clean:
	rm -rf *.pdf *.fo cards

.SECONDARY: cards.fo
