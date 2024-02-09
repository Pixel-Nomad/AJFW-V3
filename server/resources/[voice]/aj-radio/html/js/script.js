$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "open") {
            AJRadio.SlideUp()
        }

        if (event.data.type == "close") {
            AJRadio.SlideDown()
        }
    });

    document.onkeyup = function (data) {
        if (data.key == "Escape") { // Escape key
            $.post('https://aj-radio/escape', JSON.stringify({}));
        } else if (data.key == "Enter") { // Enter key
            $.post('https://aj-radio/joinRadio', JSON.stringify({
                channel: $("#channel").val()
            }));
        }
    };
});

AJRadio = {}

$(document).on('click', '#submit', function(e){
    e.preventDefault();

    $.post('https://aj-radio/joinRadio', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#disconnect', function(e){
    e.preventDefault();

    $.post('https://aj-radio/leaveRadio');
});

$(document).on('click', '#volumeUp', function(e){
    e.preventDefault();

    $.post('https://aj-radio/volumeUp', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#volumeDown', function(e){
    e.preventDefault();

    $.post('https://aj-radio/volumeDown', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#decreaseradiochannel', function(e){
    e.preventDefault();

    $.post('https://aj-radio/decreaseradiochannel', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#increaseradiochannel', function(e){
    e.preventDefault();

    $.post('https://aj-radio/increaseradiochannel', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#poweredOff', function(e){
    e.preventDefault();

    $.post('https://aj-radio/poweredOff', JSON.stringify({
        channel: $("#channel").val()
    }));
});

AJRadio.SlideUp = function() {
    $(".container").css("display", "block");
    $(".radio-container").animate({bottom: "6vh",}, 250);
}

AJRadio.SlideDown = function() {
    $(".radio-container").animate({bottom: "-110vh",}, 400, function(){
        $(".container").css("display", "none");
    });
}
