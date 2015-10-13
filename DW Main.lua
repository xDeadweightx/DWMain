local manifest = {version=0.55, special="Nebelwolfi"}
local q = {p=LIB_PATH, s=SCRIPT_PATH, sel=1, update=0}
local folders = {"DW","DW\\AI","DW\\Bots","DW\\Champions","DW\\Other"}

local colors = {color1="#FF851B", color2="#6582C9", color3="#FFFFFF", error="#FF0000", error2="#FF1919", success="#32CD32", warning="#FFFF00"}

local mods = {}

local scripts = {
  {name="DW Main", bolfolder="", webfolder="", call="Main", require=false},
  {name="Script Configs", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="ScriptConfigs", require=true}
}

local hosts = {
  host = "raw.githubusercontent.com",
  path = "/xDeadweightx/DWMain/DWMain/",
  append = "?no-cache="..math.random(1,25000)
}

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

local function start()
  PrintChat(string.format("%s", dwPrint("DW Download / Updates Finished") ))
  if q.update ~= 0 then
    PrintChat(string.format("%s", dwPrint("DW - Press F9 and reload! Thanks.", colors.error2)))
    return
  end
  PrintChat(string.format("%s",dwPrint(" - DW Loading all menus!", colors.color3)))
  
  for _=1,3 do
    PrintChat(string.format("%s",_))
  end
  
  return false
end

local function updater()
  if scripts[q.sel] == nil then start() return false end
  local name, bolpath, webpath, call, req, up = scripts[q.sel].name, scripts[q.sel].bolfolder, scripts[q.sel].webfolder, scripts[q.sel].call, scripts[q.sel].require, scripts[q.sel].update or false
  local full_path = q.p .. bolpath .. name .. ".lua"
  
  if call=="Main" then
    full_path = q.s .. name .. ".lua"
  end
  
  local update_url = "https://"..hosts.host..hosts.path..webpath..name..".lua"..hosts.append
  
  PrintChat(string.format("%s",dwPrint("DW Updater - "..name..".lua")))
  PrintChat(string.format("%s %s", dwPrint(" - DW Checking Update for"), dwPrint(q.sel.." out of "..#scripts.." scripts.", colors.color2)))
  
  if not FileExist(full_path) then
    -- Download
    PrintChat(string.format( "%s", dwPrint(" - DW Error => "..name..".lua is not found", colors.error) ))
    PrintChat(string.format("%s",dwPrint(" - DW Attempting to fix the error!", colors.color3)))
    DelayAction(function()
      DownloadFile(update_url, full_path, function ()
            
            PrintChat(string.format("%s",dwPrint(" - DW Error Resolved => Download Complete.", colors.success)))
            -- Needs to go in between updaters and downloaders to it doesnt force lag download
            -- will auto download no need to reload
            --if scripts[q.sel] == nil then start() return false end
            updater()
            
        end)
      end,
    1)
  else
    -- Update
    if req then
      mods[call] = require(bolpath..name)
    end
    
    if call == "ScriptConfigs" then
      local extraTable = {}
      extraTable = mods[call].add()
      appendTable(extraTable)
    end
    
    local cversion = 0.0
    if call == "Main" then
      cversion = manifest.version
    else
      cversion = mods[call].returnVersion()
    end
    
    --Began update check!
    local ServerData = GetWebResult(hosts.host, hosts.path .. webpath .. name ..".version")
    
    if ServerData then
      local ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
      if ServerVersion then
        
        if tonumber(cversion) < ServerVersion then
          
          PrintChat(string.format("%s",dwPrint(" - DW Warning => Script Version "..name..".lua", colors.warning)))
          
          DelayAction(
            function()
              DownloadFile(update_url, full_path,
              function ()
                  PrintChat(string.format("%s",dwPrint(" - DW Warning Resolved => "..name..".lua updated from "..cversion.." to "..ServerVersion, colors.success)))
                  
                  q.update = q.update + 1
                  q.sel = q.sel + 1
                  --if scripts[q.sel] == nil then start() end
                  updater()
              end)
            end,
          1)
        else
        
        q.sel = q.sel + 1
        --if scripts[q.sel] == nil then start() end
        updater()
        
        end
        
      else
        PrintChat(string.format( "%s", dwPrint(" - DW Error => Update File "..name..".lua is not found. Report this please.", colors.error) ))
        
        q.sel = q.sel + 1
        --if scripts[q.sel] == nil then return end
        updater()
      end
    end
    
    return
    -- Needs to go in between updaters and downloaders to it doesnt force lag download
    --[[
    q.sel = q.sel + 1
    if scripts[q.sel] == nil then return end
    updater()
    ]]--
  end
  return 
end


function OnLoad()
  
  PrintChat(string.format("%s", dwPrint("Welcome to DW Main. Update will start in about 3 seconds.")))
  
  --Create Folders
  for _,value in ipairs(folders) do
    checkDIR(q.p..value)
  end
  
  DelayAction(updater,2)
  
  
  
end
