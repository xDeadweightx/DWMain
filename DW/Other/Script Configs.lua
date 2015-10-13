local scripts = {}
local manifest = {version=0.01}

function scripts.returnVersion()
  return manifest.version
end

return scripts