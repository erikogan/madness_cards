<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsp="http://www.apache.org/1999/XSP/Core"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:strip-space elements="*"/>

  <xsl:param name="short-image">images/short.jpg</xsl:param><!-- https://cyliondraw.deviantart.com/art/Death-City-308883109 ©2012-2018 CylionDraw -->
  <xsl:param name="long-image">images/long.png</xsl:param><!-- https://skyrawathi.deviantart.com/art/Devil-2-642641650 ©2016-2018 Skyrawathi -->
  <xsl:param name="indefinite-image">images/indefinite.jpg</xsl:param><!-- https://m-delcambre.deviantart.com/art/Give-the-power-Cinematic-636055290 CC-A-NC-ND -->

  <xsl:template match="/">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:layout-master-set>
        <fo:simple-page-master master-name="master" page-height="3.5in" page-width="2.5in">
          <fo:region-body margin="0.25in" />
          <fo:region-before extent="3.5in" background-color="#000000"/>
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="deck">
          <fo:repeatable-page-master-reference master-reference="master"/>
        </fo:page-sequence-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="deck" initial-page-number="1" language="en" country="US">
        <fo:flow flow-name="xsl-region-body">
          <xsl:apply-templates/>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template match="card">
    <fo:block page-break-before="always" font-size="10pt" color="#ff0000">
      <fo:block>
        <fo:external-graphic content-width="2.0in">
          <xsl:attribute name="src">
            <xsl:choose>
              <xsl:when test="@duration = 'Indefinite'"><xsl:value-of select="$indefinite-image"/></xsl:when>
              <xsl:when test="@duration = 'Long'"><xsl:value-of select="$long-image"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="$short-image"/></xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </fo:external-graphic>
      </fo:block>

      <fo:block font-size="6pt" text-align="end">
        <xsl:value-of select="@duration" />
        <xsl:if test="@duration != 'Indefinite'">
          <xsl:text>-Term</xsl:text>
        </xsl:if>
        <xsl:text> Madness</xsl:text>
      </fo:block>

      <xsl:apply-templates select="title" />
      <xsl:apply-templates select="description" />
      <xsl:apply-templates select="acting" />
    </fo:block>
  </xsl:template>

  <xsl:template match="title">
    <fo:block font-weight="bold" margin-top="0.5em">
      <xsl:apply-templates />
    </fo:block>
  </xsl:template>

  <xsl:template match="description">
    <fo:block font-size="8pt">
      <xsl:apply-templates />
    </fo:block>
  </xsl:template>

  <xsl:template match="acting">
      <fo:block font-style="italic" margin-top="0.5em" font-size="8pt">
        <xsl:text>Acting tip: </xsl:text>
        <xsl:apply-templates />
      </fo:block>
  </xsl:template>

  <xsl:template match="line">
    <fo:block>
      <xsl:apply-templates />
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
