// After the following section:
/*

if (!isNull _nearLight) then {
    if (_nearLight distance player < 4) then {
        _canPickLight = isNull (_nearLight getVariable ["owner",objNull]);
    };
};


*/

// Add the following:

// ---------------------------------------RUSSIAN ROULETTE START------------------------------------
local _myWeapon = currentWeapon player;
local _ammoCount = player ammo _myWeapon;
local _hasRevovler = false;
local _nearbyRRPlayers = [];
if (_myWeapon in ["Revolver_DZ","Colt_Python_DZ","Colt_Bull_DZ"]) then {
    _hasRevovler = true;
};
if((speed player <= 1) && _hasRevovler && _canDo && _ammoCount > 0) then {
    {
        if (alive _x && _x != player && (_x distance player <= 10)) then {
            _nearbyRRPlayers set [count _nearbyRRPlayers,name _x];
        };
    } forEach playableUnits;
    if (s_player_russianr_group < 0) then {
        s_player_russianr_group = player addaction[("<t color='#ff0000'>" + format["Play Russian Roulette w/ %1",_nearbyRRPlayers] +"</t>"),"scripts\group_russian_roulette.sqf",_myWeapon,0,false,true,"", ""];
    };
    if (s_player_russianr_solo < 0) then {
        s_player_russianr_solo = player addaction[("<t color='#ff0000'>" + "Play Russian Roulette (solo)" +"</t>"),"scripts\solo_russian_roulette.sqf",_myWeapon,0,false,true,"", ""];
    };
} else {
    player removeAction s_player_russianr_group;
    s_player_russianr_group = -1;
    player removeAction s_player_russianr_solo;
    s_player_russianr_solo = -1;
};
 
// ---------------------------------------RUSSIAN ROULETTE END------------------------------------





