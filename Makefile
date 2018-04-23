all: cards.pdf

%.pdf: fonts/userconfig.xml %.fo
	fop -c $< $(filter-out $<, $^) $@

# For some reason this XSLT causes a NPE in fop/xalan
%.fo: %-fo.xsl %.xml
	xsltproc -o $@ $< $(filter-out $<, $^)

clean:
	rm -f *.pdf *.fo

.SECONDARY: cards.fo
