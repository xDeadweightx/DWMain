local DwLibs = {}
local manifest = {version=0.01}

DwLibs.colors = {
  DWCOLOR = "#FF851B",
  YELLOW = "#FFFF00",
  GREEN = "#00FF00",
  LIGHT_BLUE = "#00FFFF",
  BLUE = "#0000FF",
  MAROON = "#800000",
  ORANGE = "#FFA500",
  WHITE = "#FFFFFF",
  RED = "#FF0000"
}

local SkillEnum = {
  [1] = "Q",
  [2] = "W",
  [3] = "E",
  [4] = "R"
}

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

function DwLibs.stringLevel(arr, skillTotal)
  local i, playerLevel, color = 1, player.level
  for i = 1, #arr, 1 do
    if i < skillTotal or skillTotal == 18 then
      color = ARGB(255,0,255,0)
    elseif i == skillTotal then
      color = ARGB(255,0,0,255)
    else
      color = ARGB(255,255,0,0)
    end
    DrawText(SkillEnum[arr[i]], 15, 10, 12 * i, color)
  end
end

return DwLibs