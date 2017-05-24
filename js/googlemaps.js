function distance(target_lat, target_lon) {
	navigator.geolocation.getCurrentPosition(function(position) {
		initialize(position.coords);
		}, function() {
		document.getElementById('pos').innerHTML = 'Deine Position konnte nicht ermittelt werden.';
	});

	function initialize(coords) {
		var latlng = new google.maps.LatLng(coords.latitude, coords.longitude);
		var myOptions = {
		zoom: 8,
		center: latlng,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	}
	var map = new google.maps.Map(document.getElementById("pos"), myOptions);
	var marker = new google.maps.Marker({
		position: latlng,
		map: map,
		title: 'Hier sind wir'
	});
	document.getElementById("aktPosition").innerHTML = "Breitengrad: " + coords.latitude + " und Längengrad: " + coords.longitude;
	var pi80 = 3.1415 / 180;
	coords.latitude *= pi80;
	coords.longitude *= pi80;
	target_lat *= pi80;
	target_lon *= pi80;
	var r = 6372.797;
	var dlat = target_lat - coords.latitude;
	var dlng = target_lon - coords.longitude;
	var a = Math.sin(dlat / 2) * Math.sin(dlat / 2) + Math.cos(coords.latitude) * Math.cos(target_lat) * Math.sin(dlng / 2) * Math.sin(dlng / 2);
	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
	var km = r * c / 1000;
	document.getElementById("distance").innerHTML = km;
	}
}