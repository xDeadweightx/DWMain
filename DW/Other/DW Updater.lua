local package = {}
local manifest = {version=0.03}

local colors = {color1="#FF851B", color2="#6582C9", color3="#FFFFFF", error="#FF0000", error2="#FF1919", success="#32CD32"}

local hosts = {
  host = "raw.githubusercontent.com",
  path = "/xDeadweightx/DWMain/DWMain/",
  append = "?no-cache="..math.random(1,25000)
}

function package.returnVersion()
  return manifest.version
end

function package.printInfo(info, color)
  color = color or colors.color1
  info = info or " "
  PrintChat(string.format("<font color=\"%s\">%s</font>", color, info))
end

local function forceDownload(path, name, addToPath)
  name = name..".lua"
  if not FileExist(path..name) then
    local UPDATE_URL = "https://"..hosts.host..hosts.path..addToPath..name..hosts.append
    PrintChat(path..name)
    DownloadFile(UPDATE_URL, path..name, function () package.printInfo("Successfully Downloaded: "..name, colors.success) end)
    return false
  end
  return true
end

function package.updateScript(script, scriptFolder, webFolder, cversion)
  script = script or nil
  scriptFolder = scriptFolder or nil
  webFolder = webFolder or nil
  cversion = cversion or nil
  
  if script == nil or scriptFolder == nil or webFolder == nil or cversion == nil then printInfo("Update Error => Formatting", colors.error) return end
  
  if not forceDownload(scriptFolder, script, webFolder) then return end
  
  local ServerData = GetWebResult(hosts.host, hosts.path .. webFolder .. script ..".version")
  if ServerData then
    local ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
    if ServerVersion then
      if tonumber(cversion) < ServerVersion then
        package.printInfo("Needs to update!", colors.color3)
        package.printInfo("Updating, please don't press F9", colors.color2)
        
        local file_path = scriptFolder..script..".lua"
        
        local UPDATE_URL = "https://"..hosts.host..hosts.path..webFolder..script..".lua"..hosts.append
        
        DelayAction(function() DownloadFile(UPDATE_URL, file_path, function () package.printInfo("Successfully updated. ("..cversion.." => "..ServerVersion.."), press F9 twice to load the updated version", colors.success) end) end, 1)
      else
        package.printInfo("Loaded the latest version of: "..script, colors.success)
      end
    end
  else
    package.printInfo("Update Error => Server Connection - Try reloading", colors.error2)
  end
end

return package