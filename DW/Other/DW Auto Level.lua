local autolevel = {}
local manifest = {version=0.01}

function autolevel.returnVersion()
  return manifest.version
end

function autolevel._init()
  Menu:addParam("DWAutoLevel", "Auto-Level Spells for "..player.charName.." key", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
end

return autolevel