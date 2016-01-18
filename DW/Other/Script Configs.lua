local scripts = {}
local manifest = {version=0.03}

function scripts.returnVersion()
  return manifest.version
end

function scripts.add()
  local allScripts = {
    {name="DW Auto Level", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="Autolevel", require=true},
    {name="ChampLevels", bolfolder="DW\\Champions\\", webfolder="DW\\Champions\\", call="Champlevels", require=true},
    {name="Chat", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="Chatx", require=true},
    {name="libs", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="DwLibs", require=true},
  }
  return allScripts
end

return scripts