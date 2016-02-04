local scripts = {}
local manifest = {version=0.5}

function scripts.returnVersion()
  return manifest.version
end

function scripts.add()
  local allScripts = {
    {name="DwLibs", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="DwLibs", require=true},
    {name="ChampLevels", bolfolder="DW\\Champions\\", webfolder="DW\\Champions\\", call="Champlevels", require=true},
    {name="DW Auto Level", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="Autolevel", require=true}
  }
  return allScripts
end

return scripts