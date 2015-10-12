require "DW\\DW Auto Leveler"

--[[ Auto updater start ]]--
local version = 0.081
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/xDeadweightx/DWMain/master/DW Main.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."DW Main.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
local function TopKekMsg(msg) print("<font color=\"#6699ff\"><b>[Top Kek Series]: Cassiopeia - </b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
  local ServerData = GetWebResult(UPDATE_HOST, "/xDeadweightx/DWMain/master/DW Main.version")
  if ServerData then
    ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
    if ServerVersion then
      if tonumber(version) < ServerVersion then
        TopKekMsg("New version available v"..ServerVersion)
        TopKekMsg("Updating, please don't press F9")
        DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () TopKekMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version") end) end, 3)
      else
        TopKekMsg("Loaded the latest version (v"..ServerVersion..")")
      end
    end
  else
    TopKekMsg("Error downloading version info")
  end
end
--[[ Auto updater end ]]--

function OnTick()
  
end

function OnLoad()
  if not DirectoryExist(LIB_PATH.."DW\\") then CreateDirectory(LIB_PATH.."DW\\") end
  if not FileExist(LIB_PATH.."DW\\DW Auto Leveler.lua") then
    --download
    PrintChat("Download Item")
    return
  end
  
  DW_AutoLevel_Menu()
end

function OnTick()
  AutoLevelTick()
end

function OnUnload()
end
