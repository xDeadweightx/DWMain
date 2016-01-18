local libs = {}
local manifest = {version=0.01}

function libs.returnVersion()
  return manifest.version
end

function libs.Set(list)
  local set = {}
  for _, l in ipairs(list) do
    set[l] = true
  end
  return set
end

function libs.append(list, val)
  local l = list
  l[#list] = val
  return l
end

function libs.toHex(int)
  return "0x"..string.format("%02X ",int)
end

return libs