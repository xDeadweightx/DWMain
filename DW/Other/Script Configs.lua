local scripts = {}
local manifest = {version=0.5}

function scripts.returnVersion()
  return manifest.version
end

function scripts.add()
  local allScripts = {
    ["force"] = {
    	{name="DwLibs", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="DwLibs", check=true}
    },
    ["Dw Autolevel"] = {
    	{name="ChampLevels", bolfolder="DW\\Champions\\", webfolder="DW\\Champions\\", call="Champlevels", check=true},
    	{name="DW Auto Level", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="Autolevel", check=true}
    }
  }
  return allScripts
end

return scripts