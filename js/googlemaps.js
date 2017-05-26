function distance(lat1, lng1, lat2, lng2, kmDistance) {
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
	tmp = kmDistance.push(km);
	kmDistance.sort(function(a, b){return a - b});
	document.getElementById("distance").innerHTML = kmDistance;
	}
}