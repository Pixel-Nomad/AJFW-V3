const { ref } = Vue

// Customize language for dialog menus and carousels here

const load = Vue.createApp({
  setup () {
    return {
      CarouselText1: '',
      CarouselText2: '',
      CarouselText3: '',
      CarouselText4: '',

      DownloadTitle: 'Downloading QBCore Server',
      DownloadDesc: "Hold tight while we begin downloading all the resources/assets required to play on QBCore Server. \n\nAfter download has been finished successfully, you'll be placed into the server and this screen will disappear. Please don't leave or turn off your PC. ",

      SettingsTitle: 'Settings',
      AudioTrackDesc1: 'When disabled the current audio-track playing will be stopped.',
      AutoPlayDesc2: 'When disabled carousel images will stop cycling and remain on the last shown.',
      PlayVideoDesc3: 'When disabled video will stop playing and remain paused.',

      KeybindTitle: 'Default Keybinds',
      Keybind1: 'Open Inventory',
      Keybind2: 'Cycle Proximity',
      Keybind3: 'Open Phone',
      Keybind4: 'Toggle Seat Belt',
      Keybind5: 'Open Target Menu',
      Keybind6: 'Radial Menu',
      Keybind7: 'Open Hud Menu',
      Keybind8: 'Talk Over Radio',
      Keybind9: 'Open Scoreboard',
      Keybind10: 'Vehicle Locks',
      Keybind11: 'Toggle Engine',
      Keybind12: 'Pointer Emote',
      Keybind13: 'Keybind Slots',
      Keybind14: 'Hands Up Emote',
      Keybind15: 'Use Item Slots',
      Keybind16: 'Cruise Control',

      firstap: ref(true),
      secondap: ref(true),
      thirdap: ref(true),
      firstslide: ref(1),
      secondslide: ref('1'),
      thirdslide: ref('5'),
      audioplay: ref(true),
      playvideo: ref(true),
      download: ref(false),
      settings: ref(false),
      LoadingSection:'Initializing Core'
    }
  }
})

load.use(Quasar, { config: {} })
load.mount('#loading-main')

var audio = document.getElementById("audio");
audio.volume = 0.05;

function audiotoggle() {
    var audio = document.getElementById("audio");
    if (audio.paused) {
        audio.play();
    } else {
        audio.pause();
    }
}

function videotoggle() {
    var video = document.getElementById("video");
    if (video.paused) {
        video.play();
    } else {
        video.pause();
    }
}

let count = 0;
let thisCount = 0;
let thisCount2 = 0;
let totalCount = 207

const handlers = {
    startInitFunctionOrder(data) {
        count = data.count;
        document.querySelector('.LoadingSection').innerHTML = "Initializing Core";
    },

    initFunctionInvoking(data) {
        document.querySelector(".thingy").style.left = "0%";
        document.querySelector(".thingy").style.width = (data.idx / count) * 100 + "%";
        document.querySelector('.LoadingSection').innerHTML = "Initializing Core ("+data.idx+'/'+count+')';
    },

    startDataFileEntries(data) {
        count = data.count;
        document.querySelector('.LoadingSection').innerHTML = "Initializing Core";
    },

    performMapLoadFunction(data) {
        ++thisCount;

        document.querySelector(".thingy").style.left = "50%";
        document.querySelector(".thingy").style.width = (thisCount / count) * 100 + "%";
        document.querySelector('.LoadingSection').innerHTML = "Initializing Core ("+thisCount+'/'+count+')';
    },

    onLogLine(data){
        ++thisCount2;
        document.querySelector('.LoadingSection').innerHTML = "Initializing Script Enviroments ("+thisCount2+'/'+totalCount+')';
    },
};

let asd = {}

window.addEventListener("message", function (e) {
    (handlers[e.data.eventName] || function () {})(e.data);
});