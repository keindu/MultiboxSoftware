SLASH_HELLO1 = "/hw"
local frame = CreateFrame("Frame", nil, UIParent) -- Creates a parent frame anchored to the main UI
local gsub = gsub;
-- Positioning settings:
frame:SetPoint("TOPLEFT", 0, 0)         -- Centers horizontally and vertically
frame:SetSize(125, 125)          -- Makes it 100x100 pixels in size

-- Create texture object and set properties:
local texture = frame:CreateTexture()
-- message("3")
texture:SetPoint("TOPLEFT",93, -248)
texture:SetSize(1, 1)
texture:SetTexture("Interface\\AddOns\\Multibox\\Smooth.tga")

local function drawPixel(r,g,b)
    texture:SetVertexColor(r, g, b)
    frame:SetFrameStrata("HIGH")
end

local function test(name)
    -- for i=0,255 do
    --     drawPixel(i/255,0,0,0,i-1)
    -- end
end

local spellIDs = {
    [1] = "Lesser Healing Wave",
    [2] = "Chain Heal",
    [3] = "Riptide",
    [4] = "Water Shield",
    [5] = "Earthliving Weapon",
    [6] = "Earth Shield",
    [0] = "Pass"
}

local function getRestoShamanAction()
    local spellID, targetID

    -- Check if the player has Water Shield
    if not UnitBuff("player", "Water Shield") then
        spellID, targetID = 4, 0
    -- Check if the player has a weapon enchant
    elseif not GetWeaponEnchantInfo() then
        spellID, targetID = 5, 0
    -- Focus check for Earth Shield
    elseif GetUnitName("focus") and UnitInRange("focus") and not UnitBuff("focus", "Earth Shield") then
        spellID, targetID = 6, -1
    else
        -- Default values in case no action is needed
        spellID, targetID = 0, 0
    end

    -- Loop through raid members to check who needs healing
    local numtargets = 0
    local target = 0
    local targetPercent = 1.0

    for i = 1, GetNumRaidMembers() do
        local u = "raid" .. i
        local healthPercent = UnitHealth(u) / UnitHealthMax(u)

        if healthPercent < 1.0 and UnitIsPlayer(u) and UnitInRange(u) then
            numtargets = numtargets + 1
            if healthPercent < targetPercent then
                targetPercent = healthPercent
                target = i
            end
        end
    end

    -- If there are multiple targets, choose Chain Heal
    if numtargets > 1 then
        spellID, targetID = 2, target
    -- If there's at least one target, decide on spell
    elseif numtargets > 0 then
        local start, duration = GetSpellCooldown("Riptide")
        if start > 0 and duration > 0 then
            spellID, targetID = 1, target
        else
            spellID, targetID = 3, target
        end
    end

    -- Draw the pixel when we decide on a spell and target
    drawPixel(spellID / 255, 0, (targetID + 1) / 255)  -- We shift -1 to 0 for the focus case

    return spellID, targetID
end

-- Call the function and draw the pixel
local spellID, targetID = getRestoShamanAction()
DEFAULT_CHAT_FRAME:AddMessage(string.format("Spell ID: %d | Target ID: %d", spellID, targetID))

SlashCmdList["HELLO"] = test
local i = 0;
local frame = CreateFrame("FRAME")
local timeElapsed = 0
MacroButton=CreateFrame("Button","MyMacroButton",nil,"SecureActionButtonTemplate");
MacroButton:RegisterForClicks("AnyUp");--   Respond to all buttons
MacroButton:SetAttribute("type","macro");-- Set type to "macro"
-- SetBindingClick("R", "MyMacroButton")
frame:HookScript("OnUpdate", function(self, elapsed)
	timeElapsed = timeElapsed + elapsed
	if (timeElapsed > .5) then
		timeElapsed = 0
        i = (i +1) % 255;
        local r = i /255;
        -- local nextMacro = getRestoShamanMacro();
        -- DEFAULT_CHAT_FRAME:AddMessage(nextMacro);

        DEFAULT_CHAT_FRAME:AddMessage(i);
        MacroButton:SetAttribute("macrotext",nextMacro);
        drawPixel(r,0,0)
		-- do something
	end
end)
