local manifest = {version=0.01}
local q = {p=LIB_PATH}
local folders = {"DW","DW\\AI","DW\\Bots","DW\\Champions","DW\\Other"}

local hosts = {
  host = "raw.githubusercontent.com",
  path = "/xDeadweightx/DWMain/DWMain/DW/Other/",
  append = "?no-cache="..math.random(1,25000)
}

local function checkDIR(name)
  if not DirectoryExist(name) then CreateDirectory(name) end
end

local function forceDownload(path,name)
  name = name..".lua"
  if not FileExist(path..name) then
    local UPDATE_URL = "https://"..hosts.host..hosts.path..name..hosts.append
    DownloadFile(UPDATE_URL, path..name, function () PrintChat("Successfully Downloaded: "..name) end)
  end
end

function OnLoad()

  for _,value in ipairs(folders) do
    checkDIR(q.p..value)
  end
  
  forceDownload(q.p.."DW\\Others","DW Updater")
  
  --mods = require "DW\\Other\\DW Updater"
  
  --mods.updateScript("DW Main", "", "", manifest.version)
  
end
