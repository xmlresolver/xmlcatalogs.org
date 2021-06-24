<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:e="http://www.w3.org/1999/XSL/Spec/ElementSyntax"
                xmlns:m="http://docbook.org/ns/docbook/modes"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:import href="https://cdn.docbook.org/release/xsltng/current/xslt/docbook.xsl"/>
<!--
<xsl:import href="/Users/ndw/Projects/docbook/xslTNG/build/xslt/docbook.xsl"/>
-->

<xsl:import href="elemsyntax.xsl"/>

<xsl:strip-space elements="e:*"/>

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>

<xsl:param name="persistent-toc" select="'true'"/>
<xsl:param name="annotation-placement" select="'before'"/>
<xsl:param name="css-links" select="'css/docbook.css css/docbook-screen.css css/catalogs.css'"/>

<xsl:template match="db:article" mode="m:generate-titlepage">
  <header>
    <xsl:if test="not(contains(db:info/db:title, 'Annotations'))
                  and not(contains(@status, 'Annotations'))">
      <div class="disclaimer">
        <p>This is an unofficial copy of the
        <a href="https://www.oasis-open.org/committees/download.php/14809/xml-catalogs.html">official
        OASIS standard</a>.
        It’s been run it through some more modern stylesheets and
        restyled slightly for legibility, but is otherwise a
        word-for-word copy of the OASIS Standard. Annotations to the specification
        appear throughout. They are non-normative and not part of the specification.
        To view an annotation, click on its “⌖” mark. A <a href="catalogs-1.1-annotations.html">list
        of the annotations</a> is also available. This annotated version was published on
        <xsl:value-of select="format-date(current-date(), '[D01] [MNn,*-3] [Y0001]')"/>.</p>
      </div>
    </xsl:if>
    <h1>
      <xsl:apply-templates select="db:info/db:title/node()"/>
    </h1>
    <xsl:if test="@status">
      <h2>
        <xsl:value-of select="@status"/>
        <xsl:if test="db:info/db:productnumber">
          <xsl:text> V</xsl:text>
          <xsl:value-of select="db:info/db:productnumber"/>
        </xsl:if>
        <xsl:text>, </xsl:text>
        <xsl:choose>
          <xsl:when test="db:info/db:pubdate castable as xs:date">
            <xsl:variable name="date"
                          select="xs:date(db:info/db:pubdate)"/>
            <xsl:value-of select='format-date($date,
			              "[D01] [MNn,*-3] [Y0001]")'/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="db:info/db:pubdate"/>
          </xsl:otherwise>
        </xsl:choose>
      </h2>
    </xsl:if>
    <dl>
      <xsl:if test="db:info/db:productname">
        <dt>
          <span class="docid-heading">Document identifier:</span>
        </dt>
        <dd>
          <xsl:value-of select="db:info/db:productname"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="db:info/db:productnumber"/>
          <xsl:text> (</xsl:text>
          <xsl:for-each select="db:info/db:releaseinfo[@role='product']">
            <xsl:if test="preceding-sibling::db:releaseinfo[@role='product']">, </xsl:if>
            <xsl:apply-templates mode="m:docbook"/>
          </xsl:for-each>
          <xsl:text>)</xsl:text>
        </dd>
      </xsl:if>
      <xsl:if test="db:info/db:releaseinfo[@role='location']">
        <dt>
          <span class="loc-heading">Location:</span>
        </dt>
        <dd>
          <a href="{db:info/db:releaseinfo[@role='location']}">
            <xsl:value-of select="db:info/db:releaseinfo[@role='location']"/>
          </a>
        </dd>
      </xsl:if>
      <dt>
        <span class="editor-heading">Editor</span>
      </dt>
      <dd>
        <xsl:apply-templates select="db:info/db:authorgroup/db:editor" mode="m:docbook"/>
      </dd>
      <dt>
        <span class="abstract-heading">Abstract:</span>
      </dt>
      <dd>
        <xsl:apply-templates select="db:info/db:abstract" mode="m:docbook"/>
      </dd>
      <dt>
        <span class="status-heading">Status:</span>
      </dt>
      <dd>
        <xsl:apply-templates select="db:info/db:legalnotice/db:para"
                             mode="m:docbook"/>
      </dd>
    </dl>
    <xsl:apply-templates select="db:info/db:copyright" mode="m:docbook"/>
  </header>
</xsl:template>

<xsl:template match="db:releaseinfo/db:link" mode="m:docbook"
              xmlns:xlink="http://www.w3.org/1999/xlink">
  <a href="https://www.oasis-open.org/committees/download.php/14809/{@xlink:href}">
    <xsl:apply-templates mode="m:docbook"/>
  </a>
</xsl:template>

<xsl:template match="db:shortaffil" mode="m:docbook"/>

<xsl:template match="db:affiliation" mode="m:docbook">
  <xsl:text>, </xsl:text>
  <span class="{local-name(.)}">
    <xsl:apply-templates mode="m:docbook"/>
  </span>
</xsl:template>

<xsl:template match="db:affiliation/db:address" mode="m:docbook">
  <xsl:apply-templates mode="m:docbook"/>
</xsl:template>

<xsl:template match="db:affiliation/db:address/db:email" mode="m:docbook">
  <xsl:text> </xsl:text>
  <xsl:text>&lt;</xsl:text>
  <a href="mailto:{.}"><code class="email"><xsl:value-of select="."/></code></a>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="db:glossterm" mode="m:docbook">
  <em class="glossterm">
    <xsl:apply-templates/>
  </em>
</xsl:template>

</xsl:stylesheet>
