

/*---------------------
	Video button 
--------------------- */
var vid = document.getElementById("video-bg");
var pauseButton = document.querySelector("#polina button");

function vidFade() {
	vid.classList.add("stopfade");
}
vid.addEventListener('ended', function () {
	// only functional if "loop" is removed 
	vid.pause();
	// to capture IE10
	vidFade();
});
pauseButton.addEventListener("click", function () {
	vid.classList.toggle("stopfade");
	if (vid.paused) {
		vid.play();
		pauseButton.innerHTML = [
"<i class='zmdi zmdi-pause-circle-outline'></i>"
];
$('.video-text').css("background-image", "none");
	} else {
		vid.pause();
		pauseButton.innerHTML = [
"<i class='zmdi zmdi-play-circle-outline'></i>"
];
	}
});