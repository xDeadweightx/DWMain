local scripts = {}
local manifest = {version=0.03}

function scripts.returnVersion()
  return manifest.version
end

function scripts.add()
  local allScripts = {
    {name="DW Auto Level", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="Autolevel", require=true},
    {name="ChampLevels", bolfolder="DW\\Champions\\", webfolder="DW\\Champions\\", call="Champlevel", require=true}
  }
  return allScripts
end

function scripts._init(mods)
  
end

return scripts