PNG_DPI ?= 1200
# I don’t think this works
PNG_THREADS ?= 8

# 512 MB
GS_MEMORY ?= 536870912
GS_BITMAP ?= $(GS_MEMORY)

TYPES=short long indefinite

TITLE_IMAGES=$(patsubst %, title-%.png, $(TYPES))
TAB_IMAGES=$(patsubst %, tab-%.png, $(TYPES))
IMAGES=short.jpg long.png indefinite.jpg paper_full.jpg parchment_full.png $(TITLE_IMAGES) $(TAB_IMAGES)

PWD ?= $(shell pwd)

all: cards.pdf
# For now just add a prerequisite of the first page, all of them will be created
png: cards/card-01.png

%.pdf: fonts/userconfig.xml %.fo $(patsubst %, images/%, $(IMAGES))
	fop -c $< $*.fo $@

# For some reason this XSLT causes a NPE in fop/xalan.
# Also Xalan has a bug that prevents the duration-value eval template from working.
%.fo: %-fo.xsl %.xml
	xsltproc --stringparam image_root "$(PWD)" -o $@ $< $*.xml

cards/%.png: cards.pdf
	mkdir -p cards
	gs -dBGPrint=true -dNumRenderingThreads=$(PNG_THREADS) -dSAFER -dBATCH -dNOPAUSE \
		-dNOPROMPT -dMaxBitmap=$(GS_BITMAP) -dAlignToPixels=0 -dGridFitTT=2 \
		-sDEVICE=png16m -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -r$(PNG_DPI)x$(PNG_DPI) \
		-sOutputFile=cards/card-%02d.png -c '$(GS_MEMORY) setvmthreshold' -fcards.pdf

clean:
	rm -rf *.pdf *.fo cards images/short.jpg images/long.png images/indefinite.jpg

images/short.jpg: images/death_city_by_cyliondraw-d53wfqd.jpg
	convert $< -crop 1800x1250+48+0 +repage $@

images/long.png: images/devil__2_by_skyrawathi-damm1gy.png
	ln -snf $(notdir $<) $@

images/indefinite.jpg: images/give_the_power___cinematic_by_m_delcambre-daiovei.jpg
	convert $< -crop 858x596+83+0 +repage $@

.SECONDARY: cards.fo
