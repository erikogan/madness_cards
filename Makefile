all: cards.pdf

%.pdf: fonts/userconfig.xml %.fo images/*.png images/*.jpg
	fop -c $< $*.fo $@

# For some reason this XSLT causes a NPE in fop/xalan.
# Also Xalan has a bug that prevents the duration-value template from working.
%.fo: %-fo.xsl %.xml
	xsltproc -o $@ $< $(filter-out $<, $^)

clean:
	rm -f *.pdf *.fo

.SECONDARY: cards.fo
