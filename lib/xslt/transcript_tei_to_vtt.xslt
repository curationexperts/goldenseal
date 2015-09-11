<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei">
  <xsl:output method="text" encoding="utf-8" indent="yes" />
  <xsl:variable name="persNames" select="//tei:person" />
  <xsl:key name="teiRef" match="//tei:term" use="@xml:id" />

  <xsl:template match="tei:body">WEBVTT
kind: captions
lang: en
<xsl:apply-templates />
  </xsl:template>

  <!-- convert TEI timestamp 00:00:00:00 to WebVTT timestamp 00:00:00.000 -->
  <xsl:template match="tei:div2[@data-timecodebegin]">
    <xsl:text>

</xsl:text>
    <xsl:value-of select="substring(./@data-timecodebegin, 4)" />.000 --&gt; <xsl:value-of select="substring(./@data-timecodeend, 4)" />.000
<xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:sp/tei:speaker">&lt;v <xsl:value-of select="text()"/>&gt; </xsl:template>

  <xsl:template match="tei:sp/tei:p">
      <xsl:call-template name="string-trim">
        <xsl:with-param name="string" select="text()" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="text()" />

<xsl:variable name="whitespace" select="'&#09;&#10;&#13; '" />

<!-- Strips trailing whitespace characters from 'string' -->
<xsl:template name="string-rtrim">
    <xsl:param name="string" />
    <xsl:param name="trim" select="$whitespace" />

    <xsl:variable name="length" select="string-length($string)" />

    <xsl:if test="$length &gt; 0">
        <xsl:choose>
            <xsl:when test="contains($trim, substring($string, $length, 1))">
                <xsl:call-template name="string-rtrim">
                    <xsl:with-param name="string" select="substring($string, 1, $length - 1)" />
                    <xsl:with-param name="trim"   select="$trim" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
</xsl:template>

<!-- Strips leading whitespace characters from 'string' -->
<xsl:template name="string-ltrim">
    <xsl:param name="string" />
    <xsl:param name="trim" select="$whitespace" />

    <xsl:if test="string-length($string) &gt; 0">
        <xsl:choose>
            <xsl:when test="contains($trim, substring($string, 1, 1))">
                <xsl:call-template name="string-ltrim">
                    <xsl:with-param name="string" select="substring($string, 2)" />
                    <xsl:with-param name="trim"   select="$trim" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
</xsl:template>

<!-- Strips leading and trailing whitespace characters from 'string' -->
<xsl:template name="string-trim">
    <xsl:param name="string" />
    <xsl:param name="trim" select="$whitespace" />
    <xsl:call-template name="string-rtrim">
        <xsl:with-param name="string">
            <xsl:call-template name="string-ltrim">
                <xsl:with-param name="string" select="$string" />
                <xsl:with-param name="trim"   select="$trim" />
            </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="trim"   select="$trim" />
    </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
