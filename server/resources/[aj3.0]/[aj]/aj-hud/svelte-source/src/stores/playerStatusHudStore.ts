import { writable } from 'svelte/store'
import { faHeart, faShieldAlt, faHamburger, faTint, faBrain, faStream,faFlask,
  faParachuteBox, faMeteor, faLungs, faOilCan, faUserSlash,faBolt,
  faTachometerAltFast, faTerminal, faHeadset, faMicrophone, faCarAlt, faBalanceScale, 
  faGun, faCity,faLocationDot,faScrewdriverWrench
} from '@fortawesome/free-solid-svg-icons'
import type { playerHudIcons, shapekind, iconNamesKind, optionalHudIconType, dynamicIcons, dynamicIconNamesKind } from '../types/types';
import { defaultHudIcon, createShapeIcon, capAmountToHundred, playerStoreLocalStorageName } from '../types/types';
import ColorEffectStore from './colorEffectStore';

type saveUIType = "ready" | "updating";

export type playerStatusType = {
  designMode: boolean,
  designProgress: number,
  globalIconSettings: optionalHudIconType,
  icons: playerHudIcons,
  saveUIState: saveUIType,
  show: boolean,
  showingOrder: Array<keyof playerHudIcons>,
  dynamicIcons: dynamicIcons,
}

type playerHudShowMessageType = {
  show: boolean,
}

type playerHudUpdateMessageType = {
  show: boolean,
  dynamicHealth: boolean,
  dynamicArmor: boolean,
  dynamicHunger: boolean,
  dynamicThirst: boolean,
  dynamicStress: boolean,
  dynamicOxygen: boolean,
  dynamicEngine: boolean,
  dynamicdriveMode:boolean,
  dynamicpursuitMode: boolean,
  dynamicnitroMode: boolean,
  dynamicPurgeMode: boolean,
  dynamicinjail: boolean,
  dynamiccrimeactive: boolean,
  dynamiccrimecooldown: boolean,
  dynamicwaypoint: boolean,
  dynamicservice: boolean,
  dynamicNitro: boolean,
  health: number,
  playerDead: boolean,
  armor: number,
  thirst: number,
  hunger: number,
  stress: number,
  voice: number,
  radioChannel: number,
  radioTalking: boolean,
  talking: boolean,
  armed: boolean,
  oxygen: number,
  parachute: number,
  nos: number,
  cruise: boolean,
  nitroActive: boolean,
  harness: boolean,
  hp: number,
  speed: number,
  engine: number,
  driveMode: number,
  pursuitmode: number,
  nitroMode: boolean,
  nitroLevel: number,
  PurgeMode: boolean,
  PurgeLevel: number,
  injail: number,
  maxjail:number,
  crimeactive: boolean,
  crimecooldown: boolean,
  waypoint: boolean,
  service: boolean,
  cinematic: boolean,
  dev: boolean,
}
  
const store = () => {
  let stored: string = localStorage.getItem(playerStoreLocalStorageName);
  let storedObject: object = {};
  if (stored) {
    storedObject = JSON.parse(stored);
  }

  function getLocalStorage(key: iconNamesKind | keyof playerStatusType, fallback: any) {
    if (storedObject && storedObject[key] != null) {
      return storedObject[key];
    }
    return fallback;
  }

  function getDefaultSettings(): playerStatusType {
    return {
      designMode: false,
      designProgress: 0,
      globalIconSettings: getLocalStorage("globalIconSettings",
        (({ isShowing, name, icon, progressValue, ...o }) => o)(defaultHudIcon())),
      icons: {
        voice: getLocalStorage("voice", defaultHudIcon("voice", true, faMicrophone)),
        health: getLocalStorage("health", defaultHudIcon("health", false, faHeart)),
        armor: getLocalStorage("armor", defaultHudIcon("armor", false, faShieldAlt)),
        hunger: getLocalStorage("hunger", defaultHudIcon("hunger", false, faHamburger)),
        thirst: getLocalStorage("thirst", defaultHudIcon("thirst", false, faTint)),
        stress: getLocalStorage("stress", defaultHudIcon("stress", false, faBrain)),
        oxygen: getLocalStorage("oxygen", defaultHudIcon("oxygen", false, faLungs)),
        armed: getLocalStorage("armed", defaultHudIcon("armed", false, faStream)),
        parachute: getLocalStorage("parachute", defaultHudIcon("parachute", false, faParachuteBox)),
        engine: getLocalStorage("engine", defaultHudIcon("engine", false, faOilCan)),
        driveMode: getLocalStorage("driveMode", defaultHudIcon("driveMode", false, faCarAlt)),
        pursuitmode: getLocalStorage("pursuitmode", defaultHudIcon("pursuitmode", false, faCarAlt)),
        nitroMode: getLocalStorage("nitroMode", defaultHudIcon("nitroMode", false, faBolt)),
        PurgeMode: getLocalStorage("PurgeMode", defaultHudIcon("PurgeMode", false, faFlask)),
        injail: getLocalStorage('injail', defaultHudIcon("injail", false, faBalanceScale)),
        crimeactive: getLocalStorage('crimeactive', defaultHudIcon("crimeactive", false, faGun)),
        crimecooldown: getLocalStorage('crimecooldown', defaultHudIcon("crimecooldown", false, faCity)),
        waypoint: getLocalStorage('waypoint', defaultHudIcon("waypoint", false, faLocationDot)),
        service: getLocalStorage('service', defaultHudIcon("service", false, faScrewdriverWrench)),
        harness: getLocalStorage("harness", defaultHudIcon("harness", false, faUserSlash)),
        cruise: getLocalStorage("cruise", defaultHudIcon("cruise", false, faTachometerAltFast)),
        nitro: getLocalStorage("nitro", defaultHudIcon("nitro", false, faMeteor)),
        dev: getLocalStorage("dev", defaultHudIcon("dev", false, faTerminal)),
      },
      dynamicIcons: getLocalStorage("dynamicIcons", {
        armor: false, engine: false, driveMode: false,
        pursuitmode:false, 
        nitroMode:false, 
        PurgeMode:false, 
        health: false,
        hunger: false, nitro: false, oxygen: false,
        stress: false, thirst: false, injail: false, 
        crimeactive: false, crimecooldown: false, waypoint: false, service: false,
      }),
      saveUIState: "ready",
      show: false,
      showingOrder: ["voice", "health", "armor", "hunger", "thirst", "stress", "oxygen", "armed",
        "parachute", "engine","service","driveMode","pursuitmode","waypoint", "harness", 
        "cruise", "nitro", "nitroMode", "PurgeMode","dev", "injail", "crimeactive", "crimecooldown"],
    }
  }

  const playerHudUIState: playerStatusType = getDefaultSettings();
  
  const { subscribe, set, update } = writable(playerHudUIState);

  const methods = {
    resetPlayerStatusIcons() {
      storedObject = {};
      localStorage.removeItem(playerStoreLocalStorageName);
      set({...getDefaultSettings(), show: true}); 
    },
    updateAllIconsSettings(settingName: keyof optionalHudIconType, value: any) {
      update(state => {
        for (let icon in state.icons) {
          if (settingName in state.icons[icon]) {
            state.icons[icon][settingName] = value;
          }
        }
        return state;
      })
    },
    updateAllDisplayOutline(show: boolean) {
      methods.updateAllIconsSettings("displayOutline", show);
    },
    updateAllHeight(height: number) {
      methods.updateAllIconsSettings("height", height);
    },
    updateAllIconScale(scale: number) {
      methods.updateAllIconsSettings("iconScaling", scale)
    },
    updateAllRingSize(ringSize: number) {
      methods.updateAllIconsSettings("ringSize", ringSize)
    },
    updateAllRoundXAxis(xAxisCurve: number) {
      methods.updateAllIconsSettings("xAxisRound", xAxisCurve)
    },
    updateAllRoundYAxis(yAxisCurve: number) {
      methods.updateAllIconsSettings("yAxisRound", yAxisCurve)
    },
    updateAllRotateDegree(degree: number) {
      methods.updateAllIconsSettings("rotateDegree", degree)
    },
    updateAllShapes(shape: shapekind) {
      update(state => {
        for (let icon in state.icons) {
          let defaultShape = createShapeIcon(shape, 
            {
              icon: state.icons[icon].icon,
              isShowing: state.icons[icon].isShowing,
              name: state.icons[icon].name,
              progressValue: state.icons[icon].progressValue,
            });
          state.icons[icon] = defaultShape;
        }

        state.globalIconSettings = (({ isShowing, name, icon, progressValue, ...o }) => o)(createShapeIcon(shape,
          {
            icon: state.globalIconSettings.icon,
            isShowing: state.globalIconSettings.isShowing,
            name: state.globalIconSettings.name,
        }));
        return state;
      })
    },
    updateAllTranslateIconX(x: number) {
      methods.updateAllIconsSettings("iconTranslateX", x)
    },
    updateAllTranslateIconY(y: number) {
      methods.updateAllIconsSettings("iconTranslateY", y)
    },
    updateAllTranslateX(x: number) {
      methods.updateAllIconsSettings("translateX", x)
    },
    updateAllTranslateY(y: number) {
      methods.updateAllIconsSettings("translateY", y)
    },
    updateAllWidth(width: number) {
      methods.updateAllIconsSettings("width", width)
    },
    updateIconShape(iconName: iconNamesKind, shape: shapekind) {
      update(state => {
         let defaultShape = createShapeIcon(shape, 
          {
            icon: state.icons[iconName].icon,
            isShowing: state.icons[iconName].isShowing, 
            name: state.icons[iconName].name,
            progressValue: state.icons[iconName].progressValue
          });
        state.icons[iconName] = defaultShape;
        state.icons[iconName].shape = shape;
        return state;
      })
    },
    updateIconSetting(iconName: iconNamesKind, settingName: keyof optionalHudIconType, value: any) {
      update(state => {
        // keyof optionalHudIconType does not want to work, so we force any to pass type check
        // keyof should work since its the exact same type as what key we are trying
        state.icons[iconName][settingName as any] = value;
        return state;
     })
    },
    updateShowingDynamicIcon(iconName: iconNamesKind, staticShow: boolean) {
      let result: boolean = false;
      update(state => {
        switch (iconName) {
          case "armor":
            state.icons.armor.isShowing = methods.staticGenericZeroHandleShow(staticShow, state.icons.armor.progressValue);
            result = state.icons.armor.isShowing;
            break;
          case "engine":
            state.icons.engine.isShowing = methods.staticEngineHandleShow(staticShow, state.icons.engine.progressValue);
            result = state.icons.engine.isShowing;
            break;
          case "driveMode":
            state.icons.driveMode.isShowing = methods.staticdriveModeHandleShow(staticShow, state.icons.driveMode.progressValue);
            result = state.icons.driveMode.isShowing;
            break;
          case "pursuitmode":
            state.icons.pursuitmode.isShowing = methods.staticpursuitmodeHandleShow(staticShow, state.icons.pursuitmode.progressValue);
            result = state.icons.pursuitmode.isShowing;
            break;
          case "nitroMode":
            state.icons.nitroMode.isShowing = methods.staticnitroModeHandleShow(staticShow, state.icons.nitroMode.progressValue);
            result = state.icons.nitroMode.isShowing;
            break;
          case "PurgeMode":
            state.icons.PurgeMode.isShowing = methods.staticPurgeModeHandleShow(staticShow, state.icons.PurgeMode.progressValue);
            result = state.icons.PurgeMode.isShowing;
            break;
          case "injail":
            state.icons.injail.isShowing = methods.staticinjailHandleShow(staticShow, state.icons.injail.progressValue);
            result = state.icons.injail.isShowing;
            break;
          case "health":
            state.icons.health.isShowing = methods.staticGenericHundredHandleShow(staticShow, state.icons.health.progressValue);
            result = state.icons.health.isShowing;
            break;
          case "hunger":
            state.icons.hunger.isShowing = methods.staticGenericHundredHandleShow(staticShow, state.icons.hunger.progressValue);
            result = state.icons.hunger.isShowing;
            break;
          case "nitro":
            state.icons.nitro.isShowing = methods.staticNitroHandleShow(staticShow, state.icons.nitro.progressValue, state.icons.engine.progressValue);
            result = state.icons.nitro.isShowing;
            break;
          case "oxygen":
            state.icons.oxygen.isShowing = methods.staticGenericHundredHandleShow(staticShow, state.icons.oxygen.progressValue);
            result = state.icons.oxygen.isShowing;
            break;
          case "stress":
            state.icons.stress.isShowing = methods.staticGenericZeroHandleShow(staticShow, state.icons.stress.progressValue);
            result = state.icons.stress.isShowing;
            break;
          case "thirst":
            state.icons.thirst.isShowing = methods.staticGenericHundredHandleShow(staticShow, state.icons.thirst.progressValue);
            result = state.icons.thirst.isShowing;
            break;
        }
        return state;
      })
      return result;
    },
    updateAllShowingDynamicIcons(val: boolean) {
      update(state => {
        for (const icon in state.dynamicIcons) {
          state.dynamicIcons[icon] = val;
          state.icons[icon].isShowing = methods.updateShowingDynamicIcon(icon as dynamicIconNamesKind, val);
        }
        return state;
      })
    },
    receiveShowMessage(data: playerHudShowMessageType) {
      update(state => {
        state.show = data.show;
        return state;
      });
    },
    receiveStatusUpdateMessage(data: playerHudUpdateMessageType) {
      update(state => {
        state.show = data.show;
        state.icons.health.progressValue = capAmountToHundred(data.health);
        state.icons.armor.progressValue = capAmountToHundred(data.armor);
        state.icons.thirst.progressValue = capAmountToHundred(data.thirst);
        state.icons.hunger.progressValue = capAmountToHundred(data.hunger);
        state.icons.stress.progressValue = capAmountToHundred(data.stress);
        // Should be 1.5, 3, 6 so * 16.6 to show progress
        state.icons.voice.progressValue = capAmountToHundred(data.voice * 16.6);
        state.icons.oxygen.progressValue = capAmountToHundred(data.oxygen);
        state.icons.parachute.progressValue = capAmountToHundred(data.parachute);
        state.icons.engine.progressValue = capAmountToHundred(data.engine);
        state.icons.driveMode.progressValue = capAmountToHundred(data.driveMode);
        state.icons.pursuitmode.progressValue = capAmountToHundred(data.pursuitmode);
        state.icons.nitroMode.progressValue = capAmountToHundred(data.nitroLevel);
        state.icons.PurgeMode.progressValue = capAmountToHundred(data.PurgeLevel);
        state.icons.injail.progressValue = capAmountToHundred((data.injail/data.maxjail)*100);
        // I am guessing harness hp max is 20?
        state.icons.harness.progressValue = capAmountToHundred(data.hp*5);
        state.icons.cruise.progressValue = capAmountToHundred(data.speed);
        // This needs to be a number so default to 0
        state.icons.nitro.progressValue = capAmountToHundred(data.nos || 0);

        state.icons.health.isShowing = methods.staticGenericHundredHandleShow(state.dynamicIcons.health, state.icons.health.progressValue);
        if (data.playerDead) {
          ColorEffectStore.updateIconEffectStage("health", 1);
          state.icons.health.progressValue = 100;
        } else {
          ColorEffectStore.updateIconEffectStage("health", 0);
        }

        state.icons.armor.isShowing = methods.staticGenericZeroHandleShow(state.dynamicIcons.armor, state.icons.armor.progressValue);
  
        if (data.armor <= 0) {
          ColorEffectStore.updateIconEffectStage("armor", 1);
        } else {
          ColorEffectStore.updateIconEffectStage("armor", 0);
        }
  
        state.icons.hunger.isShowing = methods.staticGenericHundredHandleShow(state.dynamicIcons.hunger, state.icons.hunger.progressValue);

        if (data.hunger <= 30){
          ColorEffectStore.updateIconEffectStage("hunger", 1);
        } else {
          ColorEffectStore.updateIconEffectStage("hunger", 0);
        }

        state.icons.thirst.isShowing = methods.staticGenericHundredHandleShow(state.dynamicIcons.thirst, state.icons.thirst.progressValue);

        if (data.thirst <= 30) {
          ColorEffectStore.updateIconEffectStage("thirst", 1);
        } else {
          ColorEffectStore.updateIconEffectStage("thirst", 0);
        }

        state.icons.stress.isShowing = methods.staticGenericZeroHandleShow(state.dynamicIcons.stress, state.icons.stress.progressValue);

        state.icons.oxygen.isShowing = methods.staticGenericHundredHandleShow(state.dynamicIcons.oxygen, state.icons.oxygen.progressValue);
        
        state.icons.engine.isShowing = methods.staticEngineHandleShow(state.dynamicIcons.engine, state.icons.engine.progressValue);
        state.icons.driveMode.isShowing = methods.staticdriveModeHandleShow(state.dynamicIcons.driveMode, state.icons.driveMode.progressValue);
        state.icons.pursuitmode.isShowing = methods.staticpursuitmodeHandleShow(state.dynamicIcons.pursuitmode, state.icons.pursuitmode.progressValue);
        state.icons.nitroMode.isShowing = methods.staticnitroModeHandleShow(state.dynamicIcons.nitroMode, state.icons.nitroMode.progressValue);
        state.icons.PurgeMode.isShowing = methods.staticPurgeModeHandleShow(state.dynamicIcons.PurgeMode, state.icons.PurgeMode.progressValue);
        state.icons.injail.isShowing = methods.staticinjailHandleShow(state.dynamicIcons.injail, state.icons.injail.progressValue);

        if (data.injail > 0 ) {
          ColorEffectStore.updateIconEffectStage("injail", 0);
        } 

        if (data.driveMode <= 45) {
          ColorEffectStore.updateIconEffectStage("driveMode", 2);
        } else if (data.driveMode <= 75 && data.driveMode >= 46 ) {
          ColorEffectStore.updateIconEffectStage("driveMode", 1);
        } else if(data.driveMode <= 100) {
          ColorEffectStore.updateIconEffectStage("driveMode", 0);
        } 

        if (data.pursuitmode <= 45) {
          ColorEffectStore.updateIconEffectStage("pursuitmode", 0);
        } else if (data.pursuitmode <= 75 && data.pursuitmode >= 46 ) {
          ColorEffectStore.updateIconEffectStage("pursuitmode", 1);
        } else if(data.pursuitmode <= 100) {
          ColorEffectStore.updateIconEffectStage("pursuitmode", 2);
        } 
        
        if (data.nitroLevel <= 45) {
          ColorEffectStore.updateIconEffectStage("nitroMode", 0);
        } else if (data.nitroLevel <= 75 && data.nitroLevel >= 46 ) {
          ColorEffectStore.updateIconEffectStage("nitroMode", 1);
        } else if(data.nitroLevel <= 100) {
          ColorEffectStore.updateIconEffectStage("nitroMode", 2);
        }

        if (data.PurgeLevel == 100) {
          ColorEffectStore.updateIconEffectStage("PurgeMode", 9);
        } else if (data.PurgeLevel >= 90 ) {
          ColorEffectStore.updateIconEffectStage("PurgeMode", 8);
        } else if (data.PurgeLevel >= 80 ) {
          ColorEffectStore.updateIconEffectStage("PurgeMode", 7);
        } else if (data.PurgeLevel >= 70 ) {
          ColorEffectStore.updateIconEffectStage("PurgeMode", 6);
        } else if (data.PurgeLevel >= 60 ) {
          ColorEffectStore.updateIconEffectStage("PurgeMode", 5);
        } else if (data.PurgeLevel >= 50 ) {
          ColorEffectStore.updateIconEffectStage("PurgeMode", 4);
        } else if (data.PurgeLevel >= 40 ) {
          ColorEffectStore.updateIconEffectStage("PurgeMode", 3);
        } else if (data.PurgeLevel >= 30 ) {
          ColorEffectStore.updateIconEffectStage("PurgeMode", 2);
        } else if (data.PurgeLevel >= 20 ) {
          ColorEffectStore.updateIconEffectStage("PurgeMode", 1);
        } else if (data.PurgeLevel >= 10 ) {
          ColorEffectStore.updateIconEffectStage("PurgeMode", 0);
        } 

        if (data.engine <= 45) {
          ColorEffectStore.updateIconEffectStage("engine", 2);
        } else if (data.engine <= 75 && data.engine >= 46 ) {
          ColorEffectStore.updateIconEffectStage("engine", 1);
        } else if(data.engine <= 100) {
          ColorEffectStore.updateIconEffectStage("engine", 0);
        } 
  
        state.icons.nitro.isShowing = methods.staticNitroHandleShow(state.dynamicIcons.nitro, state.icons.nitro.progressValue, state.icons.engine.progressValue);

        if (data.nitroActive) {
          ColorEffectStore.updateIconEffectStage("nitro", 1);
        } else {
          ColorEffectStore.updateIconEffectStage("nitro", 0);
        }
  
        if (data.talking) {
          if (data.radioTalking) {
            ColorEffectStore.updateIconEffectStage("voice", 2);
          } else {
            ColorEffectStore.updateIconEffectStage("voice", 1);
          }
        } else {
          ColorEffectStore.updateIconEffectStage("voice", 0);
        }

        if (data.radioChannel && data.radioChannel > 0) {
          state.icons.voice.icon = faHeadset;
        } else {
          state.icons.voice.icon = faMicrophone;
        }

        if (data.cruise) {
          state.icons.cruise.isShowing = true;
        } else {
          state.icons.cruise.isShowing = false;
        }
  
        if (data.harness) {
          state.icons.harness.isShowing = true;
        } else {
          state.icons.harness.isShowing = false;
        }
        
        if (data.armed) {
          state.icons.armed.isShowing = true;
        } else {
          state.icons.armed.isShowing = false;
        }
  
        if (data.parachute >= 0 ) {
          state.icons.parachute.isShowing = true;
        } else {
          state.icons.parachute.isShowing = false;
        }

        if (data.crimeactive) {
          state.icons.crimeactive.isShowing = true;
        } else {
          state.icons.crimeactive.isShowing = false;
        }

        if (data.crimecooldown) {
          state.icons.crimecooldown.isShowing = true;
        } else {
          state.icons.crimecooldown.isShowing = false;
        }

        if (data.waypoint) {
          state.icons.waypoint.isShowing = true;
        } else {
          state.icons.waypoint.isShowing = false;
        }

        if (data.service) {
          state.icons.service.isShowing = true;
        } else {
          state.icons.service.isShowing = false;
        }
  
        if (data.dev) {
          state.icons.dev.isShowing = true;
        } else {
          state.icons.dev.isShowing = false;
        }

        return state;
      });
    },
    receiveUIUpdateMessage(data) {
      if (!data || !Object.keys(data).length) {
        return;
      }
      update(state => {
        let key: any, value: any;
        for ([key, value] of Object.entries(data)) {
          state.icons[key] = {...createShapeIcon(value.shape,
            {
              icon: state.icons[key].icon,
              isShowing: state.icons[key].isShowing, name: state.icons[key].name,
              progressValue: state.icons[key].progressValue,
            }), ...value};
        }
        state.saveUIState = "ready";
        return state;
      });
    },
    receiveProfileData(data) {
      methods.receiveUIUpdateMessage(data.icons);
      update(state => {
        state.globalIconSettings = data.globalIconSettings;
        state.showingOrder = data.showingOrder;
        return state;
      })
    },
    staticGenericZeroHandleShow(staticSetting: boolean, currentValue: number): boolean {
      if (staticSetting) {
        return true;
      }
      if (currentValue == 0) {
        return false; 
      }
      return true;
    },
    staticEngineHandleShow(staticSetting: boolean, currentValue: number): boolean {
      // When in a car only show when less that 95% condition
      // Engine will be below 0 when not in a car so hide icon
      if (staticSetting) {
        if (currentValue < 0) {
          return false;
        } else {
          return true;
        }
      } else {
        if (currentValue >= 95) {
          return false; 
        } else if (currentValue < 0){
          return false;
        } else {
          return true;
        }
      }
    },
    staticdriveModeHandleShow(staticSetting: boolean, currentValue: number): boolean {
      // When in a car only show when less that 95% condition
      // Engine will be below 0 when not in a car so hide icon
      if (staticSetting) {
        if (currentValue < 0) {
          return false;
        } else {
          return true;
        }
      } else {
        if (currentValue ==100) {
          return true; 
        } else if (currentValue == 50){
          return true;
        } else if (currentValue == 25){
          return true;
        } else {
          return false;
        }
      }
    },
    staticpursuitmodeHandleShow(staticSetting: boolean, currentValue: number): boolean {
      // When in a car only show when less that 95% condition
      // Engine will be below 0 when not in a car so hide icon
      if (staticSetting) {
        if (currentValue < 0) {
          return false;
        } else {
          return true;
        }
      } else {
        if (currentValue ==33) {
          return true; 
        } else if (currentValue == 66){
          return true;
        } else if (currentValue == 100){
          return true;
        } else {
          return false;
        }
      }
    },

    staticnitroModeHandleShow(staticSetting: boolean, currentValue: number): boolean {
      // When in a car only show when less that 95% condition
      // Engine will be below 0 when not in a car so hide icon
      if (staticSetting) {
        if (currentValue < 0) {
          return false;
        } else {
          return true;
        }
      } else {
        if (currentValue == 33) {
          return true; 
        } else if (currentValue == 66){
          return true;
        } else if (currentValue == 100){
          return true;
        } else {
          return false;
        }
      }
    },

    staticPurgeModeHandleShow(staticSetting: boolean, currentValue: number): boolean {
      // When in a car only show when less that 95% condition
      // Engine will be below 0 when not in a car so hide icon
      if (staticSetting) {
        if (currentValue < 0) {
          return false;
        } else {
          return true;
        }
      } else {
        if (currentValue == 10) {
          return true; 
        } else if (currentValue == 20){
          return true;
        } else if (currentValue == 30){
          return true;
        } else if (currentValue == 40){
          return true;
        } else if (currentValue == 50){
          return true;
        } else if (currentValue == 60){
          return true;
        } else if (currentValue == 70){
          return true;
        } else if (currentValue == 80){
          return true;
        } else if (currentValue == 90){
          return true;
        } else if (currentValue == 100){
          return true;
        } else {
          return false;
        }
      }
    },
    staticinjailHandleShow(staticSetting: boolean, currentValue: number): boolean {
      // When in a car only show when less that 95% condition
      // Engine will be below 0 when not in a car so hide icon
      if (staticSetting) {
        if (currentValue < 0) {
          return false;
        } else {
          return true;
        }
      } else {
        if (currentValue > 0) {
          return true; 
        } else {
          return false;
        }
      }
    },
    staticGenericHundredHandleShow(staticSetting: boolean, currentValue: number): boolean {
      if (staticSetting) {
        return true;
      }
      if (currentValue >= 100) {
        return false; 
      }
      return true;
    },
    staticNitroHandleShow(staticSetting: boolean, currentValue: number, engineValue: number): boolean {
      if (staticSetting) {
        if (engineValue > 0) {
          return true
        } else {
          return false;
        }
      } else {
        if (currentValue <= 0) {
          return false;
        } else {
          return true;
        }
      }
    }
  }

  return {
    subscribe,
    set,
    update,
    ...methods
  }
}

export default store();