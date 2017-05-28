<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="utf-8" indent="yes" />
<xsl:template match="/">
	<xsl:result-document href="index.html">
		<html lang="de">
		<head>
			<title>Geolocation</title>
		</head>

		<body>

		<div id="aktuelle_pos">
			<p>Aktuelle Position wird bestimmt...</p>
		</div>

		<script>
			var kmDistance = [];

			navigator.geolocation.getCurrentPosition(function(position) {
				document.getElementById('aktuelle_pos').innerHTML = 'Aktuelle Position Latitude: ' + position.coords.latitude + ' / Longitude: ' + position.coords.longitude;
			}, function() {
				document.getElementById('aktuelle_pos').innerHTML = 'Deine aktuelle Position konnte nicht bestimmt werden.';
			});

			function distance(lat1, lng1, lat2, lng2, i) {
				var pi80 = 3.14159265359 / 180;
				lat1 *= pi80;
				lng1 *= pi80;
				lat2 *= pi80;
				lng2 *= pi80;
				var r = 6372.797; 
				var dlat = lat2 - lat1;
				var dlng = lng2 - lng1;
				var a = Math.sin(dlat / 2) * Math.sin(dlat / 2) + Math.cos(lat1) * Math.cos(lng1) * Math.sin(dlng / 2) * Math.sin(dlng / 2);
				var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
				var km = r * c;
				document.getElementById('distance' + i.toString()).innerHTML = km;
				return km;
			}

			function distance_sort(lat1, lng1, lat2, lng2, kmDistance, i) {
				document.getElementById('distance_sort' + i.toString()).innerHTML = kmDistance[i-1];
				var kurs = (Math.sin(lat2) - Math.sin(lat1) * Math.cos(kmDistance[i-1])) / (Math.cos(lat1) * Math.sin(kmDistance[i-1]));
				kurs = Math.cos(kurs) * 100;
				document.getElementById('kurs' + i.toString()).innerHTML = kurs;
			}
		</script>

		<div id="waypoints_info">
			<table border="1">
				<thead>
					<td>Name</td>
					<td>Längengrad</td>
					<td>Breitengrad</td>
					<td>Distanz</td>
				</thead>
				<xsl:for-each select="/gpx/wpt">
				<tr>
					<td><xsl:value-of select="./name/text()"/></td>
					<td><xsl:value-of select="@lat"/></td>
					<td><xsl:value-of select="@lng"/></td>
					<td id="distance{position()}"></td>
					<xsl:variable name="lat" select="@lat"/>
					<xsl:variable name="lng" select="@lng"/>
					<script>
						var lat = <xsl:value-of select="$lat"/>;
						var lng = <xsl:value-of select="$lng"/>;
						var i = <xsl:value-of select="position()"/>;
						var km = distance(48.7678555, 9.825188300000036, lat, lng, i);
						kmDistance.push(km);
					</script>
				</tr>
				</xsl:for-each>
			</table>
		</div>

		<div id="distances">
			<table border="1">
				<thead>
					<td>Distanzen sortiert</td>
					<td>Kurse</td>
				</thead>
				<script>
					kmDistance.sort(function(a, b){return a - b});	
				</script>
				<xsl:for-each select="/gpx/wpt">
				<tr>
					<td id="distance_sort{position()}"></td>
					<td id="kurs{position()}"></td>
					<xsl:variable name="lat" select="@lat"/>
					<xsl:variable name="lng" select="@lng"/>
					<script>
						var lat = <xsl:value-of select="$lat"/>;
						var lng = <xsl:value-of select="$lng"/>;
						var i = <xsl:value-of select="position()"/>;
						distance_sort(48.7678555, 9.825188300000036, lat, lng, kmDistance, i);
					</script>
				</tr>
				</xsl:for-each>
			</table>
		</div>

		</body>
		</html>
	</xsl:result-document>
</xsl:template>

</xsl:stylesheet>