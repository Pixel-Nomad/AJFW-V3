AJTuner = {}

var headlightVal = 0;
var RainbowNeon = false;
var RainbowHeadlight = false;

const rangeInput1 = document.getElementById('boost-slider');
const rangeInput2 = document.getElementById('breaking-slider');

const heading1 = document.getElementById('value1');
const heading2 = document.getElementById('value2');

rangeInput1.addEventListener('input', function() {
    const value = rangeInput1.value;
    heading1.textContent = `${value}%`;
});

rangeInput2.addEventListener('input', function() {
    const value = rangeInput2.value;
    heading2.textContent = `${value}%`;
});


$(document).ready(function(){
    $('.container').hide();

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "ui") {
            if (eventData.toggle) {
                AJTuner.Open(eventData.data)
            }
        }
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            AJTuner.Close();
            break;
    }
});

$(document).on('click', '#save', function(){
    $.post('https://aj-tunerchip/save', JSON.stringify({
        boost: $("#boost-slider").val(),
        gear: $("#gear-slider").val(),
        brake: $("#breaking-slider").val(),
    }));
});

$(document).on('click', '#reset', function(){
    $.post('https://aj-tunerchip/reset');
});

$(document).on('click', '#cancel', function(){
    AJTuner.Close();
});



AJTuner.Open = function(data) {
    $.post('https://aj-tunerchip/checkItem', JSON.stringify({item: "tunerlaptop"}), function(hasItem){
        if (hasItem) {
            $('.container').fadeIn(250);
            document.getElementById('boost-slider').value = data.boost;
            document.getElementById('breaking-slider').value = data.brake;

            document.getElementById('value1').innerHTML = `${data.boost}%`;
            document.getElementById('value2').innerHTML = `${data.brake}%`;
        }
    })
}

AJTuner.Close = function() {
    $('.container').fadeOut(250);
    $.post('https://aj-tunerchip/exit');
}