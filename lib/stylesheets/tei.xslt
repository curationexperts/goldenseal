<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei" version="1.0">
    <xsl:output method="html" encoding="utf-8" indent="yes" />
    

    <xsl:template match="tei:text">
      <div id="tei-content">
        <xsl:attribute name="data-object"><xsl:value-of select="../@xml:id"/></xsl:attribute>
        <xsl:apply-templates/>
      </div>
    </xsl:template>

    <xsl:template match="tei:teiHeader"></xsl:template>

    <xsl:template match="tei:lb">
      <br/>
    </xsl:template>
    <xsl:template match="tei:head">
      <div class="tei-head">
        <xsl:apply-templates/>
      </div>
    </xsl:template>

    <xsl:template match="tei:list">
      <xsl:apply-templates select="tei:head"/>
      <ul>
        <xsl:apply-templates select="tei:item"/>
      </ul>
    </xsl:template>
    <xsl:template match="tei:item">
      <li>
        <xsl:apply-templates/>
      </li>
    </xsl:template>

    <xsl:template match="tei:table">
      <xsl:apply-templates select="tei:head"/>
      <table>
        <xsl:apply-templates select="tei:row"/>
      </table>
    </xsl:template>
    <xsl:template match="tei:row">
      <tr>
        <xsl:apply-templates/>
      </tr>
    </xsl:template>
    <xsl:template match="tei:cell">
      <td>
        <xsl:apply-templates/>
      </td>
    </xsl:template>

    <xsl:template match="tei:opener">
      <div class="opener">
        <xsl:apply-templates/>
      </div>
    </xsl:template>
    <xsl:template match="tei:note">
      <div class="note">
        <xsl:apply-templates/>
      </div>
    </xsl:template>

    <xsl:template match="tei:pb">
      <div class="pageheader">
        <xsl:attribute name="id">BOOKPAGE_<xsl:value-of select="@n"/></xsl:attribute>
        <xsl:attribute name="data-image"><xsl:value-of select="@facs"/><xsl:value-of select="@xml:id"/></xsl:attribute>
        Page <xsl:value-of select="@n"/>
      </div>
    </xsl:template>

    <xsl:template match="tei:date">
      <span class="date">
        <xsl:apply-templates/>
      </span>
    </xsl:template>
    <xsl:template match="tei:p">
      <p>
        <xsl:apply-templates/>
      </p>
    </xsl:template>
    <xsl:template match="tei:del">
      <del>
        <xsl:apply-templates/>
      </del>
    </xsl:template>
    <xsl:template match="tei:unclear">
      <span class="unclear">
        <xsl:attribute name="data-reason"><xsl:value-of select="@reason"/></xsl:attribute>
        <xsl:apply-templates/>
      </span>
    </xsl:template>

</xsl:stylesheet>

