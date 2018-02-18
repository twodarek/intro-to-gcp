function loadPage() {
    var callUrl = "/api/video/all"
    httpGetAsync(callUrl, loadVideoList)
}

function loadVideoList(res) {
    results = JSON.parse(res);
    console.log(results);
    var list_container = document.getElementById("video_list");
    results.forEach(function(res) {
        var line = document.createElement('div');
        line.innerHTML = "<a href='/watch/?video=" + res.video_uuid + "'>" + res.title + "</a>";
        list_container.appendChild(line);
    });
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