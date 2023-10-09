local spacing = 10
local tabwidth = 150
local ignored = {}

pfStudio.events = windget.window:CreateWindow("Events", 600, 300)
pfStudio.events:SetMinResize(160, 60)

pfStudio.events:RegisterAllEvents()
pfStudio.events:SetScript("OnEvent", function()
	if (ignored[event]) then return end
  local count = 0
  local debuglink = "|H" .. event .. ":"
  local append = ""

  for i=1,30 do
    if getglobal("arg" .. i) then
      local text = tostring(getglobal("arg" .. i))
      if text == "" then text = "|cff555555nil|r" end
      text = string.gsub(text, ":",'⬥')
      text = string.gsub(text, "|",'⬦')
      debuglink = debuglink .. text .. ":"
      count = i
    end
  end

  if count > 0 then
    append = "|cff33ffcc" .. debuglink .. "|h[" .. count .. "]|h|r"
  end
  local eventlink = "|H" .. event .. "|h[" .. event .. "]|h"
  pfStudio.events.input:AddMessage("|cff555555" .. date("%H:%M:%S") .. "|r " .. eventlink .. append .. "\n")
end)

pfStudio.events.input = windget.widget:CreateWidget("ScrollingMessageFrame", nil, pfStudio.events)
pfStudio.events.input:SetBackdropColor(0,0,0,.35)
pfStudio.events.input:SetPoint("TOPLEFT", pfStudio.events, "TOPLEFT", spacing, -spacing)
pfStudio.events.input:SetPoint("BOTTOMRIGHT", pfStudio.events, "BOTTOMRIGHT", -spacing, spacing)
pfStudio.events.input:SetFontObject(GameFontWhite)
pfStudio.events.input:SetFont(windget.fontmono, windget.fontsizemono, windget.fontopts)
pfStudio.events.input:SetMaxLines(150)
pfStudio.events.input:SetJustifyH("LEFT")
pfStudio.events.input:SetFading(false)

pfStudio.events.input:EnableMouseWheel(1)
pfStudio.events.input:SetScript("OnMouseWheel", function()
	local self = this
	local modi = IsControlKeyDown() or IsAltKeyDown() or IsShiftKeyDown()
	local scroll = arg1 > 0 and (modi and self.PageUp or self.ScrollUp) or (modi and self.PageDown or self.ScrollDown)
	scroll(self)
end)
local function applyignored(event)
	if ignored[event] then
		ignored[event] = nil
		DEFAULT_CHAT_FRAME:AddMessage("bring : [" .. event .. "] back")
		return
	end
	ignored[event] = 1
	DEFAULT_CHAT_FRAME:AddMessage("ignored : " .. event)
end

pfStudio.events.input:SetScript("OnHyperlinkClick", function()
  local arg1 = arg1
  if strbyte(arg1, strlen(arg1)) ~= 58 then -- ':'
    applyignored(arg1)
    return
  end
  ShowUIPanel(ItemRefTooltip);
  ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
  ItemRefTooltip:SetFrameStrata("TOOLTIP")
  for num, text in ({ pfStudio.strsplit(":", arg1) }) do
    if num ~= 1 then
      text = string.gsub(text, '⬥', ":")
      text = string.gsub(text, '⬦', "|")

      ItemRefTooltip:AddLine("|cff33ffccArgument " .. num -1 .. ":|r|cffffffff " .. text)
    else
      ItemRefTooltip:AddLine(text,1,1,0)
    end
  end

  ItemRefTooltip:Show()
end)
