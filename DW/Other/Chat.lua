local chatx = {}

local manifest = {version=0.01, script="DWX Chat"}
local scrollbox = {w=150, h=50, p=2, color=ARGB(255,1,1,1)}
local settings = {font=12, h=15, offset={x=5, y=20}, color=ARGB(150,1,1,1), drag=false, pos={x=0, y=0}}
local resizeButton = {w=10,h=10,color=ARGB(150,1,1,1), pos={x,y}, resize=false}
local cursor = GetCursorPos()

local function menus()
  Menu = scriptConfig(manifest.script, "dwxchat")
  Menu:addParam("DWXChatDisplay", "Display Chat", SCRIPT_PARAM_ONOFF, true)
  Menu:addParam("DWXChatResize","Resize Chat", SCRIPT_PARAM_ONOFF, false)
  Menu:addParam("DWXLock","Lock Position", SCRIPT_PARAM_ONOFF, false)
  
  Menu:addSubMenu("Chat Size", "DWXChatSize")
    Menu.DWXChatSize:addParam("W", "Chat Width", SCRIPT_PARAM_SLICE, scrollbox.w, 100, WINDOW_W, -math.log(1)/math.log(10))
    Menu.DWXChatSize:addParam("H", "Chat Height", SCRIPT_PARAM_SLICE, scrollbox.h, 50, WINDOW_H, -math.log(1)/math.log(10))
  
  Menu:addSubMenu("Chat Position", "DWXChatPos")
    Menu.DWXChatPos:addParam("X", "Chat Position X",SCRIPT_PARAM_SLICE, settings.offset.x, 0, (WINDOW_W-Menu.DWXChatSize.W), -math.log(1)/math.log(10))
    Menu.DWXChatPos:addParam("Y", "Chat Position Y", SCRIPT_PARAM_SLICE, settings.offset.y, 0, (WINDOW_H-Menu.DWXChatSize.H), -math.log(1)/math.log(10))
 
  --Menu.addSubMenu("Extra Chat Settings","DWXOther")
    
end

function chatx._init(mods)
  if mods == nil then return end
  menus()
  -- Screen Width: WINDOW_W
  -- Screen Height: WINDOW_H
end

function chatx._onDraw()
  if not Menu.DWXChatDisplay then return end
  --Settings update
  scrollbox.w, scrollbox.h = Menu.DWXChatSize.W, Menu.DWXChatSize.H
  settings.offset.x, settings.offset.y = Menu.DWXChatPos.X, Menu.DWXChatPos.Y
  
  if not Menu.DWXLock then
    DrawRectangle(settings.offset.x, settings.offset.y, scrollbox.w, settings.h, settings.color)
  end
  DrawRectangle(settings.offset.x, settings.offset.y+settings.h, scrollbox.w, scrollbox.h, scrollbox.color)
  
  if Menu.DWXChatResize then
    if settings.offset.x+scrollbox.w+resizeButton.w > WINDOW_W then
      -- Left
      resizeButton.pos.x = settings.offset.x-resizeButton.w
    else
      -- Right
      resizeButton.pos.x = settings.offset.x+scrollbox.w
    end
    
    if settings.offset.y+scrollbox.h+settings.h+resizeButton.h > WINDOW_H then
      -- Top
      resizeButton.pos.y = settings.offset.y-resizeButton.h
    else
      -- Bottom
      resizeButton.pos.y = settings.offset.y+scrollbox.h+settings.h
    end
    DrawRectangle(resizeButton.pos.x, resizeButton.pos.y, resizeButton.w, resizeButton.h, resizeButton.color)

  end
  
end

function chatx._onWndMsg(msg, key)
  if msg == nil and key == nil then return end
  
  --Dragging Topbar
  if msg == WM_LBUTTONDOWN and CursorIsUnder(settings.offset.x, settings.offset.y, scrollbox.w, settings.h) and not Menu.DWXLock then
    cursor = GetCursorPos()
    settings.drag = true
    settings.pos.x = math.floor(cursor.x)-settings.offset.x
    settings.pos.y = math.floor(cursor.y)-settings.offset.y
  end
  
  if settings.drag and msg == WM_LBUTTONUP then
    settings.drag = false
    settings.offset.x, settings.offset.y = Menu.DWXChatPos.X, Menu.DWXChatPos.Y
    Menu.DWXChatPos:save()
  end
  
  if settings.drag and msg == WM_MOUSEMOVE then
    cursor = GetCursorPos()
    
    --Dont Display Off Screen X
    if math.floor(cursor.x) - settings.pos.x + scrollbox.w > WINDOW_W then
      Menu.DWXChatPos.X = WINDOW_W-scrollbox.w
    elseif math.floor(cursor.x) - settings.pos.x < 0 then
      Menu.DWXChatPos.X = 0
    else
      Menu.DWXChatPos.X = math.floor(cursor.x)-settings.pos.x
    end
    
    --Dont Display Off Screen X
    if math.floor(cursor.y) - settings.pos.y + scrollbox.h+settings.h > WINDOW_H then
      Menu.DWXChatPos.Y = WINDOW_H-scrollbox.h-settings.h
    elseif math.floor(cursor.y) - settings.pos.y < 0 then
      Menu.DWXChatPos.Y = 0
    else
      Menu.DWXChatPos.Y = math.floor(cursor.y)-settings.pos.y
    end
  end
  --Dragging End
  
  --Resize Start
  if msg == WM_LBUTTONDOWN and CursorIsUnder(resizeButton.pos.x, resizeButton.pos.y, resizeButton.w, resizeButton.h) and Menu.DWXChatResize then
    cursor = GetCursorPos()
    settings.pos.x = math.floor(cursor.x)-resizeButton.pos.x
    settings.pos.y = math.floor(cursor.y)-resizeButton.pos.y
    resizeButton.resize = true
  end
  
  if resizeButton.resize and msg == WM_LBUTTONUP then
    resizeButton.resize = false
    --settings.offset.x, settings.offset.y = Menu.DWXChatPos.X, Menu.DWXChatPos.Y
    Menu.DWXChatSize:save()
  end
  
  if resizeButton.resize and msg == WM_MOUSEMOVE then
    cursor = GetCursorPos()
    if math.floor(cursor.x) - settings.offset.x - settings.pos.x < 100 then
      Menu.DWXChatSize.W = 100
    else
      Menu.DWXChatSize.W = math.floor(cursor.x) - settings.offset.x - settings.pos.x
    end
    
    if math.floor(cursor.y) - settings.offset.y - settings.pos.y < 50 then
      Menu.DWXChatSize.H = 50
    else
      Menu.DWXChatSize.H = math.floor(cursor.y) - settings.offset.y - settings.pos.y - resizeButton.h
    end
    
    
  end
  --Resize End
  
end

return chatx