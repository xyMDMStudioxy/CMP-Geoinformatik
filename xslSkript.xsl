<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="utf-8" indent="yes" />
<xsl:template match="/">
	<xsl:result-document href="index.html">
		<html>
		<head>
			<meta charset="UTF-8"/>
			<title>Geoformate</title>

			<!-- CSS Einbindung -->
			<link rel="stylesheet" href="css/layout.css"/>

			<!-- JS GoogleMaps Einbindung -->
			<script src="http://maps.google.com/maps/api/js?sensor=true"></script>
			<script src="js/googlemaps.js"></script>
			<script>
				var tmp;
				var kmDistance = [];
			</script>
		</head>
		<body>
		<!-- Google Maps -->
		<div id="pos">
			<p>Deine Position wird ermittelt...</p>
		</div>
		<script>
			
		</script>
		<div id="info">
			<table border="1">
				<thead>
					<td>Name</td>
					<td>Latitude</td>
					<td>Longitude</td>
					<td>Kurs</td>
				</thead>
				<xsl:for-each select="/gpx/wpt">
					<tr>
						<xsl:variable name="name" select="./name/text()"/>
						<xsl:variable name="lat" select="@lat"/>
						<xsl:variable name="lon" select="@lon"/>
						<td><xsl:value-of select="name"/></td>
						<td><xsl:value-of select="$lat"/></td>
						<td><xsl:value-of select="$lon"/></td>
						<script>
							var lat = <xsl:value-of select="$lat"/>;
							var lon = <xsl:value-of select="$lon"/>;							
							distance(48.84075409497385, 10.066720502099543, lat, lon, kmDistance);
						</script>
						<td></td>
					</tr>
				</xsl:for-each>
			</table>
			<ul>
				<li id="distance"></li>
			</ul>
		</div>
	</body>
	</html>
	</xsl:result-document>
</xsl:template>

</xsl:stylesheet>