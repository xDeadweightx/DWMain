local DwLibs = {}
local manifest = {version=0.01}

function DwLibs.returnVersion()
  return manifest.version
end

function DwLibs.toSet(list)
  local set = {}
  for _, l in ipairs(list) do
    set[l] = true
  end
  return set
end

function DwLibs.append(list, val)
  local l = list
  l[#list+1] = val
  return l
end

function DwLibs.toHex(int)
  return "0x"..string.format("%02X ",int)
end

function DwLibs.getKeys(table)
  local keys = {}
  for key in pairs(table) do
    if #keys == 0 then
      keys[1] = key
    else
      keys[#keys+1] = key
    end
  end  
  return keys
end

return DwLibs