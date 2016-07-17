--[[
  START: Variables
]]--

local manifest = {version=1.0, dev = "Deadweight"}

local colors = {
  color1  = "#FF851B",
  color2  = "#6582C9",
  color3  = "#FFFFFF",
  error = "#FF0000",
  error2  = "#FF1919",
  success = "#32CD32",
  warning = "#FFFF00"
}

local mods = {}

local dwSettings = {
  folders = {"DW","DW\\Champions","DW\\Other"},
  reqScripts = { --Force means check and update automactically
    {
      name = "DW Main",
      bolfolder = "",
      webfolder = "",
      call = "Main",
      check = true
    },
      {
      name = "Script Configs",
      bolfolder = "DW\\Other\\",
      webfolder = "DW\\Other\\",
      call = "ScriptConfigs",
      check = true
    }
  },
  addedScripts = {},
  hosts = {
    host = "raw.githubusercontent.com",
    path = "/xDeadweightx/DWMain/DWMain/",
    append = "?no-cache="..math.random(1,25000)
  },
  bolSettings = {
    lpath = LIB_PATH,
    spath = SCRIPT_PATH,
    count = 1
  },
}

--[[
  END: Variables
]]--
---------------------------------------------------------------------------------------
--[[
  START: Functions
]]--

local function checkDIR(name)
  if not DirectoryExist(name) then CreateDirectory(name) end
end

local function dwPrint(str, color)
  color = color or colors.color1
  str = str or " "
   PrintChat(string.format("%s", "<font color=\""..color.."\">"..str.."</font>"))
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
    dwSettings.v = a
  end)
end

function t2(str)
  string.gsub(str,"version=(.-)}", function(a)
    dwSettings.v = a
  end)
end

local scriptLoader
--[[
  END: Functions
]]--
---------------------------------------------------------------------------------------
--[[
  START: Created Functions
]]--

scriptLoader = function(scripts)
  --dwPrint(#scripts)
  for k,v in ipairs(scripts) do
    if v.check then
      scriptDownload(scriptCheck(v))
    end
  end

  if dwSettings.reqReload then
    dwPrint("A reload is required!")
  else
    dwPrint("DW Packages have been added. Please select the ones you want to download/update.")
  end

end

scriptCheck = function(file) 
  local path =  dwSettings.bolSettings.spath .. file.bolfolder .. file.name .. ".lua"
  local update_url = "https://" .. dwSettings.hosts.host .. dwSettings.hosts.path .. file.webfolder .. file.name .. ".lua" .. dwSettings.hosts.append
  local downloadType = 1 -- Autoset to download
  local msg = " - DW ERROR: " .. file.name .. ".lua not found. Attempting to Download."
  local color = colors.error

  if file.call ~= "Main" then
      path =  dwSettings.bolSettings.lpath .. file.bolfolder .. file.name .. ".lua"
  end

  if FileExist(path) then
    local ServerData = GetWebResult(dwSettings.hosts.host, dwSettings.hosts.path .. file.webfolder .. file.name ..".version")
      if ServerData then
        local ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
        if ServerVersion then
          t(ReadFile(path))
          if type(tonumber(dwSettings.v)) ~= "number" and not tonumber(dwSettings.v) then
            t2(ReadFile(path))
          end
          
          local  cversion = type(tonumber(dwSettings.v)) == "number" and tonumber(dwSettings.v) or nil
          
          if file.call == "Main" then cversion = manifest.version end

          if cversion < ServerVersion then
            downloadType = 3 --Update
            msg = " - DW WARNING: " .. file.name .. ".lua Version. Attempting to Update => " .. cversion .. " to " .. ServerVersion .. "."
            color = colors.warning
          else
            downloadType = 5 -- File Update to date
            msg = " - DW GOODIES: " .. file.name .. ".lua Version Up to Date => " .. cversion .. "."
            color = colors.success
          end
      else -- ServerVersion
        downloadType = 4 -- Error Server Version Found File
        local msg = " - DW ERROR: " .. file.name .. ".lua Server Version not found. Post in Forums."
        local color = colors.error2
      end
    else -- ServerData
      downloadType = 2 -- Error: No Server Connection
      local msg = " - DW ERROR: Server Connection Issue. Post in Forums"
      local color = colors.error2
    end
  end
  return {dlt = downloadType, p = path, url = update_url, xcolor = color, xmsg = msg, xfile = file}

end

scriptDownload = function(data)
  dwPrint(data.xmsg, data.xcolor)
  if data.dlt == 1 or data.dlt == 3 then
    DelayAction(function()
        DownloadFile(data.url, data.p, function ()
            if data.dlt == 1 then
              dwPrint("File " .. data.xfile.name .. "has been downloaded." )
            else
              dwPrint("File " .. data.xfile.name .. "has been updated." )
            end

            if data.xfile.call == "Main" then
              dwSettings.reqReload = true
            end

          end)
        end,
      .1)
  end
end

--[[
  END: Created Functions
]]--
---------------------------------------------------------------------------------------
--[[
  START: BoL Functions
]]--

function OnLoad()
  dwPrint("Welcome to DW Main. Update will start in about 3 seconds.")
  
  --Create Folders
  for _,file in ipairs(dwSettings.folders) do
    checkDIR(dwSettings.bolSettings.lpath..file)
  end
  
  DelayAction(function()
    scriptLoader(dwSettings.reqScripts)
  end, 3)
  
end

function OnTick()
end

function OnDraw()
end

function OnUnload()
end

function OnWndMsg(msg,key)
end

function OnSendPacket(p)
end

--[[
  END: BoL Functions
]]--
---------------------------------------------------------------------------------------