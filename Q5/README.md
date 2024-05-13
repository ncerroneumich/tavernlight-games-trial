# Q5 - Nickolas Cerrone

<h3>Video Demo</h3>

https://github.com/ncerroneumich/tavernlight-games-trial/assets/97428535/bdc02df0-ae57-4b0a-83ab-80f16f317a0d

<h3>Overview</h3>

The process for implementing this spell was pretty straightforward. I began by learning how other spells were implemented on the server side. Once I had a decent understanding, I created my own spell as shown above. It is different than most others in the game as it executes multiple combat instances whereas a normal Tibia spell would just execute a single instance. Executing these instances with increasing delays allows us to achieve a spell with a dynamically changing area.


<h3>Spell declaration<h3>

```xml
<instant group="attack" spellid="555" name="Diamond Storm" words="frigo" level="100" mana="1" premium="0" selftarget="1" cooldown="1" groupcooldown="1" needlearn="0" script="attack/diamond_storm.lua">
    <vocation name="Sorcerer" />
    <vocation name="Druid" />
    <vocation name="Knight" />
    <vocation name="Paladin" />
</instant>
```

<h3>Spell Script</h3>

```Lua
-- Area tiles defined with 2 as the player's tile and 1 as effect tiles
local AREAS_DIAMOND = {
	{
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 1, 0, 0, 0, 0, 0},
		{1, 0, 0, 2, 0, 0, 1},
		{0, 1, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0}
	},
	{
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 1, 0},
		{0, 0, 0, 2, 0, 0, 0},
		{0, 0, 0, 1, 0, 1, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	},
	{
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 2, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	},
	{
		{0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 2, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	}
}

-- Used to hold and iterate through multiple combat instances
local combat_instances = {}

-- The amount of time between combat instance executions
local instance_interval = 250

--[[	
Each area has a defined combat instance to enable the
animation effect. We are repeating the sequence 3 times
to match the effect produced in the given video.
]]
local num_combat_instances = #AREAS_DIAMOND * 3
for i = 1, num_combat_instances do
	-- Setup combat instances
	combat_instances[i] = Combat()
	combat_instances[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	combat_instances[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
	local area_index = (i - 1) % #AREAS_DIAMOND + 1 -- Creates a valid index for the AREAS_DIAMOND table
	local combat_area = createCombatArea(AREAS_DIAMOND[area_index])
	combat_instances[i]:setArea(combat_area)

	-- Define the spell's damage callback function
	function onGetFormulaValues(player, level, magicLevel)
		local min = (level * 5) + (magicLevel * 5) + 100
		local max = (level * 5) + (magicLevel * 11) + 500
		return -min, -max
	end
	
	-- Register the damage callback function
	combat_instances[i]:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
end

function onCastSpell(creature, variant)
	-- Iterate through combat instances and set up asyncronous execution with delays
	for i = 1, #combat_instances do
		local delay = instance_interval * (i - 1)
		-- Utilizing anonymous functions to execute combat instances on triggered events
		addEvent(function()
			combat_instances[i]:execute(creature, variant)
		end, delay)
	end

	-- Return true to indicate the spell casting sequence has begun
	return true
end
```
    
