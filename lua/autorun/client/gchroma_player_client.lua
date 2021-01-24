GChroma_PlayerModule_Loaded = true

local function GetEmptySlots( ply )
	local slots = {
		{ 0, -1 },
		{ 1, -1 },
		{ 2, -1 },
		{ 3, -1 },
		{ 4, -1 },
		{ 5, -1 }
	}
	for k,v in pairs( ply:GetWeapons() ) do
		local slot = v:GetSlot()
		slots[slot + 1][2] = slot
	end
	return slots
end

local function GChromaPlayerInit()
	local ply = LocalPlayer()
	local initial = net.ReadBool()
	if GChroma_Loaded then
		if IsValid( ply ) then
			require( "gchroma" )
			local chroma = GChroma_Start()
			local plycolor = GChroma_ToVector( ply:GetPlayerColor():ToColor() )
			GChroma_ResetDevice( chroma, GCHROMA_DEVICE_ALL )

			local keys = {
				GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "noclip" ) ) ),
				GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "messagemode" ) ) ),
				GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "messagemode2" ) ) ),
				GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "menu" ) ) ),
				GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "menu_context" ) ) ),
				GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "impulse 100" ) ) ),
				GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "voicerecord" ) ) )
			}

			GChroma_SetDeviceColor( chroma, GCHROMA_DEVICE_ALL, Vector( 25, 25, 25 ) )

			for k,v in pairs( keys ) do
				GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, plycolor, v, 0 )
			end
			
			timer.Simple( 0.1, function()
				for k,v in pairs( GetEmptySlots( ply ) ) do
					if v[2] == -1 then
						GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, Vector( 145, 80, 0 ), _G["GCHROMA_KEY_"..v[1] + 1], 0 )
					else
						GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, plycolor, _G["GCHROMA_KEY_"..v[1] + 1], 0 )
					end
				end
				GChroma_CreateEffect( chroma )
			end )
		end
	end
	if !GChroma_Loaded and initial then
		chat.AddText( Color( 0, 255, 0 ), "WARNING! GChroma is not loaded! Please follow the install instructions: https://steamcommunity.com/sharedfiles/filedetails/?id=2297412726" )
	end
end
net.Receive( "GChromaPlayerInit", GChromaPlayerInit )

local function GChromaOpenChat( teamchat )
	if GChroma_Loaded then
		local chroma = GChroma_Start()
		local normalchat = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "messagemode" ) ) )
		local chatteam = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "messagemode2" ) ) )
		if teamchat then
			GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, GCHROMA_COLOR_WHITE, chatteam, 0 )
		else
			GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, GCHROMA_COLOR_WHITE, normalchat, 0 )
		end
		GChroma_CreateEffect( chroma )
	end
end
hook.Add( "StartChat", "GChromaOpenChat", GChromaOpenChat )

local function GChromaCloseChat()
	local ply = LocalPlayer()
	if GChroma_Loaded and IsValid( ply ) then
		local chroma = GChroma_Start()
		local plycolor = GChroma_ToVector( ply:GetPlayerColor():ToColor() )
		local normalchat = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "messagemode" ) ) )
		local teamchat = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "messagemode2" ) ) )
		GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, plycolor, normalchat, 0 )
		GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, plycolor, teamchat, 0 )
		GChroma_CreateEffect( chroma )
	end
end
hook.Add( "FinishChat", "GChromaCloseChat", GChromaCloseChat )

local function GChromaNoclip()
	local ply = LocalPlayer()
	if GChroma_Loaded and IsValid( ply ) then
		local chroma = GChroma_Start()
		local enable = net.ReadBool()
		local convert = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "noclip" ) ) )
		if enable then
			GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, GCHROMA_COLOR_WHITE, convert, 0 )
		else
			local plycolor = GChroma_ToVector( ply:GetPlayerColor():ToColor() )
			GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, plycolor, convert, 0 )
		end
		GChroma_CreateEffect( chroma )
	end
end
net.Receive( "GChromaNoclip", GChromaNoclip )

local function GChromaOpenSpawnMenu()
	if GChroma_Loaded then
		local chroma = GChroma_Start()
		local convert = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "menu" ) ) )
		GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, GCHROMA_COLOR_WHITE, convert, 0 )
		GChroma_CreateEffect( chroma )
	end
end
hook.Add( "OnSpawnMenuOpen", "GChromaOpenSpawnMenu", GChromaOpenSpawnMenu )

local function GChromaCloseSpawnMenu()
	local ply = LocalPlayer()
	if GChroma_Loaded and IsValid( ply ) then
		local chroma = GChroma_Start()
		local plycolor = GChroma_ToVector( ply:GetPlayerColor():ToColor() )
		local convert = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "menu" ) ) )
		GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, plycolor, convert, 0 )
		GChroma_CreateEffect( chroma )
	end
end
hook.Add( "OnSpawnMenuClose", "GChromaCloseSpawnMenu", GChromaCloseSpawnMenu )

local function GChromaOpenContextMenu()
	if GChroma_Loaded then
		local chroma = GChroma_Start()
		local convert = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "menu_context" ) ) )
		GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, GCHROMA_COLOR_WHITE, convert, 0 )
		GChroma_CreateEffect( chroma )
	end
end
hook.Add( "OnContextMenuOpen", "GChromaOpenContextMenu", GChromaOpenContextMenu )

local function GChromaCloseContextMenu()
	local ply = LocalPlayer()
	if GChroma_Loaded and IsValid( ply ) then
		local chroma = GChroma_Start()
		local plycolor = GChroma_ToVector( ply:GetPlayerColor():ToColor() )
		local convert = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "menu_context" ) ) )
		GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, plycolor, convert, 0 )
		GChroma_CreateEffect( chroma )
	end
end
hook.Add( "OnContextMenuClose", "GChromaCloseContextMenu", GChromaCloseContextMenu )

local function GChromaFlashlight()
	local ply = LocalPlayer()
	if GChroma_Loaded and IsValid( ply ) then
		local chroma = GChroma_Start()
		local enabled = net.ReadBool()
		local convert = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "impulse 100" ) ) )
		if enabled then
			GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, GCHROMA_COLOR_WHITE, convert, 0 )
		else
			local plycolor = GChroma_ToVector( ply:GetPlayerColor():ToColor() )
			GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, plycolor, convert, 0 )
		end
		GChroma_CreateEffect( chroma )
	end
end
net.Receive( "GChromaFlashlight", GChromaFlashlight )

local function GChromaStartVoice()
	if GChroma_Loaded then
		local chroma = GChroma_Start()
		local convert = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "voicerecord" ) ) )
		GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, GCHROMA_COLOR_WHITE, convert, 0 )
		GChroma_CreateEffect( chroma )
	end
end
hook.Add( "PlayerStartVoice", "GChromaStartVoice", GChromaStartVoice )

local function GChromaEndVoice()
	local ply = LocalPlayer()
	if GChroma_Loaded and IsValid( ply ) then
		local chroma = GChroma_Start()
		local plycolor = GChroma_ToVector( ply:GetPlayerColor():ToColor() )
		local convert = GChroma_KeyConvert( input.GetKeyCode( input.LookupBinding( "voicerecord" ) ) )
		GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, plycolor, convert, 0 )
		GChroma_CreateEffect( chroma )
	end
end
hook.Add( "PlayerEndVoice", "GChromaEndVoice", GChromaEndVoice )

local function GChromaUpdateSlots()
	local ply = LocalPlayer()
	if GChroma_Loaded and IsValid( ply ) then
		local chroma = GChroma_Start()
		local plycolor = GChroma_ToVector( ply:GetPlayerColor():ToColor() )
		for k,v in pairs( GetEmptySlots( ply ) ) do
			if v[2] == -1 then
				GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, Vector( 145, 80, 0 ), _G["GCHROMA_KEY_"..v[1] + 1], 0 )
			else
				GChroma_SetDeviceColorEx( chroma, GCHROMA_DEVICE_KEYBOARD, plycolor, _G["GCHROMA_KEY_"..v[1] + 1], 0 )
			end
		end
		GChroma_CreateEffect( chroma )
	end
end
net.Receive( "GChromaUpdateSlots", GChromaUpdateSlots )

if DarkRP then
	local function GChromaDarkRPChangedTeam( ply )
		if GChroma_Loaded then
			GChromaPlayerInit()
		end
	end
	hook.Add( "OnPlayerChangedTeam", "GChromaDarkRPChangedTeam", GChromaDarkRPChangedTeam )
end
