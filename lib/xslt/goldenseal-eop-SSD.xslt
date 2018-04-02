<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:smil="http://www.w3.org/2001/SMIL20/"		
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
  <xsl:template match="tei:div2[@smil:begin]">
    <xsl:text>

</xsl:text>
    <xsl:value-of select="substring(./@smil:begin, 0, 9)" />.000 --&gt; <xsl:value-of select="substring(./@smil:end, 0, 9)" />.000
<xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:sp/tei:speaker">&lt;v <xsl:value-of select="text()"/>&gt; </xsl:template>

  <xsl:template match="tei:sp/tei:p">
    <xsl:copy-of select="normalize-space()"/>
  </xsl:template>

<!--SSD edited so text in incident/desc would display-->
<xsl:template match="tei:incident/tei:desc">
    <xsl:copy-of select="normalize-space()"/>
  </xsl:template>


  <xsl:template match="text()" />


</xsl:stylesheet>
