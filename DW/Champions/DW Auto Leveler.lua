local autoleveler = {}
local manifest = {version=0.01}

function autoleveler.updateChecker()
  return manifest.version
end

function autoleveler.requiredScripts()
end

return autoleveler