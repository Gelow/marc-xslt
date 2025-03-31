<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="marc" xmlns="http://www.loc.gov/MARC21/slim"
	xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<collection xmlns="http://www.loc.gov/MARC21/slim"
			xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
			<xsl:for-each select="marc:collection">
				<xsl:for-each select="marc:record">
					<record type="Authority" format="UNIMARC">
						<xsl:for-each select="marc:leader">
							<leader>
								<xsl:variable name="recordLenght">00000</xsl:variable>
								<xsl:variable name="recordStatus">
									<xsl:choose>
										<xsl:when test="substring(text(), 6, 1) = 'a'">n</xsl:when>
										<xsl:when test="substring(text(), 6, 1) = 's'">d</xsl:when>
										<xsl:when test="substring(text(), 6, 1) = 'x'">d</xsl:when>
										<xsl:when test="substring(text(), 6, 1) = 'o'">d</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(text(), 6, 1)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="recordType">
									<xsl:choose>
										<xsl:when
											test="substring(text(), 7, 1) = 'z' and substring(../marc:controlfield[@tag = '008'], 10, 1) = 'c'"
											>y</xsl:when>
										<xsl:when
											test="substring(text(), 7, 1) = 'z' and substring(../marc:controlfield[@tag = '008'], 10, 1) = 'b'"
											>z</xsl:when>
										<xsl:when test="substring(text(), 7, 1) = 'z'">x</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(text(), 7, 1)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- Fixme: add Type of Entity. In marc21 it is stored not in the leader -->
								<xsl:variable name="entityType">
									<xsl:value-of select="' '"/>
								</xsl:variable>
								<xsl:variable name="baseAddressOfData">02200</xsl:variable>
								<xsl:variable name="encodingLevel">
									<xsl:choose>
										<xsl:when test="substring(text(), 18, 1) = 'n'">
											<xsl:value-of select="' '"/>
										</xsl:when>
										<xsl:when test="substring(text(), 18, 1) = 'o'">3</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="' '"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- Fixme: symbol 19 contains Punctuation policy. Better to use it somewhere -->
								<xsl:value-of
									select="concat($recordLenght, $recordStatus, $recordType, '  ', $entityType, '22', $baseAddressOfData, $encodingLevel, '  45  ')"
								/>
							</leader>
						</xsl:for-each>
						<xsl:for-each select="marc:controlfield[@tag = '001']">
							<controlfield tag="001">
								<xsl:value-of select="text()"/>
							</controlfield>
						</xsl:for-each>
						<xsl:for-each select="marc:controlfield[@tag = '005']">
							<controlfield tag="005">
								<xsl:value-of select="text()"/>
							</controlfield>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '024']">
							<xsl:choose>
								<xsl:when test="@ind1 = '7' and marc:subfield[@code = '2'] = 'isni'">
									<datafield tag="010" ind1=" " ind2=" ">
										<xsl:for-each select="marc:subfield[@code = 'a']">
											<subfield code="a">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
										<xsl:for-each select="marc:subfield[@code = 'z']">
											<subfield code="z">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
									</datafield>
								</xsl:when>
								<xsl:when test="marc:subfield[@code = 'a']">
									<datafield tag="035" ind1=" " ind2=" ">
										<xsl:variable name="source024">
											<xsl:choose>
												<xsl:when test="marc:subfield[@code = '2']">
												<xsl:value-of
												select="concat('(', marc:subfield[@code = '2'], ')')"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="''"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:for-each select="marc:subfield[@code = 'a']">
											<subfield code="a">
												<xsl:value-of select="concat($source024, text())"/>
											</subfield>
										</xsl:for-each>
										<xsl:for-each select="marc:subfield[@code = 'z']">
											<subfield code="z">
												<xsl:value-of select="concat($source024, text())"/>
											</subfield>
										</xsl:for-each>
									</datafield>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '010']">
							<datafield tag="035" ind1=" " ind2=" ">
								<xsl:for-each select="marc:subfield[@code = 'a']">
									<subfield code="a">
										<xsl:value-of select="concat('(US-dlc)', text())"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'z']">
									<subfield code="z">
										<xsl:value-of select="concat('(US-dlc)', text())"/>
									</subfield>
								</xsl:for-each>
							</datafield>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '016']">
							<datafield tag="035" ind1=" " ind2=" ">
								<xsl:variable name="nationalBibAgency">
									<xsl:choose>
										<xsl:when test="@ind1 = ' '">(CA-OONL)</xsl:when>
										<xsl:when test="@ind1 = '7'">
											<xsl:value-of
												select="concat('(', marc:subfield[@code = '2'], ')')"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:for-each select="marc:subfield[@code = 'a']">
									<subfield code="a">
										<xsl:value-of select="concat($nationalBibAgency, text())"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'z']">
									<subfield code="z">
										<xsl:value-of select="concat($nationalBibAgency, text())"/>
									</subfield>
								</xsl:for-each>
							</datafield>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '035']">
							<datafield tag="035" ind1=" " ind2=" ">
								<xsl:for-each select="marc:subfield[@code = 'a']">
									<subfield code="a">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'z']">
									<subfield code="z">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
							</datafield>
						</xsl:for-each>
						<xsl:for-each select="marc:controlfield[@tag = '008']">
							<datafield tag="100" ind1=" " ind2=" ">
								<subfield code="a">
									<xsl:variable name="dateEnteredOnFile">
										<xsl:choose>
											<xsl:when test="substring(text(), 1, 2) &lt; 60">
												<xsl:value-of
												select="concat('20', substring(text(), 1, 6))"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
												select="concat('19', substring(text(), 1, 6))"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="establishmentLevel">
										<xsl:choose>
											<xsl:when test="substring(text(), 34, 1) = 'a'"
												>a</xsl:when>
											<xsl:when test="substring(text(), 34, 1) = 'b'"
												>a</xsl:when>
											<xsl:when test="substring(text(), 34, 1) = 'c'"
												>c</xsl:when>
											<xsl:when test="substring(text(), 34, 1) = 'd'"
												>c</xsl:when>
											<xsl:when test="substring(text(), 34, 1) = 'n'"
												>x</xsl:when>
											<xsl:otherwise>
												<xsl:text> </xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="cataloguingLanguage">
										<xsl:choose>
											<xsl:when
												test="datafield[@tag = '040']/subfield[@code = 'b']">
												<xsl:value-of
												select="marc:datafield[@tag = '040']/subfield[@code = 'b']"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
												<xsl:when test="substring(text(), 9, 1) = 'b'"
												>eng</xsl:when>
												<xsl:when test="substring(text(), 9, 1) = 'e'"
												>eng</xsl:when>
												<xsl:when test="substring(text(), 9, 1) = 'f'"
												>fre</xsl:when>
												<xsl:otherwise>
												<!-- Expected default for MARC21 -->
												<xsl:value-of select="'eng'"/>
												</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="transliterationCode">
										<xsl:choose>
											<xsl:when test="substring(text(), 8, 1) = 'a'"
												>a</xsl:when>
											<xsl:when test="substring(text(), 8, 1) = 'b'"
												>b</xsl:when>
											<xsl:when test="substring(text(), 8, 1) = 'c'"
												>d</xsl:when>
											<xsl:when test="substring(text(), 8, 1) = 'd'"
												>d</xsl:when>
											<xsl:when test="substring(text(), 8, 1) = 'e'"
												>b</xsl:when>
											<xsl:when test="substring(text(), 8, 1) = 'f'"
												>f</xsl:when>
											<xsl:when test="substring(text(), 8, 1) = 'g'"
												>f</xsl:when>
											<xsl:when test="substring(text(), 8, 1) = 'n'"
												>y</xsl:when>
											<xsl:otherwise>
												<xsl:text> </xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="characterSet">
										<xsl:choose>
											<xsl:when test="substring(../marc:leader, 10, 1) = 'a'">
												<xsl:text>50  </xsl:text>
											</xsl:when>
											<!-- what if MARC-8 encoding, and not UTF8? -->
											<xsl:otherwise>
												<xsl:text>    </xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="additionalCharacterSet">
										<xsl:text>    </xsl:text>
									</xsl:variable>
									<!-- Fixme Script of Cataloguing -->
									<xsl:variable name="cataloguingScript">
										<xsl:choose>
											<xsl:when
												test="$cataloguingLanguage = 'eng' or $cataloguingLanguage = 'fre'">
												<xsl:text>ba</xsl:text>
											</xsl:when>
											<xsl:when
												test="$cataloguingLanguage = 'ger' or $cataloguingLanguage = 'deu'">
												<xsl:text>ba</xsl:text>
											</xsl:when>
											<xsl:when
												test="$cataloguingLanguage = 'ukr' or $cataloguingLanguage = 'rus' or $cataloguingLanguage = 'bel'">
												<xsl:text>ca</xsl:text>
											</xsl:when>
											<xsl:when
												test="$cataloguingLanguage = 'gre' or $cataloguingLanguage = 'grc' or $cataloguingLanguage = 'ell'">
												<xsl:text>ca</xsl:text>
											</xsl:when>
											<xsl:when
												test="$cataloguingLanguage = 'geo' or $cataloguingLanguage = 'kat'">
												<xsl:text>ma</xsl:text>
											</xsl:when>
											<xsl:when
												test="$cataloguingLanguage = 'arm' or $cataloguingLanguage = 'hye'">
												<xsl:text>ma</xsl:text>
											</xsl:when>
											<xsl:when
												test="$cataloguingLanguage = 'chi' or $cataloguingLanguage = 'zho'">
												<xsl:text>ea</xsl:text>
											</xsl:when>
											<xsl:when test="$cataloguingLanguage = 'heb'">
												<xsl:text>ha</xsl:text>
											</xsl:when>
											<xsl:when test="$cataloguingLanguage = 'kor'">
												<xsl:text>ka</xsl:text>
											</xsl:when>
											<xsl:when test="$cataloguingLanguage = 'ara'">
												<xsl:text>fa</xsl:text>
											</xsl:when>
											<xsl:when test="$cataloguingLanguage = 'jpn'">
												<xsl:text>da</xsl:text>
											</xsl:when>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="scriptDirection">
										<xsl:choose>
											<xsl:when test="
													$cataloguingLanguage = 'heb' or $cataloguingLanguage = 'ara'
													or $cataloguingLanguage = 'per' or $cataloguingLanguage = 'fas'"
												>1</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="
											concat($dateEnteredOnFile, $establishmentLevel,
											$cataloguingLanguage, $transliterationCode,
											$characterSet, $additionalCharacterSet,
											$cataloguingScript, $scriptDirection)"/>
								</subfield>
							</datafield>
							<datafield tag="106" ind1=" " ind2=" ">
								<subfield code="a">
									<xsl:choose>
										<xsl:when
											test="substring(text(), 15, 1) = 'b' and substring(text(), 16, 1) = 'a'">
											<xsl:value-of select="'2'"/>
										</xsl:when>
										<xsl:when test="substring(text(), 16, 1) = 'a'">
											<xsl:value-of select="'0'"/>
										</xsl:when>
										<xsl:when test="substring(text(), 16, 1) = 'b'">
											<xsl:value-of select="'1'"/>
										</xsl:when>
									</xsl:choose>
								</subfield>
								<!-- fixme complete conversion -->
							</datafield>
							<datafield tag="120" ind1=" " ind2=" ">
								<xsl:variable name="gender">
									<xsl:choose>
										<xsl:when
											test="marc:datafield[@tag = '375']/marc:subfield[@code = 's'] or marc:datafield[@tag = '375']/marc:subfield[@code = 't']"
											>c</xsl:when>
										<xsl:when
											test="marc:datafield[@tag = '375']/marc:subfield[@code = 'a'] = 'female'"
											>a</xsl:when>
										<xsl:when
											test="marc:datafield[@tag = '375']/marc:subfield[@code = 'a'] = 'male'"
											>b</xsl:when>
										<xsl:otherwise>
											<xsl:text> </xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="differentiated">
									<xsl:choose>
										<xsl:when test="substring(text(), 33, 1) = 'a'">a</xsl:when>
										<xsl:when test="substring(text(), 33, 1) = 'b'">b</xsl:when>
										<xsl:otherwise>
											<xsl:text> </xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<subfield code="a">
									<xsl:value-of select="concat($gender, $differentiated)"/>
								</subfield>
							</datafield>
							<datafield tag="150" ind1=" " ind2=" ">
								<subfield code="a">
									<xsl:value-of select="
											translate(substring(text(), 29, 1), ' acfilmosuz',
											'ybeafdehcuz')"/>
								</subfield>
							</datafield>
							<datafield tag="152" ind1=" " ind2=" ">
								<subfield code="a">
									<xsl:choose>
										<!-- fixme complete conversion -->
										<xsl:when test="substring(text(), 11, 1) = 'a'">Earlier
											rules</xsl:when>
										<xsl:when test="substring(text(), 11, 1) = 'b'"
											>AACR1</xsl:when>
										<xsl:when test="substring(text(), 11, 1) = 'c'"
											>AACR2</xsl:when>
										<xsl:when test="substring(text(), 11, 1) = 'd'"
											>AACR2</xsl:when>
										<xsl:when test="substring(text(), 11, 1) = 'z'">
											<xsl:value-of
												select="../marc:datafield[@tag = '040']/marc:subfield[@code = 'e']"
											/>
										</xsl:when>
									</xsl:choose>
								</subfield>
								<subfield code="b">
									<xsl:choose>
										<xsl:when test="substring(text(), 12, 1) = 'a'">
											<xsl:value-of select="'lc'"/>
										</xsl:when>
										<xsl:when test="substring(text(), 12, 1) = 'b'">
											<xsl:value-of select="'lcch'"/>
										</xsl:when>
										<xsl:when test="substring(text(), 12, 1) = 'c'">
											<xsl:value-of select="'mesh'"/>
										</xsl:when>
										<xsl:when test="substring(text(), 12, 1) = 'd'">
											<xsl:value-of select="'nal'"/>
										</xsl:when>
										<xsl:when
											test="substring(text(), 12, 1) = 'e' and substring(text(), 9, 1) = 'e'">
											<xsl:value-of select="'cae'"/>
										</xsl:when>
										<xsl:when
											test="substring(text(), 12, 1) = 'e' and substring(text(), 9, 1) = 'f'">
											<xsl:value-of select="'caf'"/>
										</xsl:when>
										<xsl:when test="substring(text(), 12, 1) = 'k'">
											<xsl:value-of select="'cae'"/>
										</xsl:when>
										<!-- What to do if thesaurus source is not specified (substring(text(), 12, 1) = 'n')? -->
										<!-- What to do if Art and Architecture Thesaurus (substring(text(), 12, 1) = 'r')? -->
										<xsl:when test="substring(text(), 12, 1) = 's'">
											<xsl:value-of select="'sears'"/>
										</xsl:when>
										<!-- What to do if Répertoire de vedettes-matière (substring(text(), 12, 1) = 'v')? -->
										<xsl:when test="substring(text(), 12, 1) = 'z'">
											<xsl:value-of select="'local'"/>
										</xsl:when>
									</xsl:choose>
								</subfield>
							</datafield>
							<datafield tag="154" ind1=" " ind2=" ">
								<subfield code="a">
									<xsl:choose>
										<xsl:when test="substring(text(), 13, 1) = 'a'"
											>ax</xsl:when>
										<xsl:when test="substring(text(), 13, 1) = 'b'"
											>bx</xsl:when>
										<xsl:when test="substring(text(), 13, 1) = 'c'"
											>cx</xsl:when>
										<xsl:when test="substring(text(), 13, 1) = 'z'"
											>zx</xsl:when>
										<xsl:when test="substring(text(), 13, 1) = 'n'">
											<xsl:text>x </xsl:text>
										</xsl:when>
									</xsl:choose>
								</subfield>
							</datafield>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '377']">
							<datafield tag="101" ind1=" ">
								<xsl:attribute name="ind2">
									<xsl:value-of select="@ind2"/>
								</xsl:attribute>
								<xsl:for-each select="marc:subfield[@code = 'a']">
									<subfield code="a">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = '2']">
									<subfield code="2">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
							</datafield>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '046']">
							<datafield tag="104" ind1=" " ind2=" ">
								<xsl:for-each select="marc:subfield[@code = 'f']">
									<subfield code="a">
										<xsl:value-of
											select="concat(' ', translate(text(), '-', ''), ' ')"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'g']">
									<subfield code="b">
										<xsl:value-of
											select="concat(' ', translate(text(), '-', ''), ' ')"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'k']">
									<subfield code="a">
										<xsl:value-of
											select="concat(' ', translate(text(), '-', ''), ' ')"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'l']">
									<subfield code="b">
										<xsl:value-of
											select="concat(' ', translate(text(), '-', ''), ' ')"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'o']">
									<subfield code="a">
										<xsl:value-of
											select="concat(' ', translate(text(), '-', ''), ' ')"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'p']">
									<subfield code="b">
										<xsl:value-of
											select="concat(' ', translate(text(), '-', ''), ' ')"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'q']">
									<subfield code="a">
										<xsl:value-of
											select="concat(' ', translate(text(), '-', ''), ' ')"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'r']">
									<subfield code="b">
										<xsl:value-of
											select="concat(' ', translate(text(), '-', ''), ' ')"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 's']">
									<subfield code="a">
										<xsl:value-of
											select="concat(' ', translate(text(), '-', ''), ' ')"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 't']">
									<subfield code="b">
										<xsl:value-of
											select="concat(' ', translate(text(), '-', ''), ' ')"/>
									</subfield>
								</xsl:for-each>
							</datafield>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '336']">
							<datafield tag="140" ind1=" " ind2=" ">
								<xsl:choose>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'txt' or marc:subfield[@code = 'a'] = 'text'">
										<subfield code="a">
											<xsl:text>te</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'xxx' or marc:subfield[@code = 'a'] = 'other'">
										<subfield code="a">
											<xsl:text>te</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'zzz' or marc:subfield[@code = 'a'] = 'unspecified'">
										<subfield code="a">
											<xsl:text>te</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'crd' or marc:subfield[@code = 'a'] = 'cartographic dataset'">
										<subfield code="a">
											<xsl:text>ca</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'cri' or marc:subfield[@code = 'a'] = 'cartographic image'">
										<subfield code="a">
											<xsl:text>ca</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'crm' or marc:subfield[@code = 'a'] = 'cartographic moving image'">
										<subfield code="a">
											<xsl:text>ca</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'crt' or marc:subfield[@code = 'a'] = 'cartographic tactile image'">
										<subfield code="a">
											<xsl:text>ca</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'crn' or marc:subfield[@code = 'a'] = 'cartographic tactile three-dimensional form'">
										<subfield code="a">
											<xsl:text>ca</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'crf' or marc:subfield[@code = 'a'] = 'cartographic three-dimensional form'">
										<subfield code="a">
											<xsl:text>ca</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'cod' or marc:subfield[@code = 'a'] = 'computer dataset'">
										<subfield code="a">
											<xsl:text>el</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'cop' or marc:subfield[@code = 'a'] = 'computer program'">
										<subfield code="a">
											<xsl:text>es</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'ntv' or marc:subfield[@code = 'a'] = 'notated movement'">
										<subfield code="a">
											<xsl:text>da</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'ntm' or marc:subfield[@code = 'a'] = 'notated music'">
										<subfield code="a">
											<xsl:text>mu</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'prm' or marc:subfield[@code = 'a'] = 'performed music'">
										<subfield code="a">
											<xsl:text>mu</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'snd' or marc:subfield[@code = 'a'] = 'sounds'">
										<subfield code="a">
											<xsl:text>so</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'spw' or marc:subfield[@code = 'a'] = 'spoken word'">
										<subfield code="a">
											<xsl:text>so</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'sti' or marc:subfield[@code = 'a'] = 'still image'">
										<subfield code="a">
											<xsl:text>is</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'tci' or marc:subfield[@code = 'a'] = 'tactile image'">
										<subfield code="a">
											<xsl:text>is</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'tcm' or marc:subfield[@code = 'a'] = 'tactile notated music'">
										<subfield code="a">
											<xsl:text>mu</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'tcn' or marc:subfield[@code = 'a'] = 'tactile notated movement'">
										<subfield code="a">
											<xsl:text>da</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'tct' or marc:subfield[@code = 'a'] = 'tactile text'">
										<subfield code="a">
											<xsl:text>te</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'tcf' or marc:subfield[@code = 'a'] = 'tactile three-dimensional form'">
										<subfield code="a">
											<xsl:text>mi</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'tdf' or marc:subfield[@code = 'a'] = 'three-dimensional form'">
										<subfield code="a">
											<xsl:text>mi</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'tdm' or marc:subfield[@code = 'a'] = 'three-dimensional moving image'">
										<subfield code="a">
											<xsl:text>im</xsl:text>
										</subfield>
									</xsl:when>
									<xsl:when
										test="marc:subfield[@code = 'b'] = 'tdi' or marc:subfield[@code = 'a'] = 'two-dimensional moving image'">
										<subfield code="a">
											<xsl:text>im</xsl:text>
										</subfield>
									</xsl:when>
								</xsl:choose>
								<xsl:for-each select="marc:subfield[@code = 'a']">
									<subfield code="b">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = '2']">
									<subfield code="2">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
							</datafield>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '100']">
							<xsl:choose>
								<xsl:when test="@ind1 != 3 and marc:subfield[@code = 't']">
									<datafield tag="240" ind1=" " ind2=" ">
										<subfield code="a">
											<xsl:call-template name="combine2AuthorSubfield"/>
										</subfield>
										<subfield code="t">
											<xsl:call-template name="combine2TitleSubfield"/>
										</subfield>
										<xsl:call-template name="convertSubdivisions"/>
									</datafield>
								</xsl:when>
								<xsl:when test="@ind1 != 3">
									<datafield tag="200" ind1=" ">
										<xsl:call-template name="convertPersonalNameSubfields">
											<xsl:with-param name="field" select="."/>
										</xsl:call-template>
									</datafield>
								</xsl:when>
								<xsl:otherwise>
									<datafield tag="220" ind1=" " ind2=" ">
										<xsl:for-each select="marc:subfield[@code = 'a']">
											<subfield code="a">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
										<xsl:for-each select="marc:subfield[@code = 'd']">
											<subfield code="f">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
										<xsl:call-template name="convertSubdivisions"/>
									</datafield>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:choose>
							<xsl:when
								test="marc:datafield[@tag = '372'] or marc:datafield[@tag = '373'] or marc:datafield[@tag = '374']">
								<datafield tag="340" ind1=" " ind2=" ">
									<xsl:for-each select="marc:datafield[@tag = '374']">
										<xsl:for-each select="marc:subfield[@code = 'a']">
											<subfield code="c">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
										<xsl:for-each select="marc:subfield[@code = '2']">
											<subfield code="2">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
									</xsl:for-each>
									<xsl:for-each select="marc:datafield[@tag = '372']">
										<xsl:for-each select="marc:subfield[@code = 'a']">
											<subfield code="d">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
									</xsl:for-each>
									<xsl:for-each select="marc:datafield[@tag = '373']">
										<xsl:for-each select="marc:subfield[@code = 'a']">
											<subfield code="p">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
										<xsl:for-each select="marc:subfield[@code = '2']">
											<subfield code="2">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
									</xsl:for-each>
								</datafield>
							</xsl:when>
						</xsl:choose>
						<xsl:for-each select="marc:datafield[@tag = '400']">
							<xsl:choose>
								<xsl:when test="@ind1 != 3 and marc:subfield[@code = 't']">
									<datafield tag="440" ind1=" " ind2=" ">
										<subfield code="a">
											<xsl:call-template name="combine2AuthorSubfield"/>
										</subfield>
										<subfield code="t">
											<xsl:call-template name="combine2TitleSubfield"/>
										</subfield>
										<xsl:call-template name="convertSubdivisions"/>
									</datafield>
								</xsl:when>
								<xsl:when test="@ind1 != 3">
									<datafield tag="400" ind1=" ">
										<xsl:call-template name="convertPersonalNameSubfields">
											<xsl:with-param name="field" select="."/>
										</xsl:call-template>
									</datafield>
								</xsl:when>
								<xsl:otherwise>
									<datafield tag="420" ind1=" " ind2=" ">
										<xsl:for-each select="marc:subfield[@code = 'a']">
											<subfield code="a">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
										<xsl:for-each select="marc:subfield[@code = 'd']">
											<subfield code="f">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
										<xsl:call-template name="convertSubdivisions"/>
									</datafield>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '500']">
							<xsl:choose>
								<xsl:when test="@ind1 != 3 and marc:subfield[@code = 't']">
									<datafield tag="540" ind1=" " ind2=" ">
										<subfield code="a">
											<xsl:call-template name="combine2AuthorSubfield"/>
										</subfield>
										<subfield code="t">
											<xsl:call-template name="combine2TitleSubfield"/>
										</subfield>
										<xsl:call-template name="convertSubdivisions"/>
									</datafield>
								</xsl:when>
								<xsl:when test="@ind1 != 3">
									<datafield tag="500" ind1=" ">
										<xsl:call-template name="convertPersonalNameSubfields">
											<xsl:with-param name="field" select="."/>
										</xsl:call-template>
									</datafield>
								</xsl:when>
								<xsl:otherwise>
									<datafield tag="520" ind1=" " ind2=" ">
										<xsl:for-each select="marc:subfield[@code = 'a']">
											<subfield code="a">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
										<xsl:for-each select="marc:subfield[@code = 'd']">
											<subfield code="f">
												<xsl:value-of select="text()"/>
											</subfield>
										</xsl:for-each>
										<xsl:call-template name="convertSubdivisions"/>
									</datafield>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:choose>
							<xsl:when
								test="marc:datafield[@tag = '046']/marc:subfield[@code = 'f'] or marc:datafield[@tag = '370']/marc:subfield[@code = 'a']">
								<datafield tag="640" ind1="1" ind2=" ">
									<xsl:choose>
										<xsl:when
											test="marc:datafield[@tag = '370']/marc:subfield[@code = 'a']">
											<subfield code="d">
												<xsl:value-of
												select="marc:datafield[@tag = '370']/marc:subfield[@code = 'a']"
												/>
											</subfield>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when
											test="marc:datafield[@tag = '046']/marc:subfield[@code = 'f']">
											<subfield code="f">
												<xsl:value-of
												select="concat(' ', translate(marc:datafield[@tag = '046']/marc:subfield[@code = 'f'], '-', ''), ' ')"
												/>
											</subfield>
										</xsl:when>
									</xsl:choose>
								</datafield>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when
								test="marc:datafield[@tag = '046']/marc:subfield[@code = 'g'] or marc:datafield[@tag = '370']/marc:subfield[@code = 'b']">
								<datafield tag="640" ind1="2" ind2=" ">
									<xsl:choose>
										<xsl:when
											test="marc:datafield[@tag = '370']/marc:subfield[@code = 'b']">
											<subfield code="d">
												<xsl:value-of
												select="marc:datafield[@tag = '370']/marc:subfield[@code = 'b']"
												/>
											</subfield>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when
											test="marc:datafield[@tag = '046']/marc:subfield[@code = 'g']">
											<subfield code="f">
												<xsl:value-of
												select="concat(' ', translate(marc:datafield[@tag = '046']/marc:subfield[@code = 'g'], '-', ''), ' ')"
												/>
											</subfield>
										</xsl:when>
									</xsl:choose>
								</datafield>
							</xsl:when>
						</xsl:choose>
						<xsl:for-each
							select="marc:datafield[@tag = '370']/marc:subfield[@code = 'e']">
							<datafield tag="640" ind1="4" ind2=" ">
								<subfield code="d">
									<xsl:value-of select="text()"/>
								</subfield>
							</datafield>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '053']">
							<datafield tag="680" ind1=" " ind2=" ">
								<xsl:for-each select="marc:subfield[@code = 'a']">
									<subfield code="a">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'b']">
									<subfield code="b">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'c']">
									<subfield code="c">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
							</datafield>
						</xsl:for-each>
						<!--<xsl:for-each select="marc:datafield[@tag = '400']">
							<datafield tag="700" ind1=" ">
								<xsl:choose>
									<xsl:when test="@ind1 != 3" >
										<xsl:call-template name="convertPersonalNameSubfields">
											<xsl:with-param name="field" select="."/>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</datafield>
						</xsl:for-each>-->
						<!--<xsl:for-each select="marc:datafield[@tag = '040']">
							<xsl:for-each select="marc:subfield[@code = 'a']">
								<datafield tag="801" ind1=" " ind2="0">
									<subfield code="a">
										<xsl:call-template name="getCountryFromMarcOrgCode">
											<xsl:with-param name="marcOrgCode" select="text()" />
										</xsl:call-template>
									</subfield>
									<subfield code="b">
										<xsl:value-of select="text()"/>
									</subfield>
								</datafield>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code = 'c']">
								<datafield tag="801" ind1=" " ind2="1">
									<subfield code="a">
										<xsl:call-template name="getCountryFromMarcOrgCode">
											<xsl:with-param name="marcOrgCode" select="text()" />
										</xsl:call-template>
									</subfield>
									<subfield code="b">
										<xsl:value-of select="text()"/>
									</subfield>
								</datafield>
							</xsl:for-each>
							<xsl:for-each select="marc:subfield[@code = 'd']">
								<datafield tag="801" ind1=" " ind2="2">
									<subfield code="a">
										<xsl:call-template name="getCountryFromMarcOrgCode">
											<xsl:with-param name="marcOrgCode" select="text()" />
										</xsl:call-template>
									</subfield>
									<subfield code="b">
										<xsl:value-of select="text()"/>
									</subfield>
								</datafield>
							</xsl:for-each>
						</xsl:for-each>-->
						<xsl:for-each select="marc:datafield[@tag = '670']">
							<datafield tag="810" ind1=" " ind2=" ">
								<xsl:for-each select="marc:subfield[@code = 'a']">
									<subfield code="a">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
								<xsl:for-each select="marc:subfield[@code = 'b']">
									<subfield code="b">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
							</datafield>
						</xsl:for-each>
						<xsl:for-each select="marc:datafield[@tag = '667']">
							<datafield tag="830" ind1=" " ind2=" ">
								<xsl:for-each select="marc:subfield[@code = 'a']">
									<subfield code="a">
										<xsl:value-of select="text()"/>
									</subfield>
								</xsl:for-each>
							</datafield>
						</xsl:for-each>
						<xsl:call-template name="datafield856"/>

					</record>
				</xsl:for-each>
			</xsl:for-each>
		</collection>
	</xsl:template>

	<xsl:template name="convertPersonalNameSubfields">
		<xsl:param name="field"/>
		<xsl:attribute name="ind2">
			<xsl:value-of select="@ind1"/>
		</xsl:attribute>
		<xsl:for-each select="marc:subfield[@code = 'i']">
			<subfield code="0" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:value-of select="text()"/>
			</subfield>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = 'a']">
			<xsl:choose>
				<xsl:when test="contains(text(), ', ')">
					<subfield code="a" xmlns="http://www.loc.gov/MARC21/slim">
						<xsl:value-of select="substring-before(text(), ', ')"/>
					</subfield>
					<subfield code="b" xmlns="http://www.loc.gov/MARC21/slim">
						<xsl:call-template name="removeEndPuctuation">
							<xsl:with-param name="text" select="substring-after(text(), ', ')"/>
						</xsl:call-template>
					</subfield>
				</xsl:when>
				<xsl:otherwise>
					<subfield code="a" xmlns="http://www.loc.gov/MARC21/slim">
						<xsl:call-template name="removeEndPuctuation">
							<xsl:with-param name="text" select="text()"/>
						</xsl:call-template>
					</subfield>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = 'b']">
			<subfield code="d" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:call-template name="removeEndPuctuation">
					<xsl:with-param name="text" select="text()"/>
				</xsl:call-template>
			</subfield>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = 'c']">
			<subfield code="c" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:value-of select="text()"/>
			</subfield>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = 'd']">
			<subfield code="f" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:call-template name="removeEndPuctuation">
					<xsl:with-param name="text" select="text()"/>
				</xsl:call-template>
			</subfield>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = 'e']">
			<subfield code="4" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:value-of select="text()"/>
			</subfield>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = 'q']">
			<subfield code="g" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:call-template name="removeEndPuctuation">
					<xsl:with-param name="text" select="text()"/>
				</xsl:call-template>
			</subfield>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = '0']">
			<subfield code="3" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:value-of select="text()"/>
			</subfield>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = '4']">
			<subfield code="4" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:value-of select="text()"/>
			</subfield>
		</xsl:for-each>
		<xsl:call-template name="convertSubdivisions"/>
	</xsl:template>

	<xsl:template name="combine2AuthorSubfield">
		<xsl:variable name="authorName">
			<xsl:choose>
				<xsl:when test="marc:subfield[@code = 'a']">
					<xsl:call-template name="removeEndPuctuation">
						<xsl:with-param name="text" select="marc:subfield[@code = 'a']"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="authorNumeration">
			<xsl:choose>
				<xsl:when test="marc:subfield[@code = 'b']">
					<xsl:text> </xsl:text>
					<xsl:call-template name="removeEndPuctuation">
						<xsl:with-param name="text" select="marc:subfield[@code = 'b']"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="authorTitles">
			<xsl:choose>
				<xsl:when test="marc:subfield[@code = 'c']">
					<xsl:for-each select="marc:subfield[@code = 'c']">
						<xsl:call-template name="removeEndPuctuation">
							<xsl:with-param name="text" select="text()"/>
						</xsl:call-template>
						<xsl:choose>
							<xsl:when test="position() != last()">
								<xsl:text>; </xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="authorDates">
			<xsl:choose>
				<xsl:when test="marc:subfield[@code = 'd']">
					<xsl:call-template name="removeEndPuctuation">
						<xsl:with-param name="text" select="marc:subfield[@code = 'd']"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="authorFullName">
			<xsl:choose>
				<xsl:when test="marc:subfield[@code = 'q']">
					<xsl:call-template name="removeEndPuctuation">
						<xsl:with-param name="text" select="marc:subfield[@code = 'q']"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($authorName, $authorNumeration)"/>
		<xsl:choose>
			<xsl:when test="$authorDates != '' or $authorTitles != '' or $authorFullName != ''">
				<xsl:value-of select="concat(' (', $authorFullName)"/>
				<xsl:choose>
					<xsl:when test="$authorFullName != '' and $authorTitles != ''">
						<xsl:text>; </xsl:text>
					</xsl:when>
				</xsl:choose>
				<xsl:value-of select="$authorTitles"/>
				<xsl:choose>
					<xsl:when test="$authorTitles != '' and $authorDates != ''">
						<xsl:text>; </xsl:text>
					</xsl:when>
				</xsl:choose>
				<xsl:value-of select="$authorDates"/>
				<xsl:text>)</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="combine2TitleSubfield">
		<xsl:for-each select="marc:subfield[@code = 't']">
			<xsl:value-of select="text()"/>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code]">
			<xsl:variable name="code">
				<xsl:value-of select="@code"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="string-length(translate($code, 'fhklmnoprs', '')) = 0">
					<xsl:text> </xsl:text>
					<xsl:value-of select="text()"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="convertSubdivisions">
		<xsl:for-each select="marc:subfield[@code = 'v']">
			<subfield code="j" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:value-of select="text()"/>
			</subfield>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = 'x']">
			<subfield code="x" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:value-of select="text()"/>
			</subfield>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = 'y']">
			<subfield code="z" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:value-of select="text()"/>
			</subfield>
		</xsl:for-each>
		<xsl:for-each select="marc:subfield[@code = 'z']">
			<subfield code="y" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:value-of select="text()"/>
			</subfield>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="tokenizeSubfield">
		<!--passed template parameter -->
		<xsl:param name="list"/>
		<xsl:param name="delimiter"/>
		<xsl:param name="code"/>
		<xsl:choose>
			<xsl:when
				test="contains($list, $delimiter) and substring-after($list, $delimiter) != ''">
				<subfield xmlns="http://www.loc.gov/MARC21/slim">
					<xsl:attribute name="code">
						<xsl:value-of select="$code"/>
					</xsl:attribute>
					<!-- get everything in front of the first delimiter -->
					<xsl:value-of select="substring-before($list, $delimiter)"/>
				</subfield>
				<xsl:call-template name="tokenizeSubfield">
					<!-- store anything left in another variable -->
					<xsl:with-param name="list"
						select="normalize-space(substring-after($list, $delimiter))"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
					<xsl:with-param name="code" select="$code"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$list = ''"/>
					<xsl:otherwise>
						<subfield xmlns="http://www.loc.gov/MARC21/slim">
							<xsl:attribute name="code">
								<xsl:value-of select="$code"/>
							</xsl:attribute>
							<xsl:call-template name="removeEndPuctuation">
								<xsl:with-param name="text" select="$list"/>
							</xsl:call-template>

						</subfield>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="removeEndPuctuation">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when
				test="string-length(translate(substring($text, string-length($text)), ' ,.:;/', '')) = 0">
				<xsl:value-of
					select="normalize-space(substring($text, 1, string-length($text) - 1))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="datafield856">
		<xsl:for-each select="marc:datafield[@tag = 856]">
			<datafield tag="856" xmlns="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="ind1">
					<xsl:value-of select="@ind1"/>
				</xsl:attribute>
				<xsl:attribute name="ind2">
					<xsl:value-of select="@ind2"/>
				</xsl:attribute>
				<xsl:for-each select="marc:subfield[@code]">
					<subfield>
						<xsl:attribute name="code">
							<xsl:choose>
								<xsl:when test="@code = 3">
									<xsl:value-of select="2"/>
								</xsl:when>
								<xsl:when test="@code = 2">
									<xsl:value-of select="y"/>
								</xsl:when>
								<xsl:when test="@code = y">
									<xsl:value-of select="2"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@code"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:value-of select="text()"/>
					</subfield>
				</xsl:for-each>
			</datafield>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getCountryFromMarcOrgCode">
		<xsl:param name="marcOrgCode" select="text()"/>
		<xsl:choose>
			<xsl:when test="substring($marcOrgCode, 3, 1) = '-'">
				<xsl:value-of select="substring($marcOrgCode, 1, 2)"/>
			</xsl:when>
			<xsl:when test="$marcOrgCode = 'DLC'">
				<xsl:value-of select="'US'"/>
			</xsl:when>
			<xsl:when test="$marcOrgCode = 'IEN'">
				<xsl:value-of select="'US'"/>
			</xsl:when>
			<xsl:when test="$marcOrgCode = 'MH'">
				<xsl:value-of select="'US'"/>
			</xsl:when>
			<xsl:when test="$marcOrgCode = 'OCoLC'">
				<xsl:value-of select="'US'"/>
			</xsl:when>
			<xsl:when test="$marcOrgCode = 'NcU'">
				<xsl:value-of select="'US'"/>
			</xsl:when>
			<xsl:when test="$marcOrgCode = 'InU'">
				<xsl:value-of select="'US'"/>
			</xsl:when>
			<xsl:when test="$marcOrgCode = 'NNC'">
				<xsl:value-of select="'US'"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
