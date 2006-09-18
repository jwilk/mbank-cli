<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:html='http://www.w3.org/1999/xhtml'>

<xsl:template match='ulink'>
	<html:a>
		<xsl:attribute name='href'><xsl:value-of select='@url'/></xsl:attribute>
		<xsl:apply-templates/>
	</html:a>
</xsl:template> 

<xsl:template match='/refentry'>
	<xsl:copy>
		<html:title>
			<xsl:value-of select='refentryinfo/title'/>
		</html:title>
		<html:link rel='stylesheet' href='style.css'/>
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>

<xsl:template match='*'>
	<xsl:copy>
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>

<!-- vim:set ts=4 sw=4 fenc=utf8: -->
