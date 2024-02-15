$(function() {
    window.addEventListener('message', function(event) {
        if(event.data.type == "publicphoneopen"){
            $('.publicphonebase').css('display', 'block');
        } else if (event.data.type == "publicphoneclose"){
            $('.publicphonebase').css('display', 'none');
            $.post('https://aj-phone/publicphoneclose', JSON.stringify({}));
        }
    });
});

$(".publicphoneclosebtn").click(function(){
    $.post('https://aj-phone/publicphoneclose', JSON.stringify({}));
    $('.publicphonebase').css('display', 'none');
    $("#publicphonechannelnumpad").val("");
});
$(".publicphonecallbtn").click(function(){
    $.post('https://aj-phone/publicphoneclose', JSON.stringify({}));
    $('.publicphonebase').css('display', 'none');
    setTimeout(function(){
        $("#publicphonechannelnumpad").val("");
    }, 100);

});



$(document).on('click', ".publicphonecallbtn", function(e){
    e.preventDefault();

    var publicphoneInputNum = $("#publicphonechannelnumpad").val();

    cData = {
        number: publicphoneInputNum,
        name: publicphoneInputNum,
    }

    $.post('https://aj-phone/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: true,
    }), function(status){
        if (cData.number !== AJ.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        $(".phone-call-outgoing").css({"display":"none"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        AJ.Phone.Functions.HeaderTextColor("white", 400);
                        AJ.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);

                        setTimeout(function(){
                            $(".phone-app").css({"display":"none"});
                            AJ.Phone.Animations.TopSlideDown('.phone-application-container', 400, -160);
                            AJ.Phone.Functions.ToggleApp("phone-call", "block");
                            $(".phone-currentcall-container").css({"display":"block"});
                            $("#incoming-answer").css({"display":"none"});
                        }, 450);

                        CallData.name = cData.name;
                        CallData.number = cData.number;

                        AJ.Phone.Data.currentApplication = "phone-call";
                    } else {
                        AJ.Phone.Notifications.Add("fas fa-phone", "Phone", "You're already in a call!");
                    }
                } else {
                    AJ.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is busy!");
                }
            } else {
                AJ.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is not available!");
            }
        } else {
            AJ.Phone.Notifications.Add("fas fa-phone", "Phone", "You can't call yourself!");
        }
    });

});