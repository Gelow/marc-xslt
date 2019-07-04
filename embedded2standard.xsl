<?xml version="1.0" encoding="UTF-8"?>
<!--
	This XSL is for UNIMARC flavoured marc21xml file.
It transforms 4xx field embedded subfields ($1) to standard subfields.
© 2019 Oleg Vasylenko --> 
<xsl:stylesheet version="1.0" exclude-result-prefixes="marc"
	xmlns="http://www.loc.gov/MARC21/slim"
	xmlns:marc="http://www.loc.gov/MARC21/slim"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<collection xmlns="http://www.loc.gov/MARC21/slim" 
					xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
			<xsl:for-each select="marc:collection">
				<xsl:for-each select="marc:record">
					<record>
						<xsl:for-each select="marc:leader">
							<leader>
								<xsl:value-of select="text()"/>
							</leader>
						</xsl:for-each>
						<xsl:for-each select="marc:controlfield">
							<controlfield>
								<xsl:attribute name="tag">
									<xsl:value-of select="@tag"/>
								</xsl:attribute>
								<xsl:value-of select="text()"/>
							</controlfield>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield">
							<datafield>
								<xsl:attribute name="tag">
									<xsl:value-of select="@tag"/>
								</xsl:attribute>
								<xsl:attribute name="ind1">
									<xsl:value-of select="@ind1"/>
								</xsl:attribute>
								<xsl:attribute name="ind2">
									<xsl:value-of select="@ind2"/>
								</xsl:attribute>
								<xsl:choose>
									<xsl:when test="(starts-with(@tag, '4') or @tag='576' or @tag='604') and marc:subfield[@code = '1']" >
										<xsl:for-each select="marc:subfield[@code = '1']">
											<xsl:variable name="embeddedField"><xsl:value-of select="substring(text(), 1, 3)"/></xsl:variable>
											<xsl:choose>
												<xsl:when test="starts-with($embeddedField, '001')" >
													<subfield code="0">
														<xsl:value-of select="substring(text(), 4)"/>
													</subfield>
												</xsl:when>
												<xsl:when test="starts-with($embeddedField, '7')" >
													<xsl:call-template name="compileAccessPoint">
														<xsl:with-param name="field" select="$embeddedField"/>
														<xsl:with-param name="ind1" select="substring(text(), 3, 1)"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:for-each select="following-sibling::marc:subfield[not(@code='1')][generate-id(preceding-sibling::marc:subfield[@code='1'][1]) = generate-id(current())]">
														<xsl:call-template name="convert1ToStandardFields">
															<xsl:with-param name="field" select="$embeddedField"/>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="marc:subfield">
											<xsl:call-template name="copySubfield"></xsl:call-template>
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</datafield>
						</xsl:for-each>
						
					</record>
				</xsl:for-each>
			</xsl:for-each>
		</collection>
	</xsl:template>
	
	<xsl:template name="copySubfield">
		<subfield xmlns="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="code">
				<xsl:value-of select="@code"/>
			</xsl:attribute>
			<xsl:value-of select="text()"/>
		</subfield>
	</xsl:template>
		
	<xsl:template name="convert1ToStandardFields">
		<xsl:param name="field"></xsl:param>
		<subfield xmlns="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="code">
				<xsl:choose>
					<xsl:when test="$field = '010'">
						<xsl:value-of select="translate (@code, 'a', 'y')" />
					</xsl:when>
					<xsl:when test="$field = '011'">
						<xsl:value-of select="translate (@code, 'a', 'x')" />
					</xsl:when>
					<xsl:when test="$field = '013'">
						<xsl:value-of select="translate (@code, 'a', 'm')" />
					</xsl:when>
					<xsl:when test="$field = '200'">
						<xsl:value-of select="translate (@code, 'ade', 'tlo')" />
					</xsl:when>
					<xsl:when test="$field = '205'">
						<xsl:value-of select="translate (@code, 'a', 'e')" />
					</xsl:when>
					<xsl:when test="$field = '210'">
						<xsl:value-of select="translate (@code, 'ac', 'cn')" />
					</xsl:when>
					<xsl:when test="$field = '215'">
						<xsl:value-of select="translate (@code, 'a', 'p')" />
					</xsl:when>
					<xsl:when test="$field = '225'">
						<xsl:value-of select="translate (@code, 'a', 's')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>WARNSubfConv</xsl:text>
						<xsl:value-of select="@code" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="text()"/>
		</subfield>
	</xsl:template>

	<xsl:template name="compileAccessPoint">
		<xsl:param name="field"></xsl:param>
		<xsl:param name="ind1"></xsl:param>
		
		<xsl:variable name="sfA">
			<xsl:value-of select="following-sibling::marc:subfield[not(@code='1')][@code = 'a'][generate-id(preceding-sibling::marc:subfield[@code='1'][1]) = generate-id(current())]"/>
		</xsl:variable>
		<xsl:variable name="sfB">
			<xsl:value-of select="following-sibling::marc:subfield[not(@code='1')][@code = 'b'][generate-id(preceding-sibling::marc:subfield[@code='1'][1]) = generate-id(current())]"/>
		</xsl:variable>
		<xsl:variable name="sfC">
			<xsl:value-of select="following-sibling::marc:subfield[not(@code='1')][@code = 'c'][generate-id(preceding-sibling::marc:subfield[@code='1'][1]) = generate-id(current())]"/>
		</xsl:variable>
		<xsl:variable name="sfD">
			<xsl:value-of select="following-sibling::marc:subfield[not(@code='1')][@code = 'd'][generate-id(preceding-sibling::marc:subfield[@code='1'][1]) = generate-id(current())]"/>
		</xsl:variable>
		<xsl:variable name="sfF">
			<xsl:value-of select="following-sibling::marc:subfield[not(@code='1')][@code = 'f'][generate-id(preceding-sibling::marc:subfield[@code='1'][1]) = generate-id(current())]"/>
		</xsl:variable>
		<xsl:variable name="sfG">
			<xsl:value-of select="following-sibling::marc:subfield[not(@code='1')][@code = 'g'][generate-id(preceding-sibling::marc:subfield[@code='1'][1]) = generate-id(current())]"/>
		</xsl:variable>
		<xsl:variable name="sfP">
			<xsl:value-of select="following-sibling::marc:subfield[not(@code='1')][@code = 'p'][generate-id(preceding-sibling::marc:subfield[@code='1'][1]) = generate-id(current())]"/>
		</xsl:variable>
		
		<subfield xmlns="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="code">
				<xsl:if test="starts-with($field, '7')">
					<xsl:text>a</xsl:text> 
				</xsl:if>
			</xsl:attribute>
			<xsl:value-of select="$sfA" />
			<xsl:choose>
				<xsl:when test="$sfG!=''">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$sfG" /> 
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$sfB!=''">
						<xsl:text>, </xsl:text> 
						<xsl:value-of select="$sfB" /> 
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$sfC!=''">
				<xsl:text>,</xsl:text> 
				<xsl:value-of select="$sfC" /> 
			</xsl:if>
			<xsl:if test="$sfD!=''">
				<xsl:text> </xsl:text> 
				<xsl:value-of select="$sfD" /> 
			</xsl:if>
			<xsl:if test="$sfF!=''">
				<xsl:text> (</xsl:text> 
				<xsl:value-of select="$sfF" /> 
				<xsl:text>)</xsl:text> 
			</xsl:if>
			
			<xsl:if test="$sfP!=''">
				<xsl:text> </xsl:text> 
				<xsl:value-of select="$sfP" /> 
			</xsl:if>
			
		</subfield>
	</xsl:template>
	
</xsl:stylesheet>
	