local manifest = {version=0.03, special="Nebelwolfi"}
local q = {p=LIB_PATH, s=SCRIPT_PATH}
local folders = {"DW","DW\\AI","DW\\Bots","DW\\Champions","DW\\Other"}

local mods = {}

local hosts = {
  host = "raw.githubusercontent.com",
  path = "/xDeadweightx/DWMain/DWMain/",
  append = "?no-cache="..math.random(1,25000)
}

local function checkDIR(name)
  if not DirectoryExist(name) then CreateDirectory(name) end
end

local function forceDownload(path,name,pathLoc)
  name = name..".lua"
  if not FileExist(path..name) then
    PrintChat("Downloading script: "..path..name)
    local UPDATE_URL = "https://"..hosts.host..hosts.path..pathLoc..name..hosts.append
    DownloadFile(UPDATE_URL, path..name, function () PrintChat("Successfully Downloaded: "..name) end)
  end
end

function OnLoad()
  
  for _,value in ipairs(folders) do
    checkDIR(q.p..value)
  end
  
  forceDownload(q.p.."DW\\Other\\","DW Updater","DW/Other/")
  
  
  mods["Updater"] = require "DW\\Other\\DW Updater"
  mods.Updater.printInfo("A huge thanks to "..manifest.special.." for all his help and time. I cannot list the amount of things he helped and taught me. Again I would love to thank him. So this is for you "..manifest.special)
  
  --Check Main
  mods.Updater.updateScript("DW Main", q.s, "", manifest.version)
  
  --Checks Updater
  mods.Updater.updateScript("DW Updater", q.p.."DW\\Other\\", "DW\\Other\\", mods.Updater.returnVersion())
  
  --Check Scripts
  forceDownload(q.p.."DW\\Other\\","Script Configs","DW/Other/")
  mods["ScriptConfigs"] = require "DW\\Other\\Script Configs"
  mods.Updater.updateScript("Script Configs", q.p.."DW\\Other\\", "DW\\Other\\", mods.ScriptConfigs.returnVersion())
  
end
