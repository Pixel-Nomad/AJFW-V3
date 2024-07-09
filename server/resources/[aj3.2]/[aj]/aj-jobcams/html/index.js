menuOpen = false;
window.addEventListener('message', function(event) {
    ed = event.data;
    if (ed.action === "openBodycams") {
		menuOpen = true;
		document.getElementById("topTitle").innerHTML="BODYCAMS";
		document.getElementById("topDescription").innerHTML="Select a bodycam to view its footage or press ESC to close.";
		document.getElementById("MDIDivs").innerHTML="";
		document.getElementById("mainDiv").style.display = "flex";
		ed.list.forEach(function(pData, index) {
			var playerSHTML = `
			<div id="MDIDiv">
				<div class="MDIDivCam MDIDivCamInactive" id="MDIDivCam-${pData.label}">
					<i class="fas fa-video"></i>
				</div>
				<div id="MDIDivLabel">
					<div id="MDIDivLabelTriangle"></div>
					<h4>${pData.label}</h4>
				</div>
				<div class="MDIDivBtn MDIDivBtnInactive" id="MDIDivBtn-${pData.label}" onclick="clFunc('watchPlayer', '${pData.id}', '${pData.label}')">
					<i class="fas fa-chevron-double-right" style="margin-top: 0.1vw;"></i>
				</div>
			</div>`;
			appendHtml(document.getElementById("MDIDivs"), playerSHTML);
		});
	} else if (ed.action === "openDashcams") {
		menuOpen = true;
		document.getElementById("topTitle").innerHTML="DASHCAMS";
		document.getElementById("topDescription").innerHTML="Select a dashcam to view its footage or press ESC to close.";
		document.getElementById("MDIDivs").innerHTML="";
		document.getElementById("mainDiv").style.display = "flex";
		ed.list.forEach(function(pData, index) {
			var playerSHTML = `
			<div id="MDIDiv">
				<div class="MDIDivCam MDIDivCamInactive" id="MDIDivCam-${pData.label}">
					<i class="fas fa-video"></i>
				</div>
				<div id="MDIDivLabel">
					<div id="MDIDivLabelTriangle"></div>
					<h4>${pData.label}</h4>
				</div>
				<div class="MDIDivBtn MDIDivBtnInactive" id="MDIDivBtn-${pData.label}" onclick="clFunc('watchDashcam', '${pData.vehNetId}', '${pData.label}', ${pData.pId})">
					<i class="fas fa-chevron-double-right" style="margin-top: 0.1vw;"></i>
				</div>
			</div>`;
			appendHtml(document.getElementById("MDIDivs"), playerSHTML);
		});
	} else if (ed.action === "closeAll") {
		menuOpen = false;
		document.getElementById("mainDiv").style.display = "none";
		var xhr = new XMLHttpRequest();
		xhr.open("POST", `https://${GetParentResourceName()}/callback`, true);
		xhr.setRequestHeader('Content-Type', 'application/json');
		xhr.send(JSON.stringify({action: "nuiFocus"}));
	}
	document.onkeyup = function(data) {
		if (data.which == 27 && menuOpen) {
            menuOpen = false;
			document.getElementById("mainDiv").style.display = "none";
			var xhr = new XMLHttpRequest();
			xhr.open("POST", `https://${GetParentResourceName()}/callback`, true);
			xhr.setRequestHeader('Content-Type', 'application/json');
			xhr.send(JSON.stringify({action: "nuiFocus"}));
		}
	}
});

function clFunc(name1, name2, name3, name4) {
	if (name1 === "watchPlayer") {
		document.getElementById("MDIDivCam-" + name3).classList.remove("MDIDivCamInactive");
		document.getElementById("MDIDivCam-" + name3).classList.add("MDIDivCamActive");
		document.getElementById("MDIDivBtn-" + name3).classList.remove("MDIDivBtnInactive");
		document.getElementById("MDIDivBtn-" + name3).classList.add("MDIDivBtnActive");
		var xhr = new XMLHttpRequest();
		xhr.open("POST", `https://${GetParentResourceName()}/callback`, true);
		xhr.setRequestHeader('Content-Type', 'application/json');
		xhr.send(JSON.stringify({action: "watchBodycam", playerId: Number(name2)}));
	} else if (name1 === "watchDashcam") {
		document.getElementById("MDIDivCam-" + name3).classList.remove("MDIDivCamInactive");
		document.getElementById("MDIDivCam-" + name3).classList.add("MDIDivCamActive");
		document.getElementById("MDIDivBtn-" + name3).classList.remove("MDIDivBtnInactive");
		document.getElementById("MDIDivBtn-" + name3).classList.add("MDIDivBtnActive");
		var xhr = new XMLHttpRequest();
		xhr.open("POST", `https://${GetParentResourceName()}/callback`, true);
		xhr.setRequestHeader('Content-Type', 'application/json');
		xhr.send(JSON.stringify({action: "watchDashcam", netId: Number(name2), playerId: Number(name4)}));
	}
}

function appendHtml(el, str) {
	var div = document.createElement('div');
	div.innerHTML = str;
	while (div.children.length > 0) {
		el.appendChild(div.children[0]);
	}
}