-- Vars Start
local manifest = {version=0.75, special="Nebelwolfi"}
local colors = {color1="#FF851B", color2="#6582C9", color3="#FFFFFF", error="#FF0000", error2="#FF1919", success="#32CD32", warning="#FFFF00"}

local mods = {}
local scriptLoader
local folders = {"DW","DW\\AI","DW\\Bots","DW\\Champions","DW\\Other"}
local q = {p=LIB_PATH, s=SCRIPT_PATH, sel=1, update=0, v}

local scripts = {
  {name="DW Main", bolfolder="", webfolder="", call="Main", require=false},
  {name="Script Configs", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="ScriptConfigs", require=true}
}

local hosts = {
  host = "raw.githubusercontent.com",
  path = "/xDeadweightx/DWMain/DWMain/",
  append = "?no-cache="..math.random(1,25000)
}
--Vars End

-- ############################################################
-- ############################################################

-- Simple Functions
local function checkDIR(name)
  if not DirectoryExist(name) then CreateDirectory(name) end
end

local function dwPrint(str, color)
  color = color or colors.color1
  str = str or " "
  return "<font color=\""..color.."\">"..str.."</font>"
end

local function appendTable(t1, t2)
  t1 = t1 or nil
  t2 = t2 or scripts
  if t1 == nil then PrintChat("Error => Table Concat (missing)") return end
  for k,v in ipairs(t1) do
    t2[#t2+1] = v
  end
end

function t(str)
  string.gsub(str,"version=(.-),", function(a)
    q.v = a
  end)
end

function t2(str)
  string.gsub(str,"version=(.-)}", function(a)
    q.v = a
  end)
end
-- End Simple Functions

-- ############################################################
-- ############################################################

-- Real Start
local function dwStart()
  for _=1, #scripts do
    local v = scripts[_]
    if v.require then
      mods[v.call]._init(mods)
      --PrintChat(string.format("%s",mods[v.call].returnVersion()))
    end
  end
end
-- End Start

-- ############################################################
-- ############################################################

-- Check Scripts Function
scriptLoader = function()
  if scripts[q.sel] ~= nil then
    --PrintChat(string.format("%s",scripts[q.sel].name))
    local name, bolpath, webpath, call, req = scripts[q.sel].name, scripts[q.sel].bolfolder, scripts[q.sel].webfolder, scripts[q.sel].call, scripts[q.sel].require
    
    local full_path = q.p .. bolpath .. name .. ".lua"
    if call=="Main" then
      full_path = q.s .. name .. ".lua"
    end
    local update_url = "https://"..hosts.host..hosts.path..webpath..name..".lua"..hosts.append
    
    PrintChat(string.format("%s",dwPrint("DW Updater - "..name..".lua")))
    PrintChat(string.format("%s %s", dwPrint(" - DW Checking Update for"), dwPrint(q.sel.." out of "..#scripts.." scripts.", colors.color2)))
    
    if not FileExist(full_path) then
    
      PrintChat(string.format( "%s", dwPrint(" - DW Error => "..name..".lua is not found", colors.error) ))
      PrintChat(string.format("%s",dwPrint(" - DW Attempting to fix the error!", colors.color3)))
      
      DelayAction(function()
        DownloadFile(update_url, full_path, function ()
            PrintChat(string.format("%s",dwPrint(" - DW Error Resolved => Download Complete.", colors.success)))
            DelayAction(scriptLoader,.5)
          end)
        end,
      .1)
      
    else
      
      local ServerData = GetWebResult(hosts.host, hosts.path .. webpath .. name ..".version")
      if ServerData then
        local ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
        if ServerVersion then
          local v = t(ReadFile(full_path)) or t2(ReadFile(full_path))
          local cversion = type(tonumber(q.v)) == "number" and tonumber(q.v) or nil
          
          if call == "Main" then cversion = manifest.version end
          
          if cversion < ServerVersion then
            PrintChat(string.format("%s",dwPrint(" - DW Warning => Script Version "..name..".lua", colors.warning)))
            DelayAction(
              function()
                DownloadFile(update_url, full_path,
                function ()
                    PrintChat(string.format("%s",dwPrint(" - DW Warning Resolved => "..name..".lua updated from "..cversion.." to "..ServerVersion, colors.success)))
                    DelayAction(scriptLoader,.5)
                end)
              end,
            .1)
          else
          
            PrintChat(string.format("%s",dwPrint(" - DW Recents => "..name..".lua is up to date.", colors.success)))
            if req then
              mods[call] = require(bolpath..name)
            end
            if call == "ScriptConfigs" then
              local extraTable = {}
              extraTable = mods[call].add()
              appendTable(extraTable)
            end
            
            q.sel = q.sel + 1
            DelayAction(scriptLoader,.5)
          end
          
        else
          PrintChat(string.format( "%s", dwPrint(" - DW Error => Update File "..name..".lua is not found. Report this please.", colors.error) ))
          q.sel = q.sel + 1
          DelayAction(scriptLoader,.5)
        end
      end
      
    end
   
  else
    
    dwStart()
    
  end
  
end
-- End Check Scripts Function

-- ############################################################
-- ############################################################

-- Menu Init
local function loadMenus()
  
end
-- End Menu Init

-- ############################################################
-- ############################################################

-- BoL Normal Functions
function OnLoad()
  PrintChat(string.format("%s", dwPrint("Welcome to DW Main. Update will start in about 3 seconds.")))
  
  --Create Folders
  for _,value in ipairs(folders) do
    checkDIR(q.p..value)
  end
  
  DelayAction(scriptLoader,3)
  
  --loadMenus()
  
end
--End BoL Normal Functions
