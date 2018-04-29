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
      <color type="title">#b4d8a8</color>
      <color type="type">#356d21</color>
      <color type="duration">#b4d8a8</color>
      <color type="attribution">#18310f</color>
      <image type="title" src="/tmp/images/title-short.png"/>
      <image type="duration-tab" src="/tmp/images/tab-short.png"/><!-- this image has been vertically scaled to 1/6" from the source -->
      <text>1d10 rounds</text>
    </duration>
    <duration name="Long">
      <image type="main" src="/tmp/images/long.png"/>
      <link href="https://skyrawathi.deviantart.com/art/Devil-2-642641650"/>
      <attribution>© 2016-2018 Skyrawathi</attribution>
      <color type="title">#d9caab</color>
      <color type="type">#d9caab</color>
      <color type="duration">#d9caab</color>
      <color type="attribution">#ab9873</color>
      <image type="title" src="/tmp/images/title-long.png"/>
      <image type="duration-tab" src="/tmp/images/tab-long.png"/><!-- this image has been vertically scaled to 1/6" from the source -->
      <text>one session</text>
    </duration>
    <duration name="Indefinite">
      <image type="main" src="/tmp/images/indefinite.jpg"/>
      <link href="https://m-delcambre.deviantart.com/art/Give-the-power-Cinematic-636055290"/>
      <attribution>(CC BY-NC-ND) M-Delcambre</attribution>
      <color type="title">#e8b0b7</color>
      <color type="type">#b31b2e</color>
      <color type="duration">#e8b0b7</color>
      <color type="attribution">#ffffff</color>
      <image type="title" src="/tmp/images/title-indefinite.png"/>
      <image type="duration-tab" src="/tmp/images/tab-indefinite.png"/><!-- this image has been vertically scaled to 1/6" from the source -->
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
          <fo:retrieve-marker retrieve-class-name="durationTab"
                    retrieve-position="first-including-carryover"
                    retrieve-boundary="page"/>
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
          <xsl:apply-templates select="cards/card[not(@enabled) or @enabled != 'false']" />
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template match="card">
    <fo:block page-break-before="always" font-size="{$rules-size}" font-family="Cochin" color="#000000">
      <fo:marker marker-class-name="durationTab">
        <fo:block padding="2pt" text-align="center"
                  font-family="Cochin" font-size="{$duration-size}"
                  background-repeat="no-repeat"
                  background-position-horizontal="center">
          <xsl:attribute name="background-image">
            <xsl:call-template name="duration-value">
              <xsl:with-param name="duration" select="@duration"/>
              <xsl:with-param name="path">image[@type = 'duration-tab']/@src</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="margin-top">
            <xsl:choose>
              <xsl:when test="acting">-12.25pt</xsl:when>
              <xsl:otherwise>-13.25pt</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="color">
            <xsl:call-template name="duration-value">
              <xsl:with-param name="duration" select="@duration"/>
              <xsl:with-param name="path">color[@type = 'duration']</xsl:with-param>
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
            <xsl:with-param name="path">color[@type = 'type']</xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:value-of select="@duration" />
        <xsl:if test="@duration != 'Indefinite'">
          <xsl:text>-Term</xsl:text>
        </xsl:if>
        <xsl:text> Madness</xsl:text>
      </fo:block>

      <xsl:apply-templates select="title" />

      <fo:block-container background-repeat="no-repeat"
                          background-position-horizontal="center"
                          background-position-vertical="top"
                          height="1.55in">
        <xsl:attribute name="background-image">
          <xsl:choose>
            <xsl:when test="acting">/tmp/images/paper_full.png</xsl:when>
            <xsl:otherwise>/tmp/images/parchment_full.png</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates select="description" />
        <xsl:apply-templates select="acting" />
      </fo:block-container>
    </fo:block>
  </xsl:template>

  <xsl:template match="title">
    <fo:block-container position="absolute" top="-4pt" left="-4pt">
    <fo:block font-weight="bold" margin-bottom="-10pt">
      <xsl:attribute name="font-size">
        <xsl:choose>
          <xsl:when test="@shrink">7pt</xsl:when>
          <xsl:otherwise><xsl:value-of select="$title-size"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <fo:inline padding="1pt" padding-left="4pt" padding-right="6pt"
                 background-repeat="no-repeat"
                 background-position-horizontal="right"
                 background-position-vertical="top">
        <xsl:attribute name="color">
          <xsl:call-template name="duration-value">
            <xsl:with-param name="duration" select="../@duration"/>
            <xsl:with-param name="path">color[@type = 'title']</xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>
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
              background-repeat="repeat-x"
              background-position-horizontal="center"
              background-position-vertical="bottom">
      <xsl:attribute name="background-image">
        <xsl:if test="../acting">/tmp/images/parchment_half.png</xsl:if>
      </xsl:attribute>
      <fo:block margin="4pt">
        <xsl:apply-templates />
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="acting" hyphenate="true">
    <fo:block font-style="italic" font-size="{$rules-size}" start-indent="11pt" text-indent="-11pt">
      <fo:block margin="4pt">
        <xsl:attribute name="margin-top">
          <xsl:choose>
            <xsl:when test="@tight">0pt</xsl:when>
            <xsl:otherwise>4pt</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>

        <xsl:choose>
          <xsl:when test="line">
            <xsl:apply-templates />
          </xsl:when>
          <xsl:otherwise>
            <fo:external-graphic src="{$acting-image-source}" content-height="{$rules-size}" content-width="scale-to-fit"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates />
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="acting/line[position() = 1]">
    <fo:block start-indent="11pt" text-indent="-11pt" margin-left="4pt">
      <fo:external-graphic src="{$acting-image-source}" content-height="{$rules-size}" content-width="scale-to-fit"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates />
    </fo:block>
  </xsl:template>

  <xsl:template match="acting/line[position() != 1]">
    <fo:block text-indent="0pt" margin-left="4pt">
      <xsl:attribute name="space-before">
        <xsl:choose>
          <xsl:when test="../@tight">4pt</xsl:when>
          <xsl:otherwise>6pt</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates />
    </fo:block>

  </xsl:template>

  <xsl:template match="line">
    <fo:block>
      <xsl:if test="position() != 1">
        <xsl:attribute name="space-before">
          <xsl:choose>
            <xsl:when test="../@tight">4pt</xsl:when>
            <xsl:otherwise>6pt</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
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
