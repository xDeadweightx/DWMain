local autolevel = {}
local manifest = {version=0.04}

local champ = player.charName

local gmods = {}

function autolevel._init(mods)
  gmods = mods
  gmods["Champlevel"]._init(mods)
  
  Menu = scriptConfig("DW Auto Leveler", champ)
  Menu:addParam("DWAutoLevel", "Auto-Level Spells for "..champ.." key", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
  
end

return autolevel