--[[
	START: Variables
]]--

local manifest = {
	version = 1.0,
	dev 	= "Deadweight"
}

local colors = {
	color1	= "#FF851B",
	color2	= "#6582C9",
	color3	= "#FFFFFF",
	error	= "#FF0000",
	error2	= "#FF1919",
	success	= "#32CD32",
	warning	= "#FFFF00"
}

local mods = {}

local dwSettings = {
	folders = {"DW","DW\\Champions","DW\\Other"},
	reqScripts = { --Force means check and update automactically
		{
			name = "DW Main2",
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
	}
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
    q.v = a
  end)
end

function t2(str)
  string.gsub(str,"version=(.-)}", function(a)
    q.v = a
  end)
end

--[[
	END: Functions
]]--
---------------------------------------------------------------------------------------
--[[
	START: Created Functions
]]--

local scriptLoader = function(scripts)
	for k,v in ipairs(scripts) do
		if scripts.download then
			dwPrint("Download: " .. scripts.name)
		else
			dwPrint("Don't Download: " .. scripts.name)
		end
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
  PrintChat(string.format("%s", dwPrint("Welcome to DW Main. Update will start in about 3 seconds.")))
  
  --Create Folders
  for _,file in ipairs(dwSettings.folders) do
    checkDIR(dwSettings.bolfolder.lpath..file)
  end
  
  DelayAction(scriptLoader, 3, dwSettings.reqScripts)
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