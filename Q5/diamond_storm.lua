--[[
Q5 - Nickolas Cerrone

Overview:
Aiming to reproduce the spell effect in the provided video,
I have created a new spell that can be added to a TFS server.
It works by defining multiple spell areas that get executed
asyncronously with events. The asyncronous execution of different
combat instances gives the illusion of an animated spell 
area while utilizing the tools provided by TFS.
]]

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
