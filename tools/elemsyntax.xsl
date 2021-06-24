<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:e="http://www.w3.org/1999/XSL/Spec/ElementSyntax"
                xmlns:m="http://docbook.org/ns/docbook/modes"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                default-mode="m:docbook"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:template match="e:element-syntax">
  <div class="element-syntax" id="element-{@name}">
    <div class="e-stag">
      <code>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="@name"/>
      </code>
    </div>

    <xsl:apply-templates/>

    <xsl:choose>
      <xsl:when test="e:empty">
        <!-- nop -->
      </xsl:when>
      <xsl:otherwise>
        <div class="e-etag">
          <code>
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="@name"/>
            <xsl:text>&gt;</xsl:text>
          </code>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="e:attribute">
  <div class="e-attr">
    <code>
      <xsl:value-of select="@name"/>
      <xsl:text> = </xsl:text>
      <xsl:choose>
        <xsl:when test="e:data-type">
          <span class="datatype">
            <xsl:value-of select="e:data-type/@name"/>
          </span>
        </xsl:when>
        <xsl:when test="e:constant">
          <xsl:for-each select="e:constant">
            <xsl:if test="position() gt 1"> | </xsl:if>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="@value"/>
            <xsl:text>"</xsl:text>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes" select="'Unexpected attribute content'"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="following-sibling::*[1]/self::e:empty">
        <xsl:text> /&gt;</xsl:text>
      </xsl:if>
    </code>
  </div>
</xsl:template>

<xsl:template match="e:choice">
  <xsl:if test="* except e:element">
    <xsl:message terminate="yes" select="'Unexpected element content'"/>
  </xsl:if>

  <div class="e-choice">
    <code>
      <xsl:text>  &lt;!-- Content: (</xsl:text>
    </code>

    <xsl:for-each select="e:element">
      <xsl:if test="position() gt 1"> | </xsl:if>
      <code>
        <a href="#element-{@name}">
          <xsl:value-of select="@name"/>
        </a>
      </code>
    </xsl:for-each>

    <code>
      <xsl:text>)+ --&gt;</xsl:text>
    </code>
  </div>
</xsl:template>

<xsl:template match="e:empty"/>

</xsl:stylesheet>
