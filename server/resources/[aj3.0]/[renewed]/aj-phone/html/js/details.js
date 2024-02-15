function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
 }

function LoadPlayerMoneys(){
    var PlayerPhoneNumber = AJ.Phone.Data.PlayerData.charinfo.phone;
    var PlayerBankAcc = AJ.Phone.Data.PlayerData.charinfo.account;
    var PlayerBankMoney = AJ.Phone.Data.PlayerData.money.bank;
    var PlayerCashMoney = AJ.Phone.Data.PlayerData.money.cash;
    var PlayerStateID = AJ.Phone.Data.PlayerData.citizenid;

    $(".details-phone").html(PlayerPhoneNumber)
    $(".details-bankserial").html(PlayerBankAcc)
    $(".details-bankmoney").html("$"+numberWithCommas(PlayerBankMoney))
    $(".details-cashmoney").html("$"+numberWithCommas(PlayerCashMoney))
    $(".details-stateid").html(PlayerStateID)

    var PlayerLicenses = AJ.Phone.Data.PlayerData.metadata.licences;

    $(".details-list").html("");
    var AddOption0 = '<div class="details-text-license">Licenses</div>'
    $('.details-list').append(AddOption0);
    for (const [k, v] of Object.entries(PlayerLicenses)) {
        if (v){
            var firstLetter = k.substring(0, 1);  
            var Fulltext = firstLetter.toUpperCase()+k.replace(firstLetter,'')+" License"

            var AddOption = '<div class="details-license-body-main">'+
                                '<div class="details-license-text-class">'+Fulltext+'</div>'+
                                '<div class="details-license-icon-class"><i style="color: #b1d18e;" class="fas fa-check-circle"></i></div>'+
                            '</div>'
            $('.details-list').append(AddOption);
        }
    }
}
