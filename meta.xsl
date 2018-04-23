<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <xsl:param name="genMode">Fail me!</xsl:param>

  <!-- xsl:strip-space elements="*" / -->

  <xsl:strip-space elements="*"/>
  <xsl:template match="description|acting">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="count(line) = 1">
          <xsl:copy-of select="@*"/>
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
