--##### 

LazyToggle = CreateFrame("Button","LazyToggle",UIParent) -- Event frame
LazyToggle.Dashboard = CreateFrame("Frame","LTDF",UIParent) -- Dashboard Frame

LazyToggle:RegisterEvent("ADDON_LOADED") -- Register event when addon is loaded

-- Version
LazyToggle_VERSION = "0.1" -- Edit the addon version here as you go
LazyToggle_VERSION_MSG = "|cFF00FF00"..LazyToggle_VERSION.."|r"

---
local LazyToggle_DashboardOpen			= false;
local LazyToggle_ChatFrameHooks		= { };

local LazyToggle_DNDMode				= 1;
local LazyToggle_AFKMode			= 1;

-- UI Dashboard tooltip
function LazyToggle_ShowDashboardToolTip(object, message)
	GameTooltip:SetOwner(object, "ANCHOR_PRESERVE");
	GameTooltip:AddLine(message, 1, 1, 1);
	GameTooltip:Show();
end

-- UI Dashboard open/close/hide
function LazyToggle_OpenDashboard()
	LazyToggle_DashboardOpen = true;
	LazyToggle.Dashboard:Show();
end

function LazyToggle_CloseDashboard()
	LazyToggle_DashboardOpen = false;
	LazyToggle.Dashboard:Hide();
end

function LazyToggle_HideDashboardToolTip()
	GameTooltip:Hide();
end

-- Update toggle Buttons
function LazyToggle_UpdateButtons()
	local btnDNDModeImage = "Interface\\AddOns\\LazyToggle\\dndoff.tga";
	if LazyToggle_IsDNDModeOn() then
		btnDNDModeImage = "Interface\\AddOns\\LazyToggle\\dndon.tga";
	end
	
	local btnAFKModeImage = "Interface\\AddOns\\LazyToggle\\afkoff.tga";
	if LazyToggle_IsAFKModeOn() then
		btnAFKModeImage = "Interface\\AddOns\\LazyToggle\\afkon.tga";
	end

	LazyToggle.Dashboard.ToggleDNDModeButton:SetNormalTexture(btnDNDModeImage);		
	LazyToggle.Dashboard.ToggleDNDModeButton:SetPushedTexture(btnDNDModeImage);
	
	LazyToggle.Dashboard.ToggleAFKModeButton:SetNormalTexture(btnAFKModeImage);
	LazyToggle.Dashboard.ToggleAFKModeButton:SetPushedTexture(btnAFKModeImage);
end

-- Send command function
function LazyToggle_SendCommand(cmd)
	local old = ChatFrameEditBox:GetText();
	ChatFrameEditBox:SetText(cmd)
	ChatEdit_SendText(ChatFrameEditBox);
	ChatFrameEditBox:SetText(old)
end

-- DND Mode
function LazyToggle_IsDNDModeOn()
	return LazyToggle_DNDMode;
end

function LazyToggle_ToggleDNDMode()
	if LazyToggle_IsDNDModeOn() then
		LazyToggle_SendCommand("/dnd");
	else
		LazyToggle_SendCommand("/dnd");
	end
end

function LazyToggle_UpdateDNDMode(isDNDMode)
	LazyToggle_DNDMode = isDNDMode;
	LazyToggle_UpdateButtons();
end

-- AFK Mode
function LazyToggle_IsAFKModeOn()
	return LazyToggle_AFKMode;
end

function LazyToggle_ToggleAFKMode()
	if LazyToggle_IsAFKModeOn() then
		LazyToggle_SendCommand("/afk");
	else
		LazyToggle_SendCommand("/afk");
	end
end

function LazyToggle_UpdateAFKMode(isAFKMode)
	LazyToggle_AFKMode = isAFKMode;
	LazyToggle_UpdateButtons();
end

-- Dashboard Frame
function LazyToggle.Dashboard:Gui()
		LazyToggle.Dashboard.Drag = { }
	function LazyToggle.Dashboard.Drag:StartMoving()
		this:StartMoving()
	end
	
	function LazyToggle.Dashboard.Drag:StopMovingOrSizing()
		this:StopMovingOrSizing()
	end
-- this is the properties for the background and borders of the frame	
	local backdrop = {
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile="true",
			tileSize="16",
			edgeSize="16",
	}
	
	self:SetFrameStrata("BACKGROUND")
	self:SetWidth(81) -- Set these to whatever height/width is needed 
	self:SetHeight(40) -- for your Texture
	self:SetPoint("TOPLEFT",312,-118) -- where the frame should be placed on the screen "CENTER/BOTTOM/TOP/LEFT/RIGHT/TOPRIGHT/TOPLEFT/BOTTOMLEFT/BOTTOMRIGHT", x, y
	self:SetMovable(1) -- set 1 to enable moving of the frame
	self:EnableMouse(1) -- set 1 to enable mouse to the frame
	self:RegisterForDrag("LeftButton") -- register a button for dragging
	self:SetBackdrop(backdrop) --background and border around the frame
	self:SetBackdropColor(0,0,0,1) -- sets color and opacity - r,g,b,opacity
	self:SetScript("OnDragStart", LazyToggle.Dashboard.Drag.StartMoving)
	self:SetScript("OnDragStop", LazyToggle.Dashboard.Drag.StopMovingOrSizing)	
	self:SetScript("OnUpdate", function()
		this:EnableMouse(IsAltKeyDown())
		if not IsAltKeyDown() and this.drag then
			self.options:StopMovingOrSizing()
		end
	end)
	
	-- Toggle DND Mode button
	LazyToggle.Dashboard.ToggleDNDModeButton = CreateFrame("Button",ToggleDNDModeButton,LazyToggle.Dashboard,"UIPanelCloseButton")
	LazyToggle.Dashboard.ToggleDNDModeButton:SetPoint("LEFT",5 ,0)
	LazyToggle.Dashboard.ToggleDNDModeButton:SetFrameStrata("LOW")
	LazyToggle.Dashboard.ToggleDNDModeButton:SetWidth(32)
	LazyToggle.Dashboard.ToggleDNDModeButton:SetHeight(32)
	LazyToggle.Dashboard.ToggleDNDModeButton:SetText("")
	LazyToggle.Dashboard.ToggleDNDModeButton:SetScript("OnClick", function() LazyToggle_ToggleDNDMode() end)
	LazyToggle.Dashboard.ToggleDNDModeButton:SetScript("OnEnter", function() LazyToggle_ShowDashboardToolTip(this, "Toggle DND Mode") end)
	LazyToggle.Dashboard.ToggleDNDModeButton:SetScript("OnLeave", function() LazyToggle_HideDashboardToolTip(this) end)
	LazyToggle.Dashboard.ToggleDNDModeButton:SetNormalTexture("Interface\\AddOns\\LazyToggle\\dndoff.tga")
	LazyToggle.Dashboard.ToggleDNDModeButton:SetPushedTexture("Interface\\AddOns\\LazyToggle\\dndoff.tga")
 
	-- Toggle AFK Mode button
	LazyToggle.Dashboard.ToggleAFKModeButton = CreateFrame("Button",ToggleAFKModeButton,LazyToggle.Dashboard,"UIPanelCloseButton")
	LazyToggle.Dashboard.ToggleAFKModeButton:SetPoint("LEFT",44 ,0)
	LazyToggle.Dashboard.ToggleAFKModeButton:SetFrameStrata("LOW")
	LazyToggle.Dashboard.ToggleAFKModeButton:SetWidth(32)
	LazyToggle.Dashboard.ToggleAFKModeButton:SetHeight(32)
	LazyToggle.Dashboard.ToggleAFKModeButton:SetText("")
	LazyToggle.Dashboard.ToggleAFKModeButton:SetScript("OnClick", function() LazyToggle_ToggleAFKMode() end)
	LazyToggle.Dashboard.ToggleAFKModeButton:SetScript("OnEnter", function() LazyToggle_ShowDashboardToolTip(this, "Toggle AFK Mode") end)
	LazyToggle.Dashboard.ToggleAFKModeButton:SetScript("OnLeave", function() LazyToggle_HideDashboardToolTip(this) end)
	LazyToggle.Dashboard.ToggleAFKModeButton:SetNormalTexture("Interface\\AddOns\\LazyToggle\\afkoff.tga")
	LazyToggle.Dashboard.ToggleAFKModeButton:SetPushedTexture("Interface\\AddOns\\LazyToggle\\afkoff.tga")
	
end

local function AddMessage(self, message, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if message and string.find(message, "You are now DND: Do not Disturb.") then
		LazyToggle_UpdateDNDMode(true);
		LazyToggle_UpdateAFKMode(false);
		
	elseif message and string.find(message, "You are no longer marked DND.") then
		LazyToggle_UpdateDNDMode(false);
		LazyToggle_UpdateAFKMode(nil);
		
	elseif message and string.find(message, "You are now AFK: Away from Keyboard") then
		LazyToggle_UpdateAFKMode(true);
		LazyToggle_UpdateDNDMode(false);
		
	elseif message and string.find(message, "You are no longer AFK.") then
		LazyToggle_UpdateAFKMode(false);
		LazyToggle_UpdateDNDMode(nil);
	end
	
	if message and string.find(message, "Incorrect syntax.") then
		return false;
	end
	if self and LazyToggle_ChatFrameHooks[self] and message then
		return LazyToggle_ChatFrameHooks[self](self, message, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
	end
	
end

function LazyToggle:OnEvent()
	if event == "ADDON_LOADED" and arg1 == "LazyToggle" then
		LazyToggle.Dashboard:Gui()
		LazyToggle_UpdateButtons()
		DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00LazyToggle:|r Version: "..LazyToggle_VERSION_MSG.." Loaded!",1,1,1)
		DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00LazyToggle:|r Hold 'Alt' to move LT.",1,1,1)
		LazyToggle_OnLogin()
	end	
end

LazyToggle:SetScript("OnEvent", LazyToggle.OnEvent) -- the OnEvent script

function LazyToggle_OnLogin()
		LazyToggle_UpdateAFKMode(nil);
		LazyToggle_UpdateDNDMode(nil);
end

-- slash command
function LazyToggle.slash()
	if LazyToggle.Dashboard:IsVisible() then
		LazyToggle.Dashboard:Hide()
	else LazyToggle.Dashboard:Show()
	end
end

SlashCmdList["LAZYTOGGLE_SLASH"] = LazyToggle.slash
SLASH_LAZYTOGGLE_SLASH1 = "/lt"
SLASH_LAZYTOGGLE_SLASH2 = "/LT"
