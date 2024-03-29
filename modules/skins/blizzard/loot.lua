local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local S = E:GetModule('Skins')

local function LoadSkin()
	LootHistoryFrame:SetFrameStrata('HIGH')
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.loot ~= true then return end
	local frame = MissingLootFrame

	frame:StripTextures()
	frame:CreateBackdrop("Default")
	frame:CreateShadow()

	S:HandleCloseButton(MissingLootFramePassButton)

	local function SkinButton()
		local numItems = GetNumMissingLootItems()

		for i = 1, numItems do
			local slot = _G["MissingLootFrameItem"..i]
			local icon = slot.icon

			S:HandleItemButton(slot, true)

			local texture, name, count, quality = GetMissingLootItemInfo(i);
			local color = (GetItemQualityColor(quality)) or (unpack(E.media.bordercolor))
			icon:SetTexture(texture)
			frame:SetBackdropBorderColor(color)
		end
		
		local numRows = ceil(numItems / 2);
		MissingLootFrame:SetHeight(numRows * 43 + 38 + MissingLootFrameLabel:GetHeight());
	end
	hooksecurefunc("MissingLootFrame_Show", SkinButton)
	
	-- loot history frame
	LootHistoryFrame:StripTextures()
	S:HandleCloseButton(LootHistoryFrame.CloseButton)
	LootHistoryFrame:StripTextures()
	LootHistoryFrame:SetTemplate('Transparent')
	S:HandleCloseButton(LootHistoryFrame.ResizeButton)
	LootHistoryFrame.ResizeButton.text:SetText("v v v v")
	LootHistoryFrame.ResizeButton:SetTemplate()
	LootHistoryFrame.ResizeButton:Width(LootHistoryFrame:GetWidth())
	LootHistoryFrame.ResizeButton:Height(19)
	LootHistoryFrame.ResizeButton:ClearAllPoints()
	LootHistoryFrame.ResizeButton:Point("TOP", LootHistoryFrame, "BOTTOM", 0, -2)
	LootHistoryFrameScrollFrame:StripTextures()
	S:HandleScrollBar(LootHistoryFrameScrollFrameScrollBar)

	local function UpdateLoots(self)
		local numItems = C_LootHistory.GetNumItems()
		for i=1, numItems do
			local frame = LootHistoryFrame.itemFrames[i]

			if not frame.isSkinned then
				local Icon = frame.Icon:GetTexture()
				frame:StripTextures()
				frame.Icon:SetTexture(Icon)
				frame.Icon:SetTexCoord(unpack(E.TexCoords))

				-- create a backdrop around the icon
				frame:CreateBackdrop("Default")
				frame.backdrop:SetOutside(frame.Icon)
				frame.Icon:SetParent(frame.backdrop)

				frame.isSkinned = true
			end
		end
	end
	hooksecurefunc("LootHistoryFrame_FullUpdate", UpdateLoots)

	--masterloot
	MasterLooterFrame:StripTextures()
	MasterLooterFrame:SetTemplate()
	MasterLooterFrame:SetFrameStrata('FULLSCREEN_DIALOG')
	
	hooksecurefunc("MasterLooterFrame_Show", function()
		local b = MasterLooterFrame.Item
		if b then
			local i = b.Icon
			local icon = i:GetTexture()
			local c = ITEM_QUALITY_COLORS[LootFrame.selectedQuality]

			b:StripTextures()
			i:SetTexture(icon)
			i:SetTexCoord(unpack(E.TexCoords))
			b:CreateBackdrop()
			b.backdrop:SetOutside(i)
			b.backdrop:SetBackdropBorderColor(c.r, c.g, c.b)
		end

		for i=1, MasterLooterFrame:GetNumChildren() do
			local child = select(i, MasterLooterFrame:GetChildren())
			if child and not child.isSkinned and not child:GetName() then
				if child:GetObjectType() == "Button" then
					if child:GetPushedTexture() then
						S:HandleCloseButton(child)
					else
						child:SetTemplate()
						child:StyleButton()
					end
					child.isSkinned = true
				end
			end
		end
	end) 
end

S:RegisterSkin("ElvUI", LoadSkin)