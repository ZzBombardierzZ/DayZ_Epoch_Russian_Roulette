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
local _players = [];
local _playersInOrder = [];
local _chambers = [0,0,0,0,0,0];
local _currentPlayerIndex = 0;
local _gameOver = false;

// Prepare the gun's chamber based on odds (how many bullets are loaded)
for "_i" from 1 to _odds do {
    _chambers set [_i-1, 1];
};

// Get a list of players within 10 meters to participate in the game
{
    if (_x distance player <= 10) then {
        _players set [count _players, _x];
    };
} forEach playableUnits;

// Randomly set the order of players for the game
while {count _players > 0} do {
    _currentPlayerIndex = floor(random count _players);
    _playersInOrder set [count _playersInOrder, _players select _currentPlayerIndex];
    _players = _players - [_players select _currentPlayerIndex];
};

_currentPlayerIndex = 0;
systemChat format["%1 players are playing Russian Roulette. We will go in this order: %2", count _players, _playersInOrder];

// Game loop: each iteration represents a player's turn
while {count _playersInOrder > 1 && !_gameOver} do {
    local _selectedPlayer = _playersInOrder select _currentPlayerIndex;
    local _chamberSelected = floor(random 6);
    local _chamberHasBullet = _chambers select _chamberSelected;

    sleep 2;

    // If it's the player's turn
    if (_selectedPlayer == player) then {
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
    } else { // If it's another player's turn
        cutText [format["You take your revolver, spin the wheel, and aim it at %1...", name _selectedPlayer], "PLAIN DOWN"];
        systemChat format ["Aim your gun at %1...", name _selectedPlayer];
        waitUntil {sleep 0.1; cursorTarget == _selectedPlayer};
        systemChat format["You pull the trigger."];
        sleep 1;
        if (_chamberHasBullet == 1) then {
            sleep 0.2;
            player fire _secondary;
            systemChat format["%1 lost the game.", name _selectedPlayer];
            _playersInOrder = _playersInOrder - [_selectedPlayer];
            _selectedPlayer setDamage 1.1; // Make sure the player dies
        } else {
            _nul = [objNull, player, rSAY, ["splat",50]] call RE;
            sleep 0.2;
            systemChat format["%1 has survived, for now.", name _selectedPlayer];
        };
    };

    // Update the current player index for the next iteration
    _currentPlayerIndex = _currentPlayerIndex + 1;
    if (_currentPlayerIndex >= count _playersInOrder) then {
        _currentPlayerIndex = 0;
    };
    
    _ammoCount = player ammo _secondary;
    if (_ammoCount == 0 && alive player) then {
        systemChat "You have run out of ammo. Game is over.";
        _gameOver = true;
    };
};

