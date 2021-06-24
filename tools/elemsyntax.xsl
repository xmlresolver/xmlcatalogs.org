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
    <pre>
      <code>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates/>

        <xsl:choose>
          <xsl:when test="e:empty">
            <xsl:text> /&gt;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>&#10;&lt;/</xsl:text>
            <xsl:value-of select="@name"/>
            <xsl:text>&gt;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </code>
    </pre>
  </div>
</xsl:template>

<xsl:template match="e:attribute">
  <xsl:text>    </xsl:text>
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
        <xsl:if test="position() gt 1"> | </xsl:if>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@value"/>
        <xsl:text>"</xsl:text>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes" select="'Unexpected attribute content'"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="following-sibling::*[1]/self::e:empty">
      <!-- nop -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="e:choice">
  <xsl:text>  &lt;!-- Content: (</xsl:text>

  <xsl:if test="* except e:element">
    <xsl:message terminate="yes" select="'Unexpected element content'"/>
  </xsl:if>

  <xsl:call-template name="format-elements">
    <xsl:with-param name="elements" select="e:element"/>
  </xsl:call-template>

  <xsl:text>)+ --&gt;</xsl:text>
</xsl:template>

<xsl:template name="format-elements">
  <xsl:param name="elements" as="element(e:element)+"/>
  <xsl:param name="width" as="xs:integer" select="0"/>

  <xsl:variable name="element" select="$elements[1]"/>
  <xsl:variable name="rest" select="subsequence($elements, 2)"/>

  <xsl:if test="$width gt 35">
    <xsl:text>&#10;                </xsl:text>
  </xsl:if>

  <xsl:variable name="next-width"
                select="if ($width gt 35)
                        then string-length($element/@name)
                        else $width + string-length($element/@name)"/>

  <xsl:if test="$element/preceding-sibling::e:element"> | </xsl:if>

  <a href="#element-{$element/@name}">
    <xsl:value-of select="$element/@name"/>
  </a>

  <xsl:if test="exists($rest)">
    <xsl:call-template name="format-elements">
      <xsl:with-param name="elements" select="$rest"/>
      <xsl:with-param name="width" select="$next-width"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="e:empty"/>

</xsl:stylesheet>
