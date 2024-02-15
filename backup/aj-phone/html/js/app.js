AJ = {}
AJ.Phone = {}
AJ.Screen = {}
AJ.Phone.Functions = {}
AJ.Phone.Animations = {}
AJ.Phone.Notifications = {}
AJ.Phone.ContactColors = {
    0: "#9b59b6",
    1: "#3498db",
    2: "#e67e22",
    3: "#e74c3c",
    4: "#1abc9c",
    5: "#9c88ff",
}

AJ.Phone.Data = {
    currentApplication: null,
    PlayerData: {},
    Applications: {},
    IsOpen: false,
    CallActive: false,
    MetaData: {},
    PlayerJob: {},
    AnonymousCall: false,
}

AJ.Phone.Data.MaxSlots = 16;

OpenedChatData = {
    number: null,
}

var CanOpenApp = true;
var up = false

function IsAppJobBlocked(joblist, myjob) {
    var retval = false;
    if (joblist.length > 0) {
        $.each(joblist, function(i, job){
            if (job == myjob && AJ.Phone.Data.PlayerData.job.onduty) {
                retval = true;
            }
        });
    }
    return retval;
}

AJ.Phone.Functions.SetupApplications = function(data) {
    AJ.Phone.Data.Applications = data.applications;

    var i;
    for (i = 1; i <= AJ.Phone.Data.MaxSlots; i++) {
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+i+'"]');
        $(applicationSlot).html("");
        $(applicationSlot).css({
            "background-color":"transparent"
        });
        $(applicationSlot).prop('title', "");
        $(applicationSlot).removeData('app');
        $(applicationSlot).removeData('placement')
    }

    $.each(data.applications, function(i, app){
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+app.slot+'"]');
        var blockedapp = IsAppJobBlocked(app.blockedjobs, AJ.Phone.Data.PlayerJob.name)

        if ((!app.job || app.job === AJ.Phone.Data.PlayerJob.name) && !blockedapp) {
            $(applicationSlot).css({"background-color":app.color});
            var icon = '<i class="ApplicationIcon '+app.icon+'" style="'+app.style+'"></i>';
            if (app.app == "meos") {
                icon = '<img src="./img/politie.png" class="police-icon">';
            }
            $(applicationSlot).html(icon+'<div class="app-unread-alerts">0</div>');
            $(applicationSlot).prop('title', app.tooltipText);
            $(applicationSlot).data('app', app.app);

            if (app.tooltipPos !== undefined) {
                $(applicationSlot).data('placement', app.tooltipPos)
            }
        }
    });

    $('[data-toggle="tooltip"]').tooltip();
}

AJ.Phone.Functions.SetupAppWarnings = function(AppData) {
    $.each(AppData, function(i, app){
        var AppObject = $(".phone-applications").find("[data-appslot='"+app.slot+"']").find('.app-unread-alerts');

        if (app.Alerts > 0) {
            $(AppObject).html(app.Alerts);
            $(AppObject).css({"display":"block"});
        } else {
            $(AppObject).css({"display":"none"});
        }
    });
}

AJ.Phone.Functions.IsAppHeaderAllowed = function(app) {
    var retval = true;
    $.each(Config.HeaderDisabledApps, function(i, blocked){
        if (app == blocked) {
            retval = false;
        }
    });
    return retval;
}

$(document).on('click', '.phone-application', function(e){
    e.preventDefault();
    var PressedApplication = $(this).data('app');
    var AppObject = $("."+PressedApplication+"-app");

    if (AppObject.length !== 0) {
        if (CanOpenApp) {
            if (AJ.Phone.Data.currentApplication == null) {
                AJ.Phone.Animations.TopSlideDown('.phone-application-container', 300, 0);
                AJ.Phone.Functions.ToggleApp(PressedApplication, "block");

                if (AJ.Phone.Functions.IsAppHeaderAllowed(PressedApplication)) {
                    AJ.Phone.Functions.HeaderTextColor("black", 300);
                }

                AJ.Phone.Data.currentApplication = PressedApplication;

                if (PressedApplication == "settings") {
                    $("#myPhoneNumber").text(AJ.Phone.Data.PlayerData.charinfo.phone);
                    $("#mySerialNumber").text("AJ-" + AJ.Phone.Data.PlayerData.metadata["phonedata"].SerialNumber);
                } else if (PressedApplication == "twitter") {
                    $.post('https://aj-phone/GetMentionedTweets', JSON.stringify({}), function(MentionedTweets){
                        AJ.Phone.Notifications.LoadMentionedTweets(MentionedTweets)
                    })
                    $.post('https://aj-phone/GetHashtags', JSON.stringify({}), function(Hashtags){
                        AJ.Phone.Notifications.LoadHashtags(Hashtags)
                    })
                    if (AJ.Phone.Data.IsOpen) {
                        $.post('https://aj-phone/GetTweets', JSON.stringify({}), function(Tweets){
                            AJ.Phone.Notifications.LoadTweets(Tweets);
                        });
                    }
                } else if (PressedApplication == "bank") {
                    AJ.Phone.Functions.DoBankOpen();
                    $.post('https://aj-phone/GetBankContacts', JSON.stringify({}), function(contacts){
                        AJ.Phone.Functions.LoadContactsWithNumber(contacts);
                    });
                    $.post('https://aj-phone/GetInvoices', JSON.stringify({}), function(invoices){
                        AJ.Phone.Functions.LoadBankInvoices(invoices);
                    });
                } else if (PressedApplication == "whatsapp") {
                    $.post('https://aj-phone/GetWhatsappChats', JSON.stringify({}), function(chats){
                        AJ.Phone.Functions.LoadWhatsappChats(chats);
                    });
                } else if (PressedApplication == "phone") {
                    $.post('https://aj-phone/GetMissedCalls', JSON.stringify({}), function(recent){
                        AJ.Phone.Functions.SetupRecentCalls(recent);
                    });
                    $.post('https://aj-phone/GetSuggestedContacts', JSON.stringify({}), function(suggested){
                        AJ.Phone.Functions.SetupSuggestedContacts(suggested);
                    });
                    $.post('https://aj-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "phone"
                    }));
                } else if (PressedApplication == "mail") {
                    $.post('https://aj-phone/GetMails', JSON.stringify({}), function(mails){
                        AJ.Phone.Functions.SetupMails(mails);
                    });
                    $.post('https://aj-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "mail"
                    }));
                } else if (PressedApplication == "advert") {
                    $.post('https://aj-phone/LoadAdverts', JSON.stringify({}), function(Adverts){
                        AJ.Phone.Functions.RefreshAdverts(Adverts);
                    })
                } else if (PressedApplication == "garage") {
                    $.post('https://aj-phone/SetupGarageVehicles', JSON.stringify({}), function(Vehicles){
                        SetupGarageVehicles(Vehicles);
                    })
                } else if (PressedApplication == "crypto") {
                    $.post('https://aj-phone/GetCryptoData', JSON.stringify({
                        crypto: "ajit",
                    }), function(CryptoData){
                        SetupCryptoData(CryptoData);
                    })

                    $.post('https://aj-phone/GetCryptoTransactions', JSON.stringify({}), function(data){
                        RefreshCryptoTransactions(data);
                    })
                } else if (PressedApplication == "racing") {
                    $.post('https://aj-phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                        SetupRaces(Races);
                    });
                } else if (PressedApplication == "houses") {
                    $.post('https://aj-phone/GetPlayerHouses', JSON.stringify({}), function(Houses){
                        SetupPlayerHouses(Houses);
                    });
                    $.post('https://aj-phone/GetPlayerKeys', JSON.stringify({}), function(Keys){
                        $(".house-app-mykeys-container").html("");
                        if (Keys.length > 0) {
                            $.each(Keys, function(i, key){
                                var elem = '<div class="mykeys-key" id="keyid-'+i+'"><span class="mykeys-key-label">' + key.HouseData.adress + '</span> <span class="mykeys-key-sub">Click to set GPS</span> </div>';
                                $(".house-app-mykeys-container").append(elem);
                                $("#keyid-"+i).data('KeyData', key);
                            });
                        }
                    });
                } else if (PressedApplication == "meos") {
                    SetupMeosHome();
                } else if (PressedApplication == "lawyers") {
                    $.post('https://aj-phone/GetCurrentLawyers', JSON.stringify({}), function(data){
                        SetupLawyers(data);
                    });
                } else if (PressedApplication == "store") {
                    $.post('https://aj-phone/SetupStoreApps', JSON.stringify({}), function(data){
                        SetupAppstore(data);
                    });
                } else if (PressedApplication == "trucker") {
                    $.post('https://aj-phone/GetTruckerData', JSON.stringify({}), function(data){
                        SetupTruckerInfo(data);
                    });
                }
                else if (PressedApplication == "gallery") {
                    $.post('https://aj-phone/GetGalleryData', JSON.stringify({}), function(data){
                        setUpGalleryData(data);
                    });
                }
                else if (PressedApplication == "camera") {
                    $.post('https://aj-phone/TakePhoto', JSON.stringify({}),function(url){
                        setUpCameraApp(url)
                    })
                    AJ.Phone.Functions.Close();
                }

                
            }
        }
    } else {
        if (PressedApplication != null){
            AJ.Phone.Notifications.Add("fas fa-exclamation-circle", "System", AJ.Phone.Data.Applications[PressedApplication].tooltipText+" is not available!")
        }
    }
});

$(document).on('click', '.mykeys-key', function(e){
    e.preventDefault();

    var KeyData = $(this).data('KeyData');

    $.post('https://aj-phone/SetHouseLocation', JSON.stringify({
        HouseData: KeyData
    }))
});

$(document).on('click', '.phone-home-container', function(event){
    event.preventDefault();

    if (AJ.Phone.Data.currentApplication === null) {
        AJ.Phone.Functions.Close();
    } else {
        AJ.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        AJ.Phone.Animations.TopSlideUp('.'+AJ.Phone.Data.currentApplication+"-app", 400, -160);
        CanOpenApp = false;
        setTimeout(function(){
            AJ.Phone.Functions.ToggleApp(AJ.Phone.Data.currentApplication, "none");
            CanOpenApp = true;
        }, 400)
        AJ.Phone.Functions.HeaderTextColor("white", 300);

        if (AJ.Phone.Data.currentApplication == "whatsapp") {
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatPicture = null;
                    OpenedChatData.number = null;
                }, 450);
            }
        } else if (AJ.Phone.Data.currentApplication == "bank") {
            if (CurrentTab == "invoices") {
                setTimeout(function(){
                    $(".bank-app-invoices").animate({"left": "30vh"});
                    $(".bank-app-invoices").css({"display":"none"})
                    $(".bank-app-accounts").css({"display":"block"})
                    $(".bank-app-accounts").css({"left": "0vh"});

                    var InvoicesObjectBank = $(".bank-app-header").find('[data-headertype="invoices"]');
                    var HomeObjectBank = $(".bank-app-header").find('[data-headertype="accounts"]');

                    $(InvoicesObjectBank).removeClass('bank-app-header-button-selected');
                    $(HomeObjectBank).addClass('bank-app-header-button-selected');

                    CurrentTab = "accounts";
                }, 400)
            }
        } else if (AJ.Phone.Data.currentApplication == "meos") {
            $(".meos-alert-new").remove();
            setTimeout(function(){
                $(".meos-recent-alert").removeClass("noodknop");
                $(".meos-recent-alert").css({"background-color":"#004682"});
            }, 400)
        }

        AJ.Phone.Data.currentApplication = null;
    }
});

AJ.Phone.Functions.Open = function(data) {
    AJ.Phone.Animations.BottomSlideUp('.container', 300, 0);
    AJ.Phone.Notifications.LoadTweets(data.Tweets);
    AJ.Phone.Data.IsOpen = true;
}

AJ.Phone.Functions.ToggleApp = function(app, show) {
    $("."+app+"-app").css({"display":show});
}

AJ.Phone.Functions.Close = function() {

    if (AJ.Phone.Data.currentApplication == "whatsapp") {
        setTimeout(function(){
            AJ.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
            AJ.Phone.Animations.TopSlideUp('.'+AJ.Phone.Data.currentApplication+"-app", 400, -160);
            $(".whatsapp-app").css({"display":"none"});
            AJ.Phone.Functions.HeaderTextColor("white", 300);

            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatData.number = null;
                }, 450);
            }
            OpenedChatPicture = null;
            AJ.Phone.Data.currentApplication = null;
        }, 500)
    } else if (AJ.Phone.Data.currentApplication == "meos") {
        $(".meos-alert-new").remove();
        $(".meos-recent-alert").removeClass("noodknop");
        $(".meos-recent-alert").css({"background-color":"#004682"});
    }

    AJ.Phone.Animations.BottomSlideDown('.container', 300, -70);
    $.post('https://aj-phone/Close');
    AJ.Phone.Data.IsOpen = false;
}

AJ.Phone.Functions.HeaderTextColor = function(newColor, Timeout) {
    $(".phone-header").animate({color: newColor}, Timeout);
}

AJ.Phone.Animations.BottomSlideUp = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout);
}

AJ.Phone.Animations.BottomSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

AJ.Phone.Animations.TopSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout);
}

AJ.Phone.Animations.TopSlideUp = function(Object, Timeout, Percentage, cb) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

AJ.Phone.Notifications.Add = function(icon, title, text, color, timeout) {
    $.post('https://aj-phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (timeout == null && timeout == undefined) {
                timeout = 1500;
            }
            if (AJ.Phone.Notifications.Timeout == undefined || AJ.Phone.Notifications.Timeout == null) {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else if (color == "default" || color == null || color == undefined) {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                if (!AJ.Phone.Data.IsOpen) {
                    AJ.Phone.Animations.BottomSlideUp('.container', 300, -52);
                }
                AJ.Phone.Animations.TopSlideDown(".phone-notification-container", 200, 8);
                if (icon !== "politie") {
                    $(".notification-icon").html('<i class="'+icon+'"></i>');
                } else {
                    $(".notification-icon").html('<img src="./img/politie.png" class="police-icon-notify">');
                }
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (AJ.Phone.Notifications.Timeout !== undefined || AJ.Phone.Notifications.Timeout !== null) {
                    clearTimeout(AJ.Phone.Notifications.Timeout);
                }
                AJ.Phone.Notifications.Timeout = setTimeout(function(){
                    AJ.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    if (!AJ.Phone.Data.IsOpen) {
                        AJ.Phone.Animations.BottomSlideUp('.container', 300, -100);
                    }
                    AJ.Phone.Notifications.Timeout = null;
                }, timeout);
            } else {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                if (!AJ.Phone.Data.IsOpen) {
                    AJ.Phone.Animations.BottomSlideUp('.container', 300, -52);
                }
                $(".notification-icon").html('<i class="'+icon+'"></i>');
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (AJ.Phone.Notifications.Timeout !== undefined || AJ.Phone.Notifications.Timeout !== null) {
                    clearTimeout(AJ.Phone.Notifications.Timeout);
                }
                AJ.Phone.Notifications.Timeout = setTimeout(function(){
                    AJ.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    if (!AJ.Phone.Data.IsOpen) {
                        AJ.Phone.Animations.BottomSlideUp('.container', 300, -100);
                    }
                    AJ.Phone.Notifications.Timeout = null;
                }, timeout);
            }
        }
    });
}

AJ.Phone.Functions.LoadPhoneData = function(data) {
    AJ.Phone.Data.PlayerData = data.PlayerData;
    AJ.Phone.Data.PlayerJob = data.PlayerJob;
    AJ.Phone.Data.MetaData = data.PhoneData.MetaData;
    AJ.Phone.Functions.LoadMetaData(data.PhoneData.MetaData);
    AJ.Phone.Functions.LoadContacts(data.PhoneData.Contacts);
    AJ.Phone.Functions.SetupApplications(data);

    $("#player-id").html("<span>" + "ID: " + data.PlayerId + "</span>")
}

AJ.Phone.Functions.UpdateTime = function(data) {
    var NewDate = new Date();
    var NewHour = NewDate.getHours();
    var NewMinute = NewDate.getMinutes();
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    if (NewHour < 10) {
        Hourssssss = "0" + Hourssssss;
    }
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    var MessageTime = Hourssssss + ":" + Minutessss

    $("#phone-time").html("<span>" + data.InGameTime.hour + ":" + data.InGameTime.minute + "</span>");
}

var NotificationTimeout = null;

AJ.Screen.Notification = function(title, content, icon, timeout, color) {
    $.post('https://aj-phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (color != null && color != undefined) {
                $(".screen-notifications-container").css({"background-color":color});
            }
            $(".screen-notification-icon").html('<i class="'+icon+'"></i>');
            $(".screen-notification-title").text(title);
            $(".screen-notification-content").text(content);
            $(".screen-notifications-container").css({'display':'block'}).animate({
                right: 5+"vh",
            }, 200);

            if (NotificationTimeout != null) {
                clearTimeout(NotificationTimeout);
            }

            NotificationTimeout = setTimeout(function(){
                $(".screen-notifications-container").animate({
                    right: -35+"vh",
                }, 200, function(){
                    $(".screen-notifications-container").css({'display':'none'});
                });
                NotificationTimeout = null;
            }, timeout);
        }
    });
}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
        if (up){
            $('#popup').fadeOut('slow');
            $('.popupclass').fadeOut('slow');
            $('.popupclass').html("");
            up = false
        } else {
            AJ.Phone.Functions.Close();
            break;
        }
    }
});

AJ.Screen.popUp = function(source){
    if(!up){
        $('#popup').fadeIn('slow');
        $('.popupclass').fadeIn('slow');
        $('<img  src='+source+' style = "width:100%; height: 100%;">').appendTo('.popupclass')
        up = true
    }
}

AJ.Screen.popDown = function(){
    if(up){
        $('#popup').fadeOut('slow');
        $('.popupclass').fadeOut('slow');
        $('.popupclass').html("");
        up = false
    }
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                AJ.Phone.Functions.Open(event.data);
                AJ.Phone.Functions.SetupAppWarnings(event.data.AppData);
                AJ.Phone.Functions.SetupCurrentCall(event.data.CallData);
                AJ.Phone.Data.IsOpen = true;
                AJ.Phone.Data.PlayerData = event.data.PlayerData;
                break;
            case "LoadPhoneData":
                AJ.Phone.Functions.LoadPhoneData(event.data);
                break;
            case "UpdateTime":
                AJ.Phone.Functions.UpdateTime(event.data);
                break;
            case "Notification":
                AJ.Screen.Notification(event.data.NotifyData.title, event.data.NotifyData.content, event.data.NotifyData.icon, event.data.NotifyData.timeout, event.data.NotifyData.color);
                break;
            case "PhoneNotification":
                AJ.Phone.Notifications.Add(event.data.PhoneNotify.icon, event.data.PhoneNotify.title, event.data.PhoneNotify.text, event.data.PhoneNotify.color, event.data.PhoneNotify.timeout);
                break;
            case "RefreshAppAlerts":
                AJ.Phone.Functions.SetupAppWarnings(event.data.AppData);
                break;
            case "UpdateMentionedTweets":
                AJ.Phone.Notifications.LoadMentionedTweets(event.data.Tweets);
                break;
            case "UpdateBank":
                $(".bank-app-account-balance").html("&#36; "+event.data.NewBalance);
                $(".bank-app-account-balance").data('balance', event.data.NewBalance);
                break;
            case "UpdateChat":
                if (AJ.Phone.Data.currentApplication == "whatsapp") {
                    if (OpenedChatData.number !== null && OpenedChatData.number == event.data.chatNumber) {
                        AJ.Phone.Functions.SetupChatMessages(event.data.chatData);
                    } else {
                        AJ.Phone.Functions.LoadWhatsappChats(event.data.Chats);
                    }
                }
                break;
            case "UpdateHashtags":
                AJ.Phone.Notifications.LoadHashtags(event.data.Hashtags);
                break;
            case "RefreshWhatsappAlerts":
                AJ.Phone.Functions.ReloadWhatsappAlerts(event.data.Chats);
                break;
            case "CancelOutgoingCall":
                $.post('https://aj-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        CancelOutgoingCall();
                    }
                });
                break;
            case "IncomingCallAlert":
                $.post('https://aj-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        IncomingCallAlert(event.data.CallData, event.data.Canceled, event.data.AnonymousCall);
                    }
                });
                break;
            case "SetupHomeCall":
                AJ.Phone.Functions.SetupCurrentCall(event.data.CallData);
                break;
            case "AnswerCall":
                AJ.Phone.Functions.AnswerCall(event.data.CallData);
                break;
            case "UpdateCallTime":
                var CallTime = event.data.Time;
                var date = new Date(null);
                date.setSeconds(CallTime);
                var timeString = date.toISOString().substr(11, 8);
                if (!AJ.Phone.Data.IsOpen) {
                    if ($(".call-notifications").css("right") !== "52.1px") {
                        $(".call-notifications").css({"display":"block"});
                        $(".call-notifications").animate({right: 5+"vh"});
                    }
                    $(".call-notifications-title").html("In conversation ("+timeString+")");
                    $(".call-notifications-content").html("Calling with "+event.data.Name);
                    $(".call-notifications").removeClass('call-notifications-shake');
                } else {
                    $(".call-notifications").animate({
                        right: -35+"vh"
                    }, 400, function(){
                        $(".call-notifications").css({"display":"none"});
                    });
                }
                $(".phone-call-ongoing-time").html(timeString);
                $(".phone-currentcall-title").html("In conversation ("+timeString+")");
                break;
            case "CancelOngoingCall":
                $(".call-notifications").animate({right: -35+"vh"}, function(){
                    $(".call-notifications").css({"display":"none"});
                });
                AJ.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                setTimeout(function(){
                    AJ.Phone.Functions.ToggleApp("phone-call", "none");
                    $(".phone-application-container").css({"display":"none"});
                }, 400)
                AJ.Phone.Functions.HeaderTextColor("white", 300);

                AJ.Phone.Data.CallActive = false;
                AJ.Phone.Data.currentApplication = null;
                break;
            case "RefreshContacts":
                AJ.Phone.Functions.LoadContacts(event.data.Contacts);
                break;
            case "UpdateMails":
                AJ.Phone.Functions.SetupMails(event.data.Mails);
                break;
            case "RefreshAdverts":
                if (AJ.Phone.Data.currentApplication == "advert") {
                    AJ.Phone.Functions.RefreshAdverts(event.data.Adverts);
                }
                break;
            case "UpdateTweets":
                if (AJ.Phone.Data.currentApplication == "twitter") {
                    AJ.Phone.Notifications.LoadTweets(event.data.Tweets);
                }
                break;
            case "AddPoliceAlert":
                AddPoliceAlert(event.data)
                break;
            case "UpdateApplications":
                AJ.Phone.Data.PlayerJob = event.data.JobData;
                AJ.Phone.Functions.SetupApplications(event.data);
                break;
            case "UpdateTransactions":
                RefreshCryptoTransactions(event.data);
                break;
            case "UpdateRacingApp":
                $.post('https://aj-phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                    SetupRaces(Races);
                });
                break;
            case "RefreshAlerts":
                AJ.Phone.Functions.SetupAppWarnings(event.data.AppData);
                break;
        }
    })
});