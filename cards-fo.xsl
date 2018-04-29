<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsp="http://www.apache.org/1999/XSP/Core"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:dyn="http://exslt.org/dynamic"
                extension-element-prefixes="dyn">

  <xsl:strip-space elements="*"/>


  <xsl:variable name="durations">
    <duration name="Short">
      <image type="main" src="/tmp/images/short.jpg"/>
      <link href="https://cyliondraw.deviantart.com/art/Death-City-308883109"/>
      <attribution>© 2012-2018 CylionDraw</attribution>
      <color type="attribution">#18310f</color>
      <color type="text">#356d21</color>
      <image type="title" src="/tmp/images/title-short.png"/>
      <text>1d10 rounds</text>
    </duration>
    <duration name="Long">
      <image type="main" src="/tmp/images/long.png"/>
      <link href="https://skyrawathi.deviantart.com/art/Devil-2-642641650"/>
      <attribution>© 2016-2018 Skyrawathi</attribution>
      <color type="attribution">#ab9873</color>
      <color type="text">#b59a64</color>
      <image type="title" src="/tmp/images/title-long.png"/>
      <text>one session</text>
    </duration>
    <duration name="Indefinite">
      <image type="main" src="/tmp/images/indefinite.jpg"/>
      <link href="https://m-delcambre.deviantart.com/art/Give-the-power-Cinematic-636055290"/>
      <attribution>(CC BY-NC-ND) M-Delcambre</attribution>
      <color type="attribution">#ffffff</color>
      <color type="text">#b31b2e</color>
      <image type="title" src="/tmp/images/title-indefinite.png"/>
      <text>until cured</text>
    </duration>
  </xsl:variable>

  <!-- xsl:variable name="title-size">10pt</xsl:variable -->
  <xsl:variable name="title-size">8pt</xsl:variable>
  <xsl:variable name="rules-size">8pt</xsl:variable>
  <xsl:variable name="duration-size">6pt</xsl:variable>

  <xsl:variable name="acting-image-source">/tmp/images/Comedy_and_tragedy_masks_without_background.svg</xsl:variable>

  <xsl:template match="/">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:layout-master-set>
        <fo:simple-page-master master-name="master" page-height="3.5in" page-width="2.5in">
          <fo:region-body margin="0.25in" />
          <fo:region-before extent="3.5in" background-color="#000000"/>
          <fo:region-after region-name="card-after" extent="20pt"/>
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="deck">
          <fo:repeatable-page-master-reference master-reference="master"/>
        </fo:page-sequence-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="deck" initial-page-number="1" language="en" country="US">
        <fo:static-content flow-name="card-after">
          <fo:block font-size="{$duration-size}" margin-right="0.25in" margin-bottom="0.125in" font-family="Cochin" text-align="end">
            <fo:retrieve-marker retrieve-class-name="durationText"
                      retrieve-position="first-including-carryover"
                      retrieve-boundary="page"/>
          </fo:block>
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
          <xsl:apply-templates select="cards/card[not(@enabled) or @enabled != 'false']" />
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template match="card">
    <fo:block page-break-before="always" font-size="{$rules-size}" font-family="Cochin" color="#000000">
      <fo:marker marker-class-name="durationText">
        <fo:block>
          <xsl:attribute name="color">
            <xsl:call-template name="duration-value">
              <xsl:with-param name="duration" select="@duration"/>
              <xsl:with-param name="path">color[@type = 'text']</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Lasts </xsl:text>
          <xsl:call-template name="duration-value">
            <xsl:with-param name="duration" select="@duration"/>
            <xsl:with-param name="path">text</xsl:with-param>
          </xsl:call-template>
        </fo:block>
      </fo:marker>

      <fo:block>
        <fo:external-graphic content-width="2.0in">
          <xsl:attribute name="src">
            <xsl:call-template name="duration-value">
              <xsl:with-param name="duration" select="@duration"/>
              <xsl:with-param name="path">image[@type = 'main']/@src</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </fo:external-graphic>
      </fo:block>

      <fo:block font-size="{$duration-size}" text-align="end" margin-bottom="0pt" margin-top="-10pt" margin-right="4pt">
        <xsl:attribute name="color">
          <xsl:call-template name="duration-value">
            <xsl:with-param name="duration" select="@duration"/>
            <xsl:with-param name="path">color[@type = 'text']</xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:value-of select="@duration" />
        <xsl:if test="@duration != 'Indefinite'">
          <xsl:text>-Term</xsl:text>
        </xsl:if>
        <xsl:text> Madness</xsl:text>
      </fo:block>

      <xsl:apply-templates select="title" />

      <fo:block background-image="/tmp/images/paper_full.png"
                background-repeat="no-repeat"
                background-position-horizontal="center"
                background-position-vertical="top">
        <xsl:apply-templates select="description" />
        <xsl:apply-templates select="acting" />
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="title">
    <fo:block-container position="absolute" top="-4pt" left="-4pt">
    <fo:block font-weight="bold" color="#ffffff" font-size="{$title-size}" margin-bottom="-10pt">
      <fo:inline padding="1pt" padding-left="4pt" padding-right="6pt"
                 background-repeat="no-repeat"
                 background-position-horizontal="right"
                 background-position-vertical="top">
        <xsl:attribute name="background-image">
          <xsl:call-template name="duration-value">
            <xsl:with-param name="duration" select="../@duration"/>
            <xsl:with-param name="path">image[@type = 'title']/@src</xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates />
      </fo:inline>
    </fo:block>
  </fo:block-container>
  </xsl:template>

  <xsl:template match="description" hyphenate="true">
    <fo:block font-size="{$rules-size}" padding-bottom="4pt"
              background-image="/tmp/images/parchment_full.png"
              background-repeat="repeat-x"
              background-position-horizontal="center"
              background-position-vertical="bottom">
      <fo:block margin="4pt">
        <xsl:apply-templates />
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="acting" hyphenate="true">
    <fo:block font-style="italic" font-size="{$rules-size}">
      <fo:block margin="4pt">
        <fo:external-graphic src="{$acting-image-source}" content-height="{$rules-size}" content-width="scale-to-fit"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates />
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="line">
    <fo:block>
      <xsl:apply-templates />
    </fo:block>
  </xsl:template>

  <xsl:template match="acting//em">
    <fo:inline font-style="normal" font-weight="bold"><!-- text-decoration="underline" -->
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="em">
    <fo:inline font-style="italic">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <xsl:template name="duration-value">
    <xsl:param name="duration"/>
    <xsl:param name="path" />
    <xsl:variable name="value-query">document('')//xsl:variable[@name='durations']/duration[@name = '<xsl:value-of select="$duration"/>']/<xsl:value-of select="$path"/></xsl:variable>
    <xsl:value-of select="dyn:evaluate($value-query)"/>
  </xsl:template>
</xsl:stylesheet>
