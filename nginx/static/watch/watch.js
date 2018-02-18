function loadPage() {
	var uuid = getParameterByName('video');
	var callUrl = "/api/video/"+uuid;
	httpGetAsync(callUrl, loadVideo);
}

function loadVideo(res) {
	var video_data = JSON.parse(res);
	console.log(video_data);
	if (video_data == {}) {
		document.getElementById('content').align = 'center';
		document.getElementById('title').innerText = "Video Not Found";
	}
	document.getElementById('content').align = 'center';
	document.getElementById('title').innerText = video_data.title;
	document.getElementById('description').innerText = video_data.description;
	var video_player_container = document.getElementById('video_player');
	var video_player = document.createElement('video');
	video_player.src = video_data.public_url;
	video_player.autoplay = true;
	video_player.controls = true;
	video_player_container.appendChild(video_player);
}

// https://stackoverflow.com/questions/247483/http-get-request-in-javascript
function httpGetAsync(theUrl, callback) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() { 
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
            callback(xmlHttp.responseText);
    }
    xmlHttp.open("GET", theUrl, true); // true for asynchronous 
    xmlHttp.send(null);
}

// https://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}