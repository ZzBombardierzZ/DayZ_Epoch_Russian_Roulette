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
    The order of players is randomized. When it's the player's turn, they will aim the weapon at themselves. 
    For other players, the script instructs the player to aim at the designated target. 
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
systemChat "You can still play this with friends if each friend plays the solo edition on their client as well.";
systemChat "You can move to cancel the game at any time.";

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
    systemChat format ["The chamber the wheel landed on is chamber %1", _chamberSelected + 1];
    player playMove "ActsPercMstpSnonWpstDnon_suicide1B";
    sleep 8.2;
    systemChat format["You pull the trigger."];
    if (_chamberHasBullet == 1) then {
        sleep 0.2;
        player fire _secondary;
        systemChat "Game over... For you.";
        _gameOver = true;
    } else {
        _nul = [objNull, player, rSAY, ["splat",50]] call RE;
        sleep 0.2;
        player switchMove '';
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