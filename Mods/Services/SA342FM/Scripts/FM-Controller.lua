-- function LuaExportStart()
	
	--file = io.open(lfs.writedir() .. [[Logs\DCS-SA342FM-Radio.log]], "w")
	--[[function fmlog(str)
		if file then
			file:write(str .. "\n")
			file:flush()
		end
	end--]]
-- end

function getChnlPosition(_args, _step) -- Function courtesy of SRS Export
    local _value = GetDevice(0):get_argument_value(_args)
    local _num = math.abs(tonumber(string.format("%.0f", (_value) / _step)))
    return _num
end

function getButtonPosition(_args)
	return GetDevice(0):get_argument_value(_args)
end

function changeOnScreenFreq(_value, _append) -- _value = string (integers), _append = true/false
	if button_down == false then -- Rapid input without tracking the button state
		if _append == false then
			onscreen_Freq = _value
		else
			onscreen_Freq = onscreen_Freq.._value
		end
		button_down = true
		validated = false -- Destroy validation and cause the screen to blink based on input rather than preset
	end
end

onscreen_Freq = "30000" -- Set the starting freq and we'll change this later
button_down = false
validated = true
gTime = 0
FM_on_off = false -- for blinking effect
FM_Preset = {}
FM_Preset[0] = 30000000 -- This first preset [0] needs to match the above "onscreen_Freq"/1000; otherwise SRS will not display what the screen does
FM_Preset[1] = 31000000 -- The rest of these presets don't matter, as long as they're within operating range
FM_Preset[2] = 32625000
FM_Preset[3] = 33000000
FM_Preset[4] = 34000000
FM_Preset[5] = 35000000
FM_Preset[6] = 36000000
FM_Preset[7] = 37000000
function LuaExportAfterNextFrame()
	if string.find(LoGetSelfData().Name, "SA342",1,true) then -- Check if Gazelle
		local CHNL = getChnlPosition(273, 0.143) -- Channel knob position
		local FMFreq = get_param_handle("New_FM") -- On-screen display value
		if validated == true then
			FMFreq:set(tonumber(string.format("%0.3f", FM_Preset[CHNL]/1000000))) -- A validated display; translate the preset to display by dividing
			onscreen_Freq = FM_Preset[CHNL]/1000 -- translate preset to the variable itself
		else -- User hitting buttons.. it's all mucked-up...
			if LoGetModelTime() >= gTime + 0.25 then -- Lets start blinking, I guess
				if FM_on_off == false then
					get_param_handle("FM_Freq_vis"):set(0.75)
					FM_on_off = true
				else
					get_param_handle("FM_Freq_vis"):set(0)
					FM_on_off = false
				end
				gTime = LoGetModelTime()
			end
			onscreen_Freq = string.sub(onscreen_Freq, -5) -- This causes the radio to function like the UHF radio input
			FMFreq:set(tonumber(string.format("%0.3f", tonumber(onscreen_Freq)/1000))) -- For input
		end
		GetDevice(28):set_frequency(FM_Preset[CHNL]) -- Set the actual freq for DCS to give to SRS and soforth
		if getButtonPosition(278) > 0.5 then -- BTN_X; Creature feature, enables user to backtrack instead of re-entering the entire freq.
			if button_down == false then
				onscreen_Freq = string.sub(onscreen_Freq, 1, -2) -- Remove last digit; repeatedly pushing this will remove each subsequent digit
				validated = false -- Dirty frequency
				button_down = true
			end
		elseif getButtonPosition(277) > 0.5 then -- BTN_0
			changeOnScreenFreq("0", true)
		elseif getButtonPosition(284) > 0.5 then -- BTN_1
			changeOnScreenFreq("1", true)
		elseif getButtonPosition(285) > 0.5 then -- BTN_2
			changeOnScreenFreq("2", true)
		elseif getButtonPosition(286) > 0.5 then -- BTN_3
			changeOnScreenFreq("3", true)
		elseif getButtonPosition(279) > 0.5 then -- BTN_4
			changeOnScreenFreq("4", true)
		elseif getButtonPosition(280) > 0.5 then -- BTN_5
			changeOnScreenFreq("5", true)
		elseif getButtonPosition(281) > 0.5 then -- BTN_6
			changeOnScreenFreq("6", true)
		elseif getButtonPosition(274) > 0.5 then -- BTN_7
			changeOnScreenFreq("7", true)
		elseif getButtonPosition(275) > 0.5 then -- BTN_8
			changeOnScreenFreq("8", true)
		elseif getButtonPosition(276) > 0.5 then -- BTN_9
			changeOnScreenFreq("9", true)
		elseif getButtonPosition(287) > 0.5 then -- BTN_VAL
			if button_down == false then
				-- min = 30E6, max = 87.975E6
				if (tonumber(onscreen_Freq)*1000 >= 30E6 and tonumber(onscreen_Freq)*1000 <= 87.975E6 and tonumber(onscreen_Freq) % 25 == 0) then -- Check operating range and modulo of 25
					FM_Preset[CHNL] = tonumber(onscreen_Freq)*1000 -- Save to currently selected preset
					validated = true
				else
					onscreen_Freq = tostring(FM_Preset[CHNL])/1000 -- return to last known "good" freq
					validated = true -- It failed validation, but we need to reset validated to true in order to continue operating as normal
				end
				button_down = true
			end
		else
			button_down = false -- Our default state for button tracking
		end
	end
end