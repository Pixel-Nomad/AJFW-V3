DashcamConfig = {}

DashcamConfig.useMPH = true -- False will turn it to KMH

DashcamConfig.RestrictVehicles = true
DashcamConfig.RestrictionType = "custom" -- custom / class

DashcamConfig.AllowedVehicles = {
    ["ambulance"]='ems',
    ["emsf250"]='ems',
    ["emscap"]='ems',
    ["iak_wheelchair"]='no',
    ["emsdurango"]='ems',
    ["ems18charg"]='ems',
    ["code3bmw"]='no',
    ["camaroRB"]='police',
    ["code3cvpi"]='police',
    ["code3gator"]='police',
    ["code3mustang"]='police',
    ["code3silverado"]='police',
    ["code318charg"]='police',
    ["code318tahoe"]='police',
    ["code320exp"]='police',
    ["pbike"]='no',
    ["pbus"]='police',
    ["amggtrleo"]='police',
    ["911turboleo"]='police',
    ["modelsleo"]='police',
    ["viperleo"]='police',
    ["riot"]='police',
    ["18raptor"]='police',
    ["swat"]='police',
    ["d"]='police',
    ["npolmm"]='no',
    ["polas350"]='no',
    ["polmav"]='no',
    ["npolchar"]='police',
}