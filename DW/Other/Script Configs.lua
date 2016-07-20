local scripts = {}
local manifest = {version=0.55}
local allScripts = {
    	["DW Autoleveler"] = {
    		{name="ChampLevels", bolfolder="DW\\Champions\\", webfolder="DW\\Champions\\", call="Champlevels", desc = "Champs Config File"},
    		{name="DW Auto Level", bolfolder="DW\\Other\\", webfolder="DW\\Other\\", call="Autolevel", desc = "Auto Level Champs"},
    		check = false,
    		menu = "DwAutoLeveler"
    	}
  }
local gmods = {}
local fixedTable = {}
local Menu = scriptConfig("DW Scripts", "dwScriptSettings")

function scripts.returnVersion()
  return manifest.version
end

function scripts.add()
  return allScripts
end

function scripts._init(mods)
	if mods == nil then return end
  	gmods = mods

	Menu:addParam("info", "Press '=' to download scripts.", SCRIPT_PARAM_INFO, "")
	for k,v in pairs(allScripts) do
		local m = v.menu
		Menu:addSubMenu(k .. "Package Info", m)
		Menu:addParam("AutoDownloader", "Auto Download Packages", SCRIPT_PARAM_ONOFF, false)
		Menu:addParam(m .. "Downloader", k .. " Package Download", SCRIPT_PARAM_ONOFF, false)

		if m == "DwAutoLeveler" then
			m = Menu.DwAutoLeveler
		end
		
		if #v > 0 then
			for i,s in ipairs(v) do
				m:addParam("info", "Script: " .. s.name, SCRIPT_PARAM_INFO, "")
				m:addParam("info", "Desc: " .. s.desc, SCRIPT_PARAM_INFO, "")
				m:addParam("info", " ", SCRIPT_PARAM_INFO, "")
			end
		end
		
	end
end

function scripts.updateScriptsDownloads()
	if Menu.DwAutoLevelerDownloader then
		allScripts["DW Autoleveler"].check = true		
	else
		allScripts["DW Autoleveler"].check = false
	end

	for k,v in pairs(allScripts) do
		if v.check then
			for i,s in ipairs(v) do
				s.check = v.check
				fixedTable[#fixedTable + 1] = s
			end
		end
	end
	return fixedTable
end

return scripts