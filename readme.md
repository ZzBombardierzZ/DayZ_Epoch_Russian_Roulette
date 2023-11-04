# DayZ Epoch - Russian Roulette - Rewritten by Bomb
Originally made by Vampire and based off of a script by Grafzahl on OpenDayz.net. Original Script: https://web.archive.org/web/20160629092026/https://opendayz.net/threads/release-vampires-russian-roulette.15196/

This was updated and rewritten by Bomb for TLF servers, who requested I update the script. I have decided to release it to the public for anyone who wants to use it. If you find any bugs, please let me know and I will fix them. You can find me on Discord as Bomb99.


## Bomb's Changes:
* Added a group gameplay option to allow players to play with nearby friends.
* Completely rewrote the entire script.
* Fixed some bugs.

# Demo Video
### You should watch me! - https://youtu.be/CkIUTXGNyUU

## Features:
* Players can play Russian Roulette solo or with nearby players.
* The script will automatically detect if the player has a revolver and ammo.
* The script will load the revolver ammo into random chambers of the revolver.
* If playing multiplayer mode, the script will shuffle the players playing and begin a "turn" system. This will go in the same order until players die or there is only one player left.
* Whether you're playing single player or multiplayer, at each "turn" the script will spin the revolver's cylinder and if it lands on a loaded chamber, the selected player will die when the gun fires.
* The game ends when there the player who started the game dies or there is no ammo left.

## Install instructions:
1. Download this repository.
2. Copy the two SQF files from the scripts folder into a scripts folder in your mission root, ie `DayZ_Epoch_11.Chernarus` folder so the path looks like this: `mpmissions\your_instance\scripts\`
3. In `fn_selfActions.sqf`, find the following:
~~~sqf
if (!isNull _nearLight) then {
    if (_nearLight distance player < 4) then {
        _canPickLight = isNull (_nearLight getVariable ["owner",objNull]);
    };
};
~~~

and below it add:
~~~sqf
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
~~~

4. In your `variables.sqf` file

Find `dayz_resetSelfActions = {` and paste this below it:
~~~sqf
s_player_russianr_group = -1;
s_player_russianr_solo = -1;
~~~

5. You'll need to likely update your Battleye scripts.txt file if you are using Battleye. I will not be covering that here.

* That's it for the install.

## Configuration
* This script assumes you are using revolvers with 6 bullet chambers. If you wish to change the odds of the gun firing, you can change `local _odds = _ammoCount;` in either file to whatever you want. For example, if you want the gun to fire 1/3 of the time, change it to `local _odds = 2;` (2 out of 6 chambers will fire).
* You can add more revolvers to the `_myWeapon in ["Revolver_DZ","Colt_Python_DZ","Colt_Bull_DZ"]` but they need to have 6 bullet chambers as the script assumes that.