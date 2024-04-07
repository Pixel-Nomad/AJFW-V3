import { stateBagWrapper } from "./utils";
import { HornOverride, AddonAudioBanks, Debug, debugLog } from "../shared/shared";

const curSirenSound: Map<number, number> = new Map<number, number>();
const curSiren2Sound: Map<number, number> = new Map<number, number>();
const curHornSound: Map<number, number> = new Map<number, number>();

const exp = global.exports;
exp("getAddonAudioBanks", () => AddonAudioBanks);
exp("getCurSirenSound", () => curSirenSound);
exp("getCurSiren2Sound", () => curSiren2Sound);
exp("getCurHornSound", () => curHornSound);
exp("getDebug", () => Debug);

const getSoundBankForSound = (sound: string): string => {
  for (const [key, value] of AddonAudioBanks) {
    if (typeof value.sounds === "string") {
      if (value.sounds === sound) {
        return key;
      }
    } else {
      for (let i = 1; i < value.sounds.length; i++) {
        if (value.sounds[i] === sound) {
          return key;
        }
      }
    }
  }
  return "";
}

const isAllowedSirens = (veh: number, ped: number): boolean =>
  GetPedInVehicleSeat(veh, -1) === ped && GetVehicleClass(veh) === 18 && !IsPedInAnyHeli(ped) && !IsPedInAnyPlane(ped);

exp("isAllowedSirens", isAllowedSirens);

const releaseSirenSound = (veh: number, soundId: number, isCleanup = false): void => {
  if (isCleanup && (DoesEntityExist(veh) && !IsEntityDead(veh))) return;
  StopSound(soundId);
  ReleaseSoundId(soundId);
  curSirenSound.delete(veh);
}

exp("releaseSirenSound", releaseSirenSound);

const releaseSiren2Sound = (veh: number, soundId: number, isCleanup = false): void => {
  if (isCleanup && (DoesEntityExist(veh) && !IsEntityDead(veh))) return;
  StopSound(soundId);
  ReleaseSoundId(soundId);
  curSiren2Sound.delete(veh);
}

exp("releaseSiren2Sound", releaseSiren2Sound);

const releaseHornSound = (veh: number, soundId: number, isCleanup = false): void => {
  if (isCleanup && (DoesEntityExist(veh) && !IsEntityDead(veh))) return;
  StopSound(soundId);
  ReleaseSoundId(soundId);
  curHornSound.delete(veh);
}

exp("releaseHornSound", releaseHornSound);

let restoreSiren: number = 0;


RegisterCommand("sirenSoundCycle", (): void => {
  const ped: number = PlayerPedId();
  const veh: number = GetVehiclePedIsIn(ped, false);

  if (!isAllowedSirens(veh, ped)) return;

  const ent: StateBagInterface = Entity(veh).state;

  if (!ent.lightsOn) return;

  let newSirenMode: number = (ent.sirenMode || 0) + 1;

  if (newSirenMode > 3) {
    newSirenMode = 1;
  }

  PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);

  ent.set("sirenOn", true, true);
  ent.set("sirenMode", newSirenMode, true);
}, false);

RegisterKeyMapping("sirenSoundCycle", "Siren: Cycle emergency siren sounds", "keyboard", "R");

RegisterCommand("sirensoundRumbler1", (): void =>{
    const ped: number = PlayerPedId();
    const veh: number = GetVehiclePedIsIn(ped, false);
  
    if (!isAllowedSirens(veh, ped)) return;
  
    const ent: StateBagInterface = Entity(veh).state;
    if (!ent.lightsOn) return;
    if (!ent.sirenOn) return;
  
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
  
    ent.set("Rumbler", 0, true);
  
}, false);

RegisterKeyMapping("sirensoundRumbler1", "Siren: CYCLE SIREN MODE", "keyboard", "UP");

RegisterCommand("sirensoundRumbler2", (): void =>{
    const ped: number = PlayerPedId();
    const veh: number = GetVehiclePedIsIn(ped, false);
  
    if (!isAllowedSirens(veh, ped)) return;
  
    const ent: StateBagInterface = Entity(veh).state;
    if (!ent.lightsOn) return;
    if (!ent.sirenOn) return;
  
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
  
    ent.set("Rumbler", 1, true);
  
}, false);

RegisterKeyMapping("sirensoundRumbler2", "Siren: CYCLE SIREN MODE", "keyboard", "LEFT");

RegisterCommand("sirensoundRumbler3", (): void =>{
    const ped: number = PlayerPedId();
    const veh: number = GetVehiclePedIsIn(ped, false);
  
    if (!isAllowedSirens(veh, ped)) return;
  
    const ent: StateBagInterface = Entity(veh).state;
    if (!ent.lightsOn) return;
    if (!ent.sirenOn) return;
  
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
  
    ent.set("Rumbler", 2, true);
  
}, false);

RegisterKeyMapping("sirensoundRumbler3", "Siren: CYCLE SIREN MODE", "keyboard", "RIGHT");
RegisterCommand("sirenSoundOff", (): void => {
  const ped: number = PlayerPedId();
  const veh: number = GetVehiclePedIsIn(ped, false);

  if (!isAllowedSirens(veh, ped)) return;

  const ent: StateBagInterface = Entity(veh).state;

  ent.set("sirenOn", false, true);
  ent.set("siren2On", false, true);
  ent.set("sirenMode", 0, true);
  ent.set("siren2Mode", 0, true);
}, false);

RegisterKeyMapping("sirenSoundOff", "Siren: Turn off your sirens", "keyboard", "PERIOD");

RegisterCommand("+hornHold", (): void => {
  const ped: number = PlayerPedId();
  const veh: number = GetVehiclePedIsIn(ped, false);

  if (!isAllowedSirens(veh, ped)) return;

  const ent: StateBagInterface = Entity(veh).state;

  if (ent.horn) return;

  ent.set("horn", true, true);
  restoreSiren = ent.sirenMode;
  ent.set("sirenMode", 0, true);
}, false);

RegisterCommand("-hornHold", (): void => {
  const ped: number = PlayerPedId();
  const veh: number = GetVehiclePedIsIn(ped, false);

  if (!isAllowedSirens(veh, ped)) return;

  const ent: StateBagInterface = Entity(veh).state;

  if (!ent.horn) return;

  ent.set("horn", false, true);
  ent.set("sirenMode", ent.lightsOn ? restoreSiren : 0, true);
  restoreSiren = 0;
}, false);

RegisterKeyMapping("+hornHold", "Siren: Air horn", "keyboard", "E");

RegisterCommand("sirenSound2Cycle", (): void => {
  const ped: number = PlayerPedId();
  const veh: number = GetVehiclePedIsIn(ped, false);

  if (!isAllowedSirens(veh, ped)) return;

  const ent: StateBagInterface = Entity(veh).state;
  if (!ent.lightsOn) return;

  let newSirenMode: number = (ent.siren2Mode || 0) + 1;
  const sounds: string | string[] = ["SIREN_DELTA", "SIREN_HOTEL"];
    if (newSirenMode > sounds.length) {
      newSirenMode = 1;
    }

  PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);

  ent.set("siren2On", true, true);
  ent.set("siren2Mode", newSirenMode, true);
}, false);

RegisterKeyMapping("sirenSound2Cycle", "Cycle through your emergency vehicle's secondary siren sounds, this doesn't require your emergency lights to be on", "keyboard", "DOWN");

RegisterCommand("sirenLightsToggle", (): void => {
  const ped: number = PlayerPedId();
  const veh: number = GetVehiclePedIsIn(ped, false);

  if (!isAllowedSirens(veh, ped)) return;

  const ent: StateBagInterface = Entity(veh).state;

  PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
  const curMode: boolean = ent.lightsOn;
  ent.set("lightsOn", !curMode, true);

  if (!curMode) return;

  ent.set("siren2On", false, true);
  ent.set("sirenOn", false, true);
  ent.set("sirenMode", 0, true);
  ent.set("siren2Mode", 0, true);
}, false);

RegisterKeyMapping("sirenLightsToggle", "Toggle your emergency vehicle's siren lights", "keyboard", "Q");

stateBagWrapper("horn", (ent: number, value: boolean): void => {
  const relHornId: number | undefined = curHornSound.get(ent);
  if (relHornId !== undefined) {
    releaseHornSound(ent, relHornId);
    debugLog(`[horn] ${ent} has sound, releasing sound id ${relHornId}`);
  };
  if (!value) return;
  const soundId: number = GetSoundId();
  debugLog(`[horn] Setting sound id ${soundId} for ${ent}`);
  curHornSound.set(ent, soundId);
  const soundName: string = HornOverride.get(GetEntityModel(ent)) || "SIRENS_AIRHORN";
  PlaySoundFromEntity(soundId, soundName, ent, 0 as any, false, 0);
});

stateBagWrapper("lightsOn", (ent: number, value: boolean): void => {
  SetVehicleHasMutedSirens(ent, true);
  SetVehicleSiren(ent, value);
  debugLog(`[lights] ${ent} has sirens ${value ? 'on' : 'off'}`);
});

stateBagWrapper("Rumbler", (ent: number, value:number): void => {
  const entt: StateBagInterface = Entity(ent).state;
  const rumbeler = value
  const soundMode = entt.sirenMode
  const relSoundId: number | undefined = curSirenSound.get(ent);
  if (relSoundId !== undefined) {
    releaseSirenSound(ent, relSoundId);
    debugLog(`[sirenMode] ${ent} has sound, releasing sound id ${relSoundId}`);
  };
  if (soundMode === 0) return;
  const soundId: number = GetSoundId();
  curSirenSound.set(ent, soundId);
  debugLog(`[sirenMode] Setting sound id ${soundId} for ${ent}`);
  switch (soundMode) {
    case 1: {
      if (rumbeler == 1) {
        PlaySoundFromEntity(soundId, "SIREN_ECHO", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 2) {
        PlaySoundFromEntity(soundId, "SIREN_ALPHA", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 0) {
        PlaySoundFromEntity(soundId, "VEHICLES_HORNS_SIREN_1", ent, 0, false, 0);
      }
      debugLog(`[sirenMode] playing sound 1 for ${ent} with sound id ${soundId}`);
      break;
    }
    case 2: {
      if (rumbeler == 1) {
        PlaySoundFromEntity(soundId, "SIREN_FOXTROT", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 2) {
        PlaySoundFromEntity(soundId, "SIREN_BRAVO", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 0) {
        PlaySoundFromEntity(soundId, "VEHICLES_HORNS_SIREN_2", ent, 0, false, 0);
      }
      debugLog(`[sirenMode] playing sound 2 for ${ent} with sound id ${soundId}`);
      break;
    }
    case 3: {
      if (rumbeler == 1) {
        PlaySoundFromEntity(soundId, "SIREN_GOLF", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 2) {
        PlaySoundFromEntity(soundId, "SIREN_CHARLIE", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 0) {
        PlaySoundFromEntity(soundId, "VEHICLES_HORNS_POLICE_WARNING", ent, 0, false, 0);
      }
      debugLog(`[sirenMode] playing sound 3 for ${ent} with sound id ${soundId}`);
      break;
    }
    default: {
      releaseSirenSound(ent, soundId);
      debugLog(`[sirenMode] invalid soundMode sent to ${ent} with sound id ${soundId}, releasing sound`);
    }
  }

});

stateBagWrapper("sirenMode", (ent: number, soundMode: number): void => {
  const relSoundId: number | undefined = curSirenSound.get(ent);
  const entt: StateBagInterface = Entity(ent).state;
  const rumbeler = entt.Rumbler
  if (relSoundId !== undefined) {
    releaseSirenSound(ent, relSoundId);
    debugLog(`[sirenMode] ${ent} has sound, releasing sound id ${relSoundId}`);
  };
  if (soundMode === 0) return;
  const soundId: number = GetSoundId();
  curSirenSound.set(ent, soundId);
  debugLog(`[sirenMode] Setting sound id ${soundId} for ${ent}`);
  switch (soundMode) {
    case 1: {
      if (rumbeler == 1) {
        PlaySoundFromEntity(soundId, "SIREN_ECHO", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 2) {
        PlaySoundFromEntity(soundId, "SIREN_ALPHA", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 0) {
        PlaySoundFromEntity(soundId, "VEHICLES_HORNS_SIREN_1", ent, 0, false, 0);
      }
      debugLog(`[sirenMode] playing sound 1 for ${ent} with sound id ${soundId}`);
      break;
    }
    case 2: {
      if (rumbeler == 1) {
        PlaySoundFromEntity(soundId, "SIREN_FOXTROT", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 2) {
        PlaySoundFromEntity(soundId, "SIREN_BRAVO", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 0) {
        PlaySoundFromEntity(soundId, "VEHICLES_HORNS_SIREN_2", ent, 0, false, 0);
      }
      debugLog(`[sirenMode] playing sound 2 for ${ent} with sound id ${soundId}`);
      break;
    }
    case 3: {
      if (rumbeler == 1) {
        PlaySoundFromEntity(soundId, "SIREN_GOLF", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 2) {
        PlaySoundFromEntity(soundId, "SIREN_CHARLIE", ent, "DLC_WMSIRENS_SOUNDSET", false, 0);
      } else if (rumbeler == 0) {
        PlaySoundFromEntity(soundId, "VEHICLES_HORNS_POLICE_WARNING", ent, 0, false, 0);
      }
      debugLog(`[sirenMode] playing sound 3 for ${ent} with sound id ${soundId}`);
      break;
    }
    default: {
      releaseSirenSound(ent, soundId);
      debugLog(`[sirenMode] invalid soundMode sent to ${ent} with sound id ${soundId}, releasing sound`);
    }
  }
});

stateBagWrapper("siren2Mode", (ent: number, soundMode: number): void => {
  const relSoundId: number | undefined = curSiren2Sound.get(ent);
  if (relSoundId !== undefined) {
    releaseSiren2Sound(ent, relSoundId);
    debugLog(`[siren2Mode] ${ent} has sound, releasing sound id ${relSoundId}`);
  };
  if (soundMode === 0) return;
  const soundId: number = GetSoundId();
  curSiren2Sound.set(ent, soundId);
  debugLog(`[siren2Mode] Setting sound id ${soundId} for ${ent}`);
  const sounds: string | string[] = ["SIREN_DELTA", "SIREN_HOTEL"];
  if (typeof sounds === "string") {
    const soundBank = getSoundBankForSound(sounds);
    PlaySoundFromEntity(soundId, sounds, ent, soundBank !== "" ? soundBank : 0 as any, false, 0);
    debugLog(`[siren2Mode] playing sound 1 for ${ent} with sound id ${soundId}`);
  } else {
    for (let i = 0; i < sounds.length; i++) {
      if ((soundMode - 1) === i) {
        const soundBank = getSoundBankForSound(sounds[i]);
        PlaySoundFromEntity(soundId, sounds[i], ent, soundBank !== "" ? soundBank : 0 as any, false, 0);
        debugLog(`[siren2Mode] playing sound ${i + 1} for ${ent} with sound id ${soundId}`);
        return;
      }
    }
    releaseSirenSound(ent, soundId);
    debugLog(`[siren2Mode] invalid soundMode sent to ${ent} with sound id ${soundId}, releasing sound`);
  }
});