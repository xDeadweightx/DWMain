-- Start Vars
local autolevelx = {}
local manifest = {version=0.5, script="DWX Auto Leveler"}

local champ = player.charName

local gmods = {}
local skills = nil
local startAL = {levels={}, qOff=0, wOff=0, eOff=0, rOff=0, total=0}
local lib = nil
local lPackets = {}


local Menu = scriptConfig(manifest.script, champ)
-- End Vars

-- ############################################################
-- ############################################################

-- Global Leveler
_G.LevelSpell = function(id)
  local offsets = {
    [_Q] = 0x41,
    [_W] = 0xFC,
    [_E] = 0x64,
    [_R] = 0xAA,
  }
  local p = CLoLPacket(0x153)
  p.vTable = 0xF700D0
  
  p:EncodeF(myHero.networkID)
  p:Encode1(offsets[id])
  for i = 1, 4 do p:Encode1(0xF7) end
  for i = 1, 4 do p:Encode1(0xAF) end
  p:Encode1(0x8F)
  for i = 1, 4 do p:Encode1(0xA5) end
  SendPacket(p)
end
-- End Global Leveler

-- ############################################################
-- ############################################################

-- Primary Functions
local rOffsets = {'Nidalee','Karma','Jayce','Elise'}

function getKeys(table)
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

local function DWX_AutoLevel_Menu()
  PrintChat(string.format("<font color=\"%s\">%s - Version %s Loaded! Enjoy.</font>",gmods["DwLibs"].colors.DWCOLOR, manifest.script, manifest.version))
  skills = gmods["Champlevels"].returnSkills()
  
  for _,v in pairs(rOffsets) do
    if v == champ then
      startAL.rOff = -1
      break
    end
  end
  
  Menu:addParam("DWAutoLevel", "Auto-Level Spells for "..champ.." key", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
  Menu:addParam("DWHumanizerQWE", "Humanizer [Q-W-E] (seconds)", SCRIPT_PARAM_SLICE, 3, 0, 10, -math.log(1)/math.log(10))
  Menu:addParam("DWHumanizerR", "Humanizer [ULT] (seconds)", SCRIPT_PARAM_SLICE, 1, 0, 10, -math.log(1)/math.log(10))
  
  local keys = {}
  
  if type(skills) == 'table' then
    if #skills == 18 then
      startAL.levels = skills
    else
      keys = getKeys(skills)
      if #keys==1 then
        startAL.levels = skills[keys[1]]
      else
        Menu:addParam("DWLevelList", "Select a level order for "..champ, SCRIPT_PARAM_LIST, 0, keys)
      end
    end
  end
  
  if #keys > 1 then
    Menu.DWLevelList = -1
  end
  if #startAL.levels == 0 or #startAL.levels == nil then
    Menu.DWAutoLevel = false
  end
end

local function preformLevel()
  -- Switching from true to false upon changing level
  if not Menu.DWAutoLevel then return end
  
  local qL, wL, eL, rL = player:GetSpellData(_Q).level + startAL.qOff, player:GetSpellData(_W).level + startAL.wOff, player:GetSpellData(_E).level + startAL.eOff, player:GetSpellData(_R).level + startAL.rOff
  local spellSlot = { SPELL_1, SPELL_2, SPELL_3, SPELL_4, }
  local level = { 0, 0, 0, 0 }
  for i = 1, player.level, 1 do
     if i<=18 then
        level[startAL.levels[i]] = level[startAL.levels[i]] + 1
     end
  end
  for i, v in ipairs({qL, wL, eL, rL}) do
      if v < level[i] then LevelSpell(spellSlot[i]) end
  end
end

local function AutoLevel()
    if not VIP_USER then return end
    
    local qL, wL, eL, rL = player:GetSpellData(_Q).level + startAL.qOff, player:GetSpellData(_W).level + startAL.wOff, player:GetSpellData(_E).level + startAL.eOff, player:GetSpellData(_R).level + startAL.rOff
    startAL.total = qL + wL + eL + rL
    if startAL.total < player.level then
      if player.level == 6 or player.level == 11 or player.level == 16 then
        DelayAction(preformLevel, Menu.DWHumanizerR)
      else
        DelayAction(preformLevel, Menu.DWHumanizerQWE)
      end
    end
end
-- End Primary Functions

-- ############################################################
-- ############################################################

-- DWX BoL Hack Loads
function autolevelx._init(mods)
  if mods == nil then return end
  gmods = mods
  DWX_AutoLevel_Menu()
end

function autolevelx._onTick()  
  if GetInGameTimer() < 10 then return end
  
  if #getKeys(skills) > 1 and Menu.DWLevelList ~= -1 then
    startAL.levels = skills[getKeys(skills)[Menu.DWLevelList]]
  end
  --If the auto level is false - stop
  if not Menu.DWAutoLevel then return end
  
  if #startAL.levels == 18 then
    AutoLevel()
  end
end
-- End Hack Loads

-- DWX BoL Draw Load
function autolevelx._onDraw()
  if #startAL.levels ~= 18 then return end
  
  gmods["DwLibs"].stringLevel(startAL.levels, startAL.total)
end
-- End Draw Load

return autolevelx