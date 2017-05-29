<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="utf-8" indent="yes" />
<xsl:template match="/">
	<xsl:result-document href="index.html">
		<html lang="de">
		<head>
			<title>Geolocation</title>
			<link rel="stylesheet" href="css/style.css"/>

			<script src="http://maps.google.com/maps/api/js?sensor=true"></script>
		</head>

		<body>

		<div id="map" style="width: 50%; height: 100%;">
			<p>Karte wird geladen...</p>
		</div>

		<div id="info">
			<script>
				var kmDistance = [];

				function initialize(coords) {
					var latlng = new google.maps.LatLng(coords.latitude, coords.longitude);
					var myOptions = {zoom: 8, center: latlng, mapTypeId: google.maps.MapTypeId.ROADMAP};
					var map = new google.maps.Map(document.getElementById("map"), myOptions);
					var marker = new google.maps.Marker({position: latlng, map: map, title: "Hier sind wir"});
				}

				navigator.geolocation.getCurrentPosition(function(position) {
					initialize(position.coords);
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
					document.getElementById('distance' + i.toString()).innerHTML = km.toFixed(2) + " km";
					return km;
				}

				function distance_sort(lat1, lng1, lat2, lng2, kmDistance, i) {
					window.alert(lat2);
					window.alert(lng2);
					document.getElementById('distance_sort' + i.toString()).innerHTML = kmDistance[i-1].toFixed(2) + " km";
					
					lat1 = lat1 * Math.PI / 180;
					lat2 = lat2 * Math.PI / 180;
					lng1 = lng1 * Math.PI / 180;
					lng2 = lng2 * Math.PI / 180;

					var kurs = Math.acos(Math.sin(lat1) * Math.sin(lat2) + Math.cos(lat1) * Math.cos(lat2) * Math.cos(lng1 - lng2));
					kurs = kurs * 180 / Math.PI;

					/*var var1 = 52.517;
					var1 = var1 * Math.PI / 180;
					var var2 = 35.70;
					var2 = var2 * Math.PI / 180;				
					var var3 = 139.767;
					var3 = var3 * Math.PI / 180;
					var var4 = 13.40;
					var4 = var4 * Math.PI / 180;*/

					//var kurs = Math.acos(Math.sin(var1) * Math.sin(var2) + Math.cos(var1) * Math.cos(var2) * Math.cos(var3 - var4));
					//kurs = kurs * 180 / Math.PI;

					//var kurs = 52.517;
					//lat1 = lat1 * Math.PI / 180;
					
					//kurs = Math.sin(kurs);
					//var kurs = Math.atan((lat1 - lat2), (lng1 - lng2)) * 360 / Math.PI;
					//var kurs = (Math.sin(lat2) - Math.sin(lat1) * Math.cos(kmDistance[i-1])) / (Math.cos(lat1) * Math.sin(kmDistance[i-1]));
					//var kurs = Math.acos(Math.sin(lat1) * Math.sin(lat2) + Math.cos(lat1) * Math.cos(lat2) * Math.cos(lng2 - lng1));
					

					document.getElementById('kurs' + i.toString()).innerHTML = kurs + "°";
				}
			</script>

			<div id="waypoints_info">
				<table border="1" class="table">
					<caption>Waypoints</caption>
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
							var km = distance(48.84075409497385, 10.066720502099543, lat, lng, i);
							kmDistance.push(km);
						</script>
					</tr>
					</xsl:for-each>
				</table>
			</div>

			<div id="distances">
				<table border="1" class="table">
					<caption>Distanzen sortiert mit Kursen</caption>
					<thead>
						<td>Distanz</td>
						<td>Kurs</td>
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
							distance_sort(48.84075409497385, 10.066720502099543, lat, lng, kmDistance, i);
						</script>
					</tr>
					</xsl:for-each>
				</table>
			</div>
		</div>

		</body>
		</html>
	</xsl:result-document>
</xsl:template>

</xsl:stylesheet>