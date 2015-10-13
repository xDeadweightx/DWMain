local manifest = {version=0.53, special="Nebelwolfi"}
local q = {p=LIB_PATH, s=SCRIPT_PATH, sel=1}
local folders = {"DW","DW\\AI","DW\\Bots","DW\\Champions","DW\\Other"}

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

local function appendTable(t1, t2)
  t1 = t1 or nil
  t2 = t2 or scripts
  if t1 == nil then PrintChat("Error => Table Concat (missing)") return end
  for k,v in ipairs(t1) do
    t2[#t2+1] = v
  end
end

local function updater()
  local name, bolpath, webpath, call, req = scripts[q.sel].name, scripts[q.sel].bolfolder, scripts[q.sel].webfolder, scripts[q.sel].call, scripts[q.sel].require
  local full_path = q.p .. bolpath .. name .. ".lua"
  if call=="Main" then
    full_path = q.s .. name .. ".lua"
  end
  
  local update_url = "https://"..hosts.host..hosts.path..webpath..name..".lua"..hosts.append
  
  if not FileExist(full_path) then
    -- Download
    PrintChat(name..".lua Not Found => Is Downloading.")
    DelayAction(function()
      DownloadFile(update_url, full_path, function ()
            if call == "Main" then
              PrintChat("Press F9 to reload...")
              return
            end
            
            if req then
              mods[call] = require(bolpath..name)
            end
            
            if call == "ScriptConfigs" then
              local extraTable = mods.ScriptConfigs.add()
              PrintChat(#extraTable)
            end
            
            -- Needs to go in between updaters and downloaders to it doesnt force lag download
            q.sel = q.sel + 1
            if scripts[q.sel] == nil then return end
            updater()
            
        end)
      end,
    1)
  else
    -- Update
    PrintChat(name..".lua Found => Can Update?")
    if req then
      mods[call] = require(bolpath..name)
    end
    
    if mods[call] == nil and req then PrintChat("Require is messed up. Check script configs for: "..call) return end
    
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
          
          DelayAction(
            function()
              DownloadFile(update_url, full_path,
              function ()
                  --package.printInfo("Successfully updated. ("..cversion.." => "..ServerVersion.."), press F9 twice to load the updated version", colors.success)
                  PrintChat(name..".lua successfully updated! No reload required!")
                  
                  if call == "Main" then
                    PrintChat("Press F9 to reload...")
                    return
                  end
                  
                  mods[call] = require(bolpath..name)
                  
                  q.sel = q.sel + 1
                  if scripts[q.sel] == nil then return end
                  updater()
              end)
            end,
          1)
        else
        
        PrintChat(name..".lua is up to date!")
        q.sel = q.sel + 1
        if scripts[q.sel] == nil then return end
        updater()
        
        end
        
      else
        PrintChat("Update Error => Not Found for: "..name)
        
        q.sel = q.sel + 1
        if scripts[q.sel] == nil then return end
        updater()
      end
    end
    
    
    -- Needs to go in between updaters and downloaders to it doesnt force lag download
    --[[
    q.sel = q.sel + 1
    if scripts[q.sel] == nil then return end
    updater()
    ]]--
  end
  
end


function OnLoad()
  
  --Create Folders
  for _,value in ipairs(folders) do
    checkDIR(q.p..value)
  end
  
  updater()
  
  
end
