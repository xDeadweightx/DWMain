<<<<<<< HEAD
local package = {}
local manifest = {version=0.01}


local colors = {color1="#FF851B", color2="#6582C9", color3="#FFFFFF", error="#FF0000", error2="#FF1919", success="#32CD32"}

local hosts = {
  host = "raw.githubusercontent.com",
  path = "/xDeadweightx/DWMain/DWMain/",
  append = "?no-cache="..math.random(1,25000)
}

local function printInfo(info, color)
  color = color or colors.color1
  info = info or " "
  PrintChat(string.format("<font color=\"%s\">%s</font>", color, info))
end

local function forceDownload(path, name)
  name = name..".lua"
  if not FileExist(path..name) then
    local UPDATE_URL = "https://"..hosts.host..hosts.path..name..hosts.append
    DownloadFile(UPDATE_URL, path..name, function () PrintChat("Successfully Downloaded: "..name) end)
  end
end

function package.updateScript(script, scriptFolder, webFolder, cversion)
  script = script or nil
  scriptFolder = scriptFolder or nil
  webFolder = webFolder or nil
  cversion = cversion or nil
  
  if script == nil or scriptFolder == nil or webFolder == nil or cversion == nil then printInfo("Update Error => Formatting", colors.error) return end
  
  local ServerData = GetWebResult(hosts.host, hosts.path .. webFolder .. script ..".version")
  if ServerData then
    ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
    if ServerVersion then
      if tonumber(cversion) < ServerVersion then
        printInfo("Needs to update!")
      else
        printInfo("Up to date!")
      end
    end
  else
    printInfo("Update Error => Server Connection", colors.error2)
  end
  --[[
  local UPDATE_URL = "https://"..hosts.host..hosts.path..name..hosts.append
  local ServerData = GetWebResult(UPDATE_HOST, "/xDeadweightx/DWMain/DWMain/DW Main.version")
  
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
  ]]--
end

return package
=======
local try()
end
>>>>>>> origin/DWMain
