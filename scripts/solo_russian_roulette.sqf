/*                    Original comment here                     */
//////////////////////////////////////////////////////////////////
// Russian Roulette (AKA Lets Gamble our loot!) v1.1 by Vampire //
// Many thanks to Headshot Suicide by Grafzahl on OpenDayz.net ///
// It made a great code base to start with. //////////////////////
//////////////////////////////////////////////////////////////////
/*               End of original comment here                   */



//////////////////////////////////////////////////////////////////
// October 28, 2023
// Almost completely rewritten by Bomb (bomb99 on Discord).
// Script update/rewrite requested by TLF Servers.
// Shared with the community for anyone to use.
//////////////////////////////////////////////////////////////////


/*
    Script: Russian Roulette Simulation for Arma 2

    This script allows the player and nearby friendly units to participate in a simulated game of Russian Roulette. 
    This is the solo edition, but each client can run the script at the same time to play "together". 
    Whether the gun fires is determined by the number of bullets (compared to empty chambers) and a randomized choice of chamber.
    
*/


// Initialize essential variables
local _secondary = currentWeapon player;
local _ammoCount = player ammo _secondary;
local _odds = _ammoCount; //Change this if you want to change the odds
local _chambers = [0,0,0,0,0,0];
local _gameOver = false;
local _startPos = getPosATL player;

// Prepare the gun's chamber based on odds (how many bullets are loaded)
for "_i" from 1 to _odds do {
    _chambers set [_i-1, 1];
};

systemChat format["Starting Russian Roulette - solo edition."];
sleep 0.5;
systemChat "You can still play this with friends if each friend plays the solo edition on their client as well.";
sleep 0.25;
systemChat "You can move to cancel the game at any time.";
sleep 0.5;
systemChat format ["You load %1 bullets into random chambers and spin the wheel...", _odds];

// Game loop: each iteration represents a player's turn
while {!_gameOver} do {
    local _chamberSelected = floor(random 6);
    local _chamberHasBullet = _chambers select _chamberSelected;

    sleep 2;

    if (_startPos distance getPosATL player > 3) then {
        systemChat "Game cancelled. You have moved too far from the starting position.";
        _gameOver = true;
        if (true) exitWith {};
    };

    cutText [format["You take your revolver, spin the wheel, and aim it to your temple..."], "PLAIN DOWN"];
    systemChat format ["The wheel lands on chamber %1", _chamberSelected + 1];
    player playMove "ActsPercMstpSnonWpstDnon_suicide1B";
    sleep 8.2;
    systemChat format["You pull the trigger."];
    if (_chamberHasBullet == 1) then {
        sleep 0.2;
        player fire _secondary;
        player setDamage 1.1;
        systemChat "Game over... For you.";
        _gameOver = true;
    } else {
        _nul = [objNull, player, rSAY, ["splat",50]] call RE;
        sleep 0.2;
        [objNull, player, rswitchmove,""] call RE;
        player playActionNow 'stop';
    };
    
    _ammoCount = player ammo _secondary;
    if (_ammoCount == 0 && alive player) then {
        systemChat "You have run out of ammo. Game is over.";
        _gameOver = true;
    };
    if (_startPos distance getPosATL player > 3) then {
        systemChat "Game cancelled. You have moved too far from the starting position.";
        _gameOver = true;
    };
};