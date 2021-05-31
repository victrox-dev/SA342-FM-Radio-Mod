dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."arg_int.lua")

local gettext = require("i_18n")
_ = gettext.translate

cursor_mode = 
{ 
    CUMODE_CLICKABLE = 0,
    CUMODE_CLICKABLE_AND_CAMERA  = 1,
    CUMODE_CAMERA = 2,
};

clickable_mode_initial_status  = cursor_mode.CUMODE_CLICKABLE
use_pointer_name			   = true

function default_button(hint_,device_,command_,arg_,arg_val_,arg_lim_)

	local   arg_val_ = arg_val_ or 1
	local   arg_lim_ = arg_lim_ or {0,1}

	return  {	
				class 				= {class_type.BTN},
				hint  				= hint_,
				device 				= device_,
				action 				= {command_},
				stop_action 		= {command_},
				arg 				= {arg_},
				arg_value			= {arg_val_}, 
				arg_lim 			= {arg_lim_},
				updatable 	= true, 
				use_release_message = {true}
			}
end

function default_2_position_tumb(hint_, device_, command_, arg_)
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-1,1}, 
				arg_lim   	= {{0,1},{0,1}},
				updatable 	= true, 
				use_OBB 	= true,
			}
end

function default_3_position_tumb(hint_,device_,command_,arg_,cycled_,inversed_)
	local cycled = true
	local val =  1
	if inversed_ then
	      val = -1
	end
	if cycled_ ~= nil then
	   cycled = cycled_
	end
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-val,val}, 
				arg_lim   	= {{-1,1},{-1,1}},
				updatable 	= true, 
				use_OBB 	= true,
				cycle       = cycled
			}
end

function default_axis(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_)
	
	local default = default_ or 1
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	
	return  {	
				class 		= {class_type.LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {{0,1}},
				updatable 	= updatable, 
				use_OBB 	= true,
				gain		= {gain},
				relative    = {relative},
				cycle		= false				
			}
end

function default_movable_axis(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_)
	
	local default = default_ or 1
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	
	return  {	
				class 		= {class_type.MOVABLE_LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {{0,1}},
				updatable 	= updatable, 
				use_OBB 	= true,
				gain		= {gain},
				relative    = {relative}, 				
			}
end

function multiposition_switch_limited(hint_,device_,command_,arg_,count_,delta_,inversed_,min_) -- 6,0.20,nil,0)
    local min_   = min_ or 0
	local delta_ = delta_ or 0.5
	
	local inversed = 1
	if	inversed_ then
		inversed = -1
	end
	
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-delta_ * inversed,delta_ * inversed}, 
				arg_lim   	= {{min_, min_ + delta_ * (count_ -1)},
							   {min_, min_ + delta_ * (count_ -1)}},
				updatable 	= true, 
				use_OBB 	= true,
				cycle     	= false, 
			}
end

function default_button_axis(hint_, device_,command_1, command_2, arg_1, arg_2, limit_1, limit_2) 
	local limit_1_   = limit_1 or 1.0
	local limit_2_   = limit_2 or 1.0
return {
			class		=	{class_type.BTN, class_type.LEV},
			hint		=	hint_,
			device		=	device_,
			action		=	{command_1, command_2},
			stop_action =   {command_1, command_2}, 
			arg			=	{arg_1, arg_2},
			arg_value	= 	{1, 0.5},
			arg_lim		= 	{{0, limit_1_}, {0,limit_2_}},
			--animated        = {false,false},
			--animated        = {false,false},
			--animation_speed = {0, 0},
			gain = {0, 0.1},
			relative	= 	{false, true},
			updatable 	= 	true, 
			use_OBB 	= 	true,
			use_release_message = {true, false},
	}
end

function default_button_tumb(hint_, device_, command1_, command2_, arg_,style)
	if style == 1 or style == nil then
		stop_action_ = {command1_,0}
	elseif style == 2 then
		stop_action_ = {command1_,command2_}
	end
	return  {	
				class 		= {class_type.BTN,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command1_,command2_},
				stop_action = stop_action_,
				arg 	  	= {arg_,arg_},
				arg_value 	= {-1,1}, 
				arg_lim   	= {{-1,0},{0,1}},
				updatable 	= true, 
				use_OBB 	= true,
				use_release_message = {true,false}
			}
end

elements = {}

-- [WEAPONS PANEL1]
elements["WP1_ONOFF"] = default_3_position_tumb(_("SA342 WP1 OnOff"),devices.WEAPONS, device_commands.Button_4,arg_int.WP1_OnOff,false,true) -- 354 arg number
--elements["WP1_ARROW"] = default_button_tumb(_("SA342 WP1 Arrow"), devices.WEAPONS,device_commands.Button_5, device_commands.Button_6, arg_int.WP1_Arrow,2) -- 355 arg number
--elements["WP1_VALUE"] = default_button_tumb(_("SA342 WP1 Value"), devices.WEAPONS,device_commands.Button_7, device_commands.Button_8, arg_int.WP1_Value,2) -- 356 arg number
elements["WP1_BRT"] = default_axis(_("SA342 WP1 Brt"), devices.WEAPONS,device_commands.Button_9, arg_int.WP1_Brt,0,0.1,true,false) -- 357 arg number

-- [WEAPONS PANEL2]
elements["WP2_MA_LEFT"] = default_2_position_tumb(_("SA342 WP2 Ma Left"),devices.WEAPONS, device_commands.Button_10,arg_int.WP2_Ma_Left) -- 372 arg number
elements["WP2_MA_LEFT_COVER"] = default_2_position_tumb(_("SA342 WP2 Ma Left Cover"),devices.WEAPONS,device_commands.Button_11,arg_int.WP2_Ma_Left_Cover) -- 373 arg number
elements["WP2_MA_RIGHT"] = default_2_position_tumb(_("SA342 WP2 Ma Right"),devices.WEAPONS,device_commands.Button_12,arg_int.WP2_Ma_Right) -- 374 arg number
elements["WP2_MA_RIGHT_COVER"] = default_2_position_tumb(_("SA342 WP2 Ma Right Cover"),devices.WEAPONS,device_commands.Button_13,arg_int.WP2_Ma_Right_Cover) -- 375 arg number
elements["WP2_SEQ"] = default_2_position_tumb(_("SA342 WP2 Seq"),devices.WEAPONS,device_commands.Button_14,arg_int.WP2_Seq) -- 376 arg number

-- [PILOTSIGHT]
elements["PILOTSIGHT-PTR"] = default_2_position_tumb(_("SA342 Pilot Sight"),devices.WEAPONS, device_commands.Button_2,arg_int.PilotSight) -- 171 arg number

-- [PILOT STICK]
elements["DEB-EFF-PTR"] = default_button(_("SA342 Magnetic Brake"),devices.CONTROLS,device_commands.Button_1,arg_int.Pilot_Stick_DEB_EFF,1,{0,1}) -- 50 arg number
elements["EG-STICK-PTR"] = default_button(_("SA342 Wiper once"),devices.ELECTRIC,device_commands.Button_18,arg_int.Pilot_Stick_EG,1,{0,1}) -- 53 arg number
elements["PILOT-STICK-PA-PTR"] = default_button(_("SA342 Autopilot Button"),devices.AUTOPILOT,device_commands.Button_28,arg_int.Pilot_Stick_PA,1,{0,1}) -- 209 arg number
elements["SLAVE-PTR"] = default_button(_("SA342 Slave"),devices.AUTOPILOT,device_commands.Button_12,arg_int.Pilot_Slave_Button,1,{0,1}) -- 293 arg number
elements["HOVER-PTR"] = default_button(_("SA342 Auto-Hover"),devices.AUTOPILOT,device_commands.Button_8,arg_int.Pilot_Hover_Button,1,{0,1}) -- 294 arg number

-- [WSO LEFT SIDE STICK]
elements["WS_CACHE_TELEMETRE_PTR"] = default_2_position_tumb(_("SA342 Lasing Button Cover"),devices.PE, device_commands.Button_21,arg_int.WsoStick_cache_telemetre) -- 255 arg number
elements["WS_TELEMETRE_PTR"] = default_button(_("SA342 Lasing Button"),devices.PE,device_commands.Button_22,arg_int.WsoStick_telemetre,1,{0,1}) -- 256 arg number
elements["WS_CACHE_TIR_PTR"] = default_2_position_tumb(_("SA342 Missile Launch Cover"),devices.PE, device_commands.Button_23,arg_int.WsoStick_cache_tir) -- 257 arg number
elements["WS_TIR_PTR"] = default_button(_("SA342 Missile Launch Button"),devices.PE,device_commands.Button_24,arg_int.WsoStick_tir,1,{0,1}) -- 258 arg number
elements["WS_INV_INCRUST_PTR"] = default_button(_("SA342 Inversed Symbology Toggle"),devices.PE,device_commands.Button_25,arg_int.WsoStick_inv_incrust,1,{0,1}) -- 259 arg number
elements["WS_INV_FOND_PTR"] = default_button(_("SA342 Inversed Image Toggle"),devices.PE,device_commands.Button_26,arg_int.WsoStick_inv_fond,1,{0,1}) -- 260 arg number
elements["WS_NET_PTR"] = default_button_tumb(_("SA342 Image Focus"),devices.PE, device_commands.Button_27, device_commands.Button_28,arg_int.WsoStick_nettete,2) -- 261 arg number
elements["WS_GAIN_PTR"] = default_button_tumb(_("SA342 Gain"),devices.PE, device_commands.Button_29, device_commands.Button_30,arg_int.WsoStick_gain,2) -- 262 arg number
elements["WS_LUM_PTR"] = default_button_tumb(_("SA342 Image Brightness"),devices.PE, device_commands.Button_31, device_commands.Button_32,arg_int.WsoStick_lum_fond,2) -- 263 arg number
elements["WS_INCRUST_PTR"] = default_button_tumb(_("SA342 Symbology Brightness"),devices.PE, device_commands.Button_33, device_commands.Button_34,arg_int.WsoStick_lum_incrust,2) -- 219 arg number

-- [GYRO]
elements["GYRO-TEST-COVER-PTR"] = default_2_position_tumb(_("SA342 Gyro Test Cover On/Off"),devices.AUTOPILOT, device_commands.Button_14,arg_int.GYRO_test_cover) -- 197 arg number
elements["GYRO-TEST-SWITCH-PTR"] = default_2_position_tumb(_("SA342 Gyro Test Switch On/Off"),devices.AUTOPILOT, device_commands.Button_15,arg_int.GYRO_test_switch) -- 198 arg number
elements["GYRO-SWITCH-GD-PTR"] = default_3_position_tumb(_("SA342 Left/Center/Right"),devices.AUTOPILOT, device_commands.Button_16,arg_int.GYRO_switchGD,false,true) -- 199 arg number
elements["GYRO-KNOB-GD-PTR"] = multiposition_switch_limited("SA342 CM/A/GM/D/GD",devices.AUTOPILOT,device_commands.Button_17,arg_int.GYRO_KnobGD,5,0.25,nil,0) -- 153 arg number

--[CLOCK]
elements["CLOCK-WINDER-PTR"] = default_button_axis(_("SA342 Winder"), devices.CLOCK,device_commands.Button_4, device_commands.Button_1, arg_int.Clock_Wind_Push, arg_int.Clock_Wind, 1, 1) -- 45 et 270 arg numbers
elements["CLOCK-STARTSTOP-PTR"] = default_button(_("SA342 Start/Stop"),devices.CLOCK,device_commands.Button_2,arg_int.Clock_StartStop,1,{0,1}) -- 46 arg number
elements["CLOCK-RESET-PTR"] = default_button(_("SA342 Reset"),devices.CLOCK,device_commands.Button_3,arg_int.Clock_Reset,1,{0,1}) -- 47 arg number

--[PH]
elements["PV_CLE_PTR"] = multiposition_switch_limited("Test/On/Off",devices.PH,device_commands.Button_1,arg_int.PH_Cle,5,0.25,nil,0) -- 180 arg number
elements["PV-GISEMENT-PTR"] = multiposition_switch_limited(_("SA342 Station Select"),devices.PH,device_commands.Button_2, arg_int.PH_Gisement, 9,0.125,nil,0) -- 181 arg number
elements["PV_LUM_PTR"] = default_axis(_("SA342 Brightness"), devices.PH,device_commands.Button_3, arg_int.PH_Lum,0,0.1,true,false) -- 182 arg number

--[PE]
elements["PE_CENTERING"] = default_button(_("SA342 Centering"),devices.PE, device_commands.Button_1,arg_int.PE_CENTERING,1,{0,1}) -- 8 -- 362 arg number
elements["PE_VDOVTH"] = default_button(_("SA342 VDO/VTH"),devices.PE,device_commands.Button_2,arg_int.PE_VDOVTH,1,{0,1}) -- 6 -- 364 arg number
elements["PE_ZOOM"] = default_button_tumb(_("SA342 Zoom"), devices.PE,device_commands.Button_4, device_commands.Button_3, arg_int.PE_ZOOM,2) -- 9 -- 365 arg number
elements["PE_TLM"] = multiposition_switch_limited(_("SA342 CTH"), devices.PE,device_commands.Button_5, arg_int.PE_TLM,3,0.5,nil,0) -- 4 -- 366 arg number
elements["PE_ALI"] = default_2_position_tumb(_("SA342 Power"),devices.PE, device_commands.Button_6,arg_int.PE_ALI) -- 367 arg number
elements["PE_MODE"] = multiposition_switch_limited(_("SA342 Mode"),devices.PE,device_commands.Button_7,arg_int.PE_ASS,5,0.25,nil,0) -- 1 -- 370 arg number

-- [NADIR]
elements["NADIR_BRT"] = default_axis(_("SA342 NADIR Off/Brightness"), devices.NADIR,device_commands.Button_1, arg_int.NADIR_BRT,0,0.1,true,false) -- 330 arg number
elements["NADIR_DOPPLER"] = multiposition_switch_limited(_("SA342 NADIR Mode"),devices.NADIR,device_commands.Button_2,arg_int.NADIR_DOPPLER,6,0.20,nil,0) -- 331 arg number
elements["NADIR_VENT"] = multiposition_switch_limited(_("SA342 NADIR Parameter"),devices.NADIR,device_commands.Button_3,arg_int.NADIR_VENT,6,0.20,nil,0) -- 332 arg number
elements["NADIR_ENT"] = default_button(_("SA342 NADIR ENT"),devices.NADIR,device_commands.Button_4,arg_int.NADIR_ENT,1,{0,1}) -- 333 arg number
elements["NADIR_DES"] = default_button(_("SA342 NADIR DES"),devices.NADIR,device_commands.Button_5,arg_int.NADIR_DES,1,{0,1}) -- 334 arg number
elements["NADIR_AUX"] = default_button(_("SA342 NADIR AUX"),devices.NADIR,device_commands.Button_6,arg_int.NADIR_AUX,1,{0,1}) -- 335 arg number
elements["NADIR_IC"] = default_button(_("SA342 NADIR IC"),devices.NADIR,device_commands.Button_7,arg_int.NADIR_IC,1,{0,1}) -- 336 arg number
elements["NADIR_DOWN"] = default_button(_("SA342 NADIR DOWN"),devices.NADIR,device_commands.Button_8,arg_int.NADIR_DOWN,1,{0,1}) -- 337 arg number
elements["NADIR_0"] = default_button(_("SA342 NADIR 0"),devices.NADIR,device_commands.Button_9,arg_int.NADIR_0,1,{0,1}) -- 351 arg number
elements["NADIR_1"] = default_button(_("SA342 NADIR 1"),devices.NADIR,device_commands.Button_10,arg_int.NADIR_1,1,{0,1}) -- 338 arg number
elements["NADIR_2"] = default_button(_("SA342 NADIR 2"),devices.NADIR,device_commands.Button_11,arg_int.NADIR_2,1,{0,1}) -- 339 arg number
elements["NADIR_3"] = default_button(_("SA342 NADIR 3"),devices.NADIR,device_commands.Button_12,arg_int.NADIR_3,1,{0,1}) -- 340 arg number
elements["NADIR_4"] = default_button(_("SA342 NADIR 4"),devices.NADIR,device_commands.Button_13,arg_int.NADIR_4,1,{0,1}) -- 342 arg number
elements["NADIR_5"] = default_button(_("SA342 NADIR 5"),devices.NADIR,device_commands.Button_14,arg_int.NADIR_5,1,{0,1}) -- 343 arg number
elements["NADIR_6"] = default_button(_("SA342 NADIR 6"),devices.NADIR,device_commands.Button_15,arg_int.NADIR_6,1,{0,1}) -- 344 arg number
elements["NADIR_7"] = default_button(_("SA342 NADIR 7"),devices.NADIR,device_commands.Button_16,arg_int.NADIR_7,1,{0,1}) -- 346 arg number
elements["NADIR_8"] = default_button(_("SA342 NADIR 8"),devices.NADIR,device_commands.Button_17,arg_int.NADIR_8,1,{0,1}) -- 347 arg number
elements["NADIR_9"] = default_button(_("SA342 NADIR 9"),devices.NADIR,device_commands.Button_18,arg_int.NADIR_9,1,{0,1}) -- 348 arg number
elements["NADIR_POL"] = default_button(_("SA342 NADIR POL"),devices.NADIR,device_commands.Button_19,arg_int.NADIR_POL,1,{0,1}) -- 341 arg number
elements["NADIR_GEO"] = default_button(_("SA342 NADIR GEO"),devices.NADIR,device_commands.Button_20,arg_int.NADIR_GEO,1,{0,1}) -- 345 arg number
elements["NADIR_POS"] = default_button(_("SA342 NADIR POS"),devices.NADIR,device_commands.Button_21,arg_int.NADIR_POS,1,{0,1}) -- 349 arg number
elements["NADIR_GEL"] = default_button(_("SA342 NADIR GEL"),devices.NADIR,device_commands.Button_22,arg_int.NADIR_GEL,1,{0,1}) -- 350 arg number
elements["NADIR_EFF"] = default_button(_("SA342 NADIR EFF"),devices.NADIR,device_commands.Button_23,arg_int.NADIR_EFF,1,{0,1}) -- 352 arg number

-- [AM_RADIO]
elements["VHF-SQ-BAS-PTR"] = multiposition_switch_limited(_("SA342 Selector"),devices.AM_RADIO,device_commands.Button_1,arg_int.AM_Radio_Squelch_bas,4,0.33,nil,0) -- 128 arg number
elements["VHF-SQ-HAUT-PTR"] = default_axis(_("SA342 Freq decimals"), devices.AM_RADIO,device_commands.Button_2, arg_int.AM_Radio_Squelch_haut,0,0.1,true,true) -- 129 arg number
elements["VHF-FREQ-BAS-PTR"] = default_2_position_tumb(_("SA342 25/50kHz Selector"),devices.AM_RADIO, device_commands.Button_3,arg_int.AM_Radio_Freq_bas) -- 130 arg number
elements["VHF-FREQ-HAUT-PTR"] = default_axis(_("SA342 Freq dial"), devices.AM_RADIO,device_commands.Button_4, arg_int.AM_Radio_Freq_haut,0,0.1,true,true) -- 131 arg number

-- [FM_RADIO]
elements["FM-MAIN-PTR"] = multiposition_switch_limited(_("SA342 FM Main Selector"),devices.FM_RADIO,device_commands.Button_1,arg_int.FM_Radio_Main,5,0.25,nil,0) -- 272 arg number
elements["FM-CHNL-PTR"] = multiposition_switch_limited(_("SA342 FM Chnl Selector"),devices.FM_RADIO,device_commands.Button_2,arg_int.FM_Radio_Chnl,8,0.143,nil,0) -- 273 arg number
elements["FM-7-PTR"] = default_button(_("SA342 FM 7"),devices.FM_RADIO,device_commands.Button_3,arg_int.FM_Radio_7,1,{0,1}) -- 274 arg number
elements["FM-8-PTR"] = default_button(_("SA342 FM 8"),devices.FM_RADIO,device_commands.Button_4,arg_int.FM_Radio_8,1,{0,1}) -- 275 arg number
elements["FM-9-PTR"] = default_button(_("SA342 FM 9"),devices.FM_RADIO,device_commands.Button_5,arg_int.FM_Radio_9,1,{0,1}) -- 276 arg number
elements["FM-0-PTR"] = default_button(_("SA342 FM 0"),devices.FM_RADIO,device_commands.Button_6,arg_int.FM_Radio_0,1,{0,1}) -- 277 arg number
elements["FM-X-PTR"] = default_button(_("SA342 FM X"),devices.FM_RADIO,device_commands.Button_7,arg_int.FM_Radio_X,1,{0,1}) -- 278 arg number
elements["FM-4-PTR"] = default_button(_("SA342 FM 4"),devices.FM_RADIO,device_commands.Button_8,arg_int.FM_Radio_4,1,{0,1}) -- 279 arg number
elements["FM-5-PTR"] = default_button(_("SA342 FM 5"),devices.FM_RADIO,device_commands.Button_9,arg_int.FM_Radio_5,1,{0,1}) -- 280 arg number
elements["FM-6-PTR"] = default_button(_("SA342 FM 6"),devices.FM_RADIO,device_commands.Button_10,arg_int.FM_Radio_6,1,{0,1}) -- 281 arg number
-- elements["FM-RC-PTR"] = default_button(_("SA342 FM RC"),devices.FM_RADIO,device_commands.Button_11,arg_int.FM_Radio_rc,1,{0,1}) -- 282 arg number
-- elements["FM-UP-PTR"] = default_button(_("SA342 FM UP"),devices.FM_RADIO,device_commands.Button_12,arg_int.FM_Radio_up,1,{0,1}) -- 283 arg number
elements["FM-1-PTR"] = default_button(_("SA342 FM 1"),devices.FM_RADIO,device_commands.Button_13,arg_int.FM_Radio_1,1,{0,1}) -- 284 arg number
elements["FM-2-PTR"] = default_button(_("SA342 FM 2"),devices.FM_RADIO,device_commands.Button_14,arg_int.FM_Radio_2,1,{0,1}) -- 285 arg number
elements["FM-3-PTR"] = default_button(_("SA342 FM 3"),devices.FM_RADIO,device_commands.Button_15,arg_int.FM_Radio_3,1,{0,1}) -- 286 arg number
elements["FM-VAL-PTR"] = default_button(_("SA342 FM VAL"),devices.FM_RADIO,device_commands.Button_16,arg_int.FM_Radio_val,1,{0,1}) -- 287 arg number
-- elements["FM-DOWN-PTR"] = default_button(_("SA342 FM DOWN"),devices.FM_RADIO,device_commands.Button_17,arg_int.FM_Radio_down,1,{0,1}) -- 288 arg number

-- [TV]
elements["TV-INTER-PTR"] = default_2_position_tumb(_("SA342 TV On/Off"),devices.TV, device_commands.Button_1,arg_int.TV_inter) -- 124 arg number
elements["TV-LUM-PTR"] = default_axis(_("SA342 TV Contrast"), devices.TV,device_commands.Button_2, arg_int.TV_Lum,0,0.1,true,false) -- 125 arg number
elements["TV-BRT-PTR"] = default_axis(_("SA342 TV Brightness"), devices.TV,device_commands.Button_3, arg_int.TV_Brt,0,0.1,true,false) -- 123 arg number
elements["TV-CACHE-PTR"] = default_movable_axis(_("SA342 TV Cover"),devices.TV,device_commands.Button_4,arg_int.TV_Cache, 0, 0.1,true,false) -- 126 arg number

-- [RWR]
elements["RWR-ON-OFF-PTR"] = default_3_position_tumb(_("SA342 RWR On/Off Croc"),devices.RWR, device_commands.Button_1,arg_int.RWR_inter,false,nil) -- 148 arg number
elements["RWR-MARQUEUR-PTR"] = default_button(_("SA342 RWR Marker"),devices.RWR,device_commands.Button_2,arg_int.RWR_marqueur,1,{0,1}) -- 149 arg number
elements["RWR-PAGE-PTR"] = default_button(_("SA342 RWR Page"),devices.RWR,device_commands.Button_3,arg_int.RWR_page,1,{0,1}) -- 150 arg number
elements["RWR-AUDIO-PTR"] = default_axis(_("SA342 RWR Audio"), devices.RWR,device_commands.Button_4, arg_int.RWR_audio,0,0.1,true,false) -- 121 arg number
elements["RWR-BRT-PTR"] = default_axis(_("SA342 RWR Brt"), devices.RWR,device_commands.Button_5, arg_int.RWR_brt,0,0.1,true,false) -- 122 arg number

-- [HA
elements["HA-PTR"] = default_button_axis(_("SA342 HA Unlock"), devices.FLIGHT_CONTROLS,device_commands.Button_2, device_commands.Button_1, arg_int.HA_Pull, arg_int.HA_Rot, 1, 1)

-- [Stby HA]
elements["StdbyHA-PTR"] = default_button_axis(_("SA342 STDBYHA Unlock"), devices.FLIGHT_CONTROLS,device_commands.Button_4, device_commands.Button_3, arg_int.Stdby_HA_butPull, arg_int.Stdby_HA_butRot, 1, 1)

-- [ArtVisVhfDop]
elements["ArtVisVhfDop-PTR"] = multiposition_switch_limited(_("SA342 Source"),devices.FLIGHT_CONTROLS,device_commands.Button_7,arg_int.ArtVisVhfDop,4,0.33,nil,0) -- 218 arg number

-- [INTERCOM PILOT]
elements["IC1-VHF-PTR"] = default_button_axis(_("SA342 VHF AM Radio Volume"), devices.INTERCOM,device_commands.Button_21, device_commands.Button_1, arg_int.IC1_VHF_Push, arg_int.IC1_VHF, 1, 1) 
elements["IC1-FM1-PTR"] = default_button_axis(_("SA342 FM Radio Volume"), devices.INTERCOM,device_commands.Button_22, device_commands.Button_2, arg_int.IC1_FM1_Push, arg_int.IC1_FM1, 1, 1) 
elements["IC1-UHF-PTR"] = default_button_axis(_("SA342 UHF Radio Volume"), devices.INTERCOM,device_commands.Button_23, device_commands.Button_3, arg_int.IC1_UHF_Push, arg_int.IC1_UHF, 1, 1) 

-- [INTERCOM COPILOT]
elements["IC2-VHF-PTR"] = default_button_axis(_("SA342 VHF AM Radio Volume 2"), devices.INTERCOM,device_commands.Button_51, device_commands.Button_31, arg_int.IC2_VHF_Push, arg_int.IC2_VHF, 1, 1) 
elements["IC2-FM1-PTR"] = default_button_axis(_("SA342 FM Radio Volume 2"), devices.INTERCOM,device_commands.Button_52, device_commands.Button_32, arg_int.IC2_FM1_Push, arg_int.IC2_FM1, 1, 1) 
elements["IC2-UHF-PTR"] = default_button_axis(_("SA342 UHF Radio Volume 2"), devices.INTERCOM,device_commands.Button_53, device_commands.Button_33, arg_int.IC2_UHF_Push, arg_int.IC2_UHF, 1, 1) 

-- [TORQUE]
elements["TORQUE-PTR"] = default_button_axis(_("SA342 Bug/Test"), devices.TORQUE,device_commands.Button_1, device_commands.Button_2, arg_int.test_Torque, arg_int.Alert_Pourcent, 1, 1)

-- [LIGHTS]
elements["PBO-PTR"] = default_axis(_("SA342 Main Dashboard Lighting"),devices.LIGHTS, device_commands.Button_1,arg_int.Knob_PBO,0,0.1,true,false) -- 22 arg number
elements["PUP-PTR"] = default_axis(_("SA342 Console Lighting"),devices.LIGHTS, device_commands.Button_2,arg_int.Knob_PUP,0,0.1,true,false) -- 21 arg number
elements["LABELS-PTR"] = default_axis(_("SA342 UV Lighting"),devices.LIGHTS, device_commands.Button_3,arg_int.Labels_Intensity,0,0.1,true,false) -- 145 arg number
elements["INTER-BNL-PTR"] = default_2_position_tumb(_("SA342 NORM/BNL"),devices.LIGHTS, device_commands.Button_4,arg_int.Switch_BNL) -- 23 arg number
elements["KNOB-PLAFOND-PTR"] = default_axis(_("SA342 Roof Lamp Knob"),devices.LIGHTS, device_commands.Button_5,arg_int.Knob_Plafond,0,0.1,true,false) -- 147 arg number
elements["LENTILLE_PTR"] = default_2_position_tumb(_("SA342 Red Lens On/Off"),devices.LIGHTS, device_commands.Button_6,arg_int.Lum_Plafond_Lentille) -- 154 arg number

-- [ELECTRIC]
elements["BATTERIE-PTR"] = default_2_position_tumb(_("SA342 Battery"),devices.ELECTRIC, device_commands.Button_1,arg_int.inter_Batterie) -- 264 arg number
elements["ALTER-PTR"] = default_2_position_tumb(_("SA342 Alternator"),devices.ELECTRIC, device_commands.Button_2,arg_int.inter_Alter) -- 265 arg number
elements["GENE-PTR"] = default_2_position_tumb(_("SA342 Generator"),devices.ELECTRIC, device_commands.Button_3,arg_int.inter_Gene) -- 268 arg number
elements["VATEST-PTR"] = default_button(_("SA342 Voltmeter Test"),devices.ELECTRIC,device_commands.Button_4,arg_int.inter_VATEST,1,{0,1}) -- 62 arg number
elements["PITOT-PTR"] = default_2_position_tumb(_("SA342 Pitot"),devices.ELECTRIC, device_commands.Button_5,arg_int.inter_Pitot) -- 170 arg number
elements["FUEL-PUMP-FRONT-PTR"] = default_2_position_tumb(_("SA342 Fuel Pump"),devices.ELECTRIC, device_commands.Button_6,arg_int.inter_Pompe_Carburant) -- 271 arg number
elements["RSUPP-PTR"] = default_2_position_tumb(_("SA342 Additionnal Fuel Tank"),devices.ELECTRIC, device_commands.Button_7,arg_int.inter_RSupp) -- 267 arg number
elements["INTER-MA-PTR"] = default_3_position_tumb(_("SA342 Starter Start/Stop/Air"),devices.ELECTRIC, device_commands.Button_8,arg_int.inter_MA,false,nil) -- 56 arg number
elements["TEST-TA-PTR"] = default_button(_("SA342 Test"),devices.ELECTRIC,device_commands.Button_9,arg_int.test_TA,1,{0,1}) -- 57 arg number
elements["EG-COPILOTE-PTR"] = default_3_position_tumb(_("SA342 Copilot Wiper"),devices.ELECTRIC, device_commands.Button_10,arg_int.inter_EG_Copilote,false,nil) -- 48 arg number
elements["EG-PILOTE-PTR"] = default_3_position_tumb(_("SA342 Pilot Wiper"),devices.ELECTRIC, device_commands.Button_11,arg_int.inter_EG_Pilote,false,nil) -- 49 arg number
elements["SPACE-PTR"] = default_2_position_tumb(_(""),devices.ELECTRIC, device_commands.Button_12,arg_int.inter_VA) -- 61 arg number
elements["HYD-PTR"] = default_button(_("SA342 HYD Test"),devices.ELECTRIC,device_commands.Button_13,arg_int.inter_HYD,1,{0,1}) -- 59 arg number
elements["REARM-ALTER-PTR"] = default_button(_("SA342 Alter Rearm"),devices.ELECTRIC,device_commands.Button_14,arg_int.Rearm_Alter,1,{0,1}) -- 66 arg number
elements["REARM-GENE-PTR"] = default_button(_("SA342 Gene Rearm"),devices.ELECTRIC,device_commands.Button_15,arg_int.Rearm_Gene,1,{0,1}) -- 67 arg number
elements["RCONV-PTR"] = default_2_position_tumb(_("SA342 Convoy Tank On/Off"),devices.ELECTRIC, device_commands.Button_16,arg_int.inter_RCONV) -- 63 arg number
elements["FILTAS-PTR"] = default_2_position_tumb(_("SA342 Sand Filter On/Off"),devices.ELECTRIC, device_commands.Button_17,arg_int.inter_FILTAS) -- 64 arg number

-- [NAVLIGHTS]
elements["ANO-PTR"] = default_3_position_tumb(_("SA342 Navigation Lights CLI / OFF / FIX"),devices.NAVLIGHTS, device_commands.Button_1,arg_int.inter_NavLights,false,nil) -- 146 arg number
elements["FLASHER-PTR"] = default_3_position_tumb(_("SA342 Anticollision Light NOR / OFF / ATT"),devices.NAVLIGHTS, device_commands.Button_2,arg_int.inter_Strobe,false,nil) -- 228 arg number
elements["LANDING-LIGHT-PTR"] = default_3_position_tumb(_("SA342 Landing Light Off/Vario/On"),devices.NAVLIGHTS, device_commands.Button_3,arg_int.inter_Landing,false,nil) -- 105 arg number
elements["LANDING-LIGHT-EXTEND-PTR"] = default_button_tumb(_("SA342 Landing Light Extend/Retract"),devices.NAVLIGHTS, device_commands.Button_4, device_commands.Button_6,arg_int.inter_Landing_extend,2) -- 106 arg number
elements["PUPITRE-PLANCHEBORD-PTR"] = default_2_position_tumb(_("SA342 Panels Lighting On/Off"),devices.NAVLIGHTS, device_commands.Button_8,arg_int.inter_pupitre_planchebord) -- 382 arg number
elements["ANTICOLL-INTENSITY-PTR"] = default_axis(_("SA342 AntiCollision Light Intensity"),devices.NAVLIGHTS, device_commands.Button_10,arg_int.Anticollision_intensity,0,0.1,true,false) -- 30 arg number
elements["FEUX-FORMATION-INTER-PTR"] = default_2_position_tumb(_("SA342 Formation Lights On/Off"),devices.NAVLIGHTS, device_commands.Button_11,arg_int.inter_Feux_Formation) -- 229 arg number
elements["FEUX-FORMATION-INTENSITY-PTR"] = default_axis(_("SA342 Formation Lights Intensity"),devices.NAVLIGHTS, device_commands.Button_12,arg_int.Variateur_Feux_Formation,0,0.1,true,false) -- 230 arg number

-- [FLARE DISPENSER]
elements["FD-OPE-PTR"] = default_3_position_tumb(_("SA342 Flare Dispenser G/G+D/D"),devices.FD, device_commands.Button_1,arg_int.Flare_Dispenser_Pos,false,true) -- 220 arg number
elements["FD-CC-SEQ-PTR"] = default_2_position_tumb(_("SA342 Flare Dispenser Mode"),devices.FD, device_commands.Button_2,arg_int.Flare_Dispenser_CC_Seq) -- 221 arg number
elements["FD-VE-PTR"] = default_3_position_tumb(_("SA342 Flare Dispenser Off/Speed"),devices.FD, device_commands.Button_3,arg_int.Flare_Dispenser_LE_VE_AR,false,nil) -- 222 arg number
elements["FD-FIRE-BUTTON-CAP-PTR"] = default_2_position_tumb(_("SA342 Flare Dispenser Fire Button Cap"),devices.FD, device_commands.Button_4,arg_int.FD_Fire_Button_Cap) -- 194 arg number
elements["FD-FIRE-BUTTON-PTR"] = default_button(_("SA342 Flare Dispenser Fire Button"),devices.FD,device_commands.Button_5,arg_int.FD_Fire_Button,1,{0,1}) -- 195 arg number

-- [PILOTE AUTO]
elements["PA_MASTER_PTR"] = default_2_position_tumb(_("SA342 Autopilot On/Off"),devices.AUTOPILOT, device_commands.Button_1,arg_int.PA_Master) -- 31 arg number
elements["PA_TANGAGE_PTR"] = default_2_position_tumb(_("SA342 Pitch On/Off"),devices.AUTOPILOT, device_commands.Button_2,arg_int.PA_Tangage) -- 32 arg number
elements["PA_ROULIS_PTR"] = default_2_position_tumb(_("SA342 Roll On/Off"),devices.AUTOPILOT, device_commands.Button_3,arg_int.PA_Roulis) -- 33 arg number
elements["PA_LACET_PTR"] = default_2_position_tumb(_("SA342 Yaw On/Off"),devices.AUTOPILOT, device_commands.Button_4,arg_int.PA_Lacet) -- 34 arg number
elements["PA_MODE_PTR"] = default_3_position_tumb(_("SA342 Mode Speed / OFF / Altitude"),devices.AUTOPILOT, device_commands.Button_5,arg_int.PA_Mode,false,nil) -- 35 arg number
elements["TRIM-PTR"] = default_2_position_tumb(_("SA342 Trim On/Off"),devices.AUTOPILOT,device_commands.Button_6,arg_int.inter_TRIM) -- 60 arg number
elements["FMAG-PTR"] = default_2_position_tumb(_("SA342 Magnetic Brake On/Off"),devices.AUTOPILOT, device_commands.Button_7,arg_int.inter_FMAG) -- 65 arg number

-- [WEAPONS]
elements["MASTER_ARM_PTR"] = default_2_position_tumb(_("SA342 Master arm On/Off"),devices.WEAPONS, device_commands.Button_1,arg_int.inter_Master_Arm) -- 269 arg number

-- [ROTORS]
elements["FREIN-ROTOR-PTR"] = default_movable_axis(_("SA342 Rotor Brake"),devices.ROTORS,device_commands.Button_1,arg_int.Frein_Rotor, 0, 0.055,true,false) -- 556 arg number

-- RADIOALTIMETER
elements["RALT-DANGERALT-PTR"] = default_axis(_("SA342 Radar Alt Bug"), devices.RADAR_ALTIMETER,device_commands.Button_1, arg_int.Knob_RAlt_Danger,0,0.1,true,true)
elements["RALT-ONOFF-PTR"] = default_button_axis(_("SA342 On/Off - Test"),devices.RADAR_ALTIMETER, device_commands.Button_3,device_commands.Button_2, arg_int.RAlt_Test,arg_int.Knob_RAlt_OnOFF, 1, 1)

-- BAROALTIMETER
elements["BALT-PTR"] = default_axis(_("SA342 Baro pressure QFE knob"),devices.BARO_ALTIMETER, device_commands.Button_1,arg_int.Knob_BAlt_Pressure,0,0.1,true,true) -- 89 arg number

-- [FUEL_SYSTEM]
elements["MANETTE-DEBIT-PTR"] = default_movable_axis(_("SA342 Fuel Flow Lever"),devices.FUEL,device_commands.Button_1,arg_int.Manette_Debit, 0, 0.2,true,false) -- 557 arg number

-- [ADF RADIO]
elements["ADF_SELECT_PTR"] = default_2_position_tumb(_("SA342 ADF Select"),devices.ADF, device_commands.Button_1,arg_int.ADF_SELECT_PTR) -- 166 arg number
elements["ADF_TONESWITCH_PTR"] = default_2_position_tumb(_("SA342 ADF Tone"),devices.ADF, device_commands.Button_2,arg_int.ADF_TONESWITCH_PTR) -- 167 arg number
elements["ADF_MODE_PTR"] = multiposition_switch_limited(_("SA342 ADF Mode"),devices.ADF,device_commands.Button_3,arg_int.ADF_MODE_PTR,4,0.33,nil,0) -- 178 arg number
elements["ADF_GAIN_PTR"] = default_axis(_("SA342 ADF Gain"), devices.ADF,device_commands.Button_4, arg_int.ADF_GAIN_PTR,0,0.1,true,false) -- 179 arg number
elements["ADF_LLOWKNOB_PTR"] = default_axis(_("SA342 ADF Nav1 Hundred"), devices.ADF,device_commands.Button_5, arg_int.ADF_LLOWKNOB_PTR,0,0.1,true,true) -- 168 arg number
elements["ADF_LMIDKNOB_PTR"] = default_axis(_("SA342 ADF Nav1 Ten"), devices.ADF,device_commands.Button_6, arg_int.ADF_LMIDKNOB_PTR,0,0.1,true,true) -- 169 arg number
elements["ADF_LHIGHKNOB_PTR"] = default_axis(_("SA342 ADF Nav1 Unit"), devices.ADF,device_commands.Button_7, arg_int.ADF_LHIGHKNOB_PTR,0,0.1,true,true) -- 173 arg number
elements["ADF_RLOWKNOB_PTR"] = default_axis(_("SA342 ADF Nav2 Hundred"), devices.ADF,device_commands.Button_8, arg_int.ADF_RLOWKNOB_PTR,0,0.1,true,true) -- 174 arg number
elements["ADF_RMIDKNOB_PTR"] = default_axis(_("SA342 ADF Nav2 Ten"), devices.ADF,device_commands.Button_9, arg_int.ADF_RMIDKNOB_PTR,0,0.1,true,true) -- 175 arg number
elements["ADF_RHIGHKNOB_PTR"] = default_axis(_("SA342 ADF Nav2 Unit"), devices.ADF,device_commands.Button_10, arg_int.ADF_RHIGHKNOB_PTR,0,0.1,true,true) -- 176 arg number

-- [UHF RADIO]
elements["UHF_KNOB"] = multiposition_switch_limited(_("SA342 UHF MODE"),devices.UHF_RADIO,device_commands.Button_1,arg_int.UHF_KNOB,7,0.167,nil,0) -- 383 arg number
--elements["UHF_DRW"] = default_button(_("SA342 UHF DRW"),devices.UHF_RADIO,device_commands.Button_2,arg_int.UHF_DRW,1,{0,1}) -- 384 arg number
elements["UHF_VLD"] = default_button(_("SA342 UHF VLD"),devices.UHF_RADIO,device_commands.Button_3,arg_int.UHF_VLD,1,{0,1}) -- 385 arg number
--elements["UHF_RIGHT_KNOB"] = default_axis(_("SA342 UHF PAGE"), devices.UHF_RADIO,device_commands.Button_4, arg_int.UHF_RIGHT_KNOB,0,0.1,true,true) -- 386 arg number
--elements["UHF_CONF"] = default_button(_("SA342 UHF CONF"),devices.UHF_RADIO,device_commands.Button_5,arg_int.UHF_CONF,1,{0,1}) -- 387 arg number
elements["UHF_1"] = default_button(_("SA342 UHF 1"),devices.UHF_RADIO,device_commands.Button_6,arg_int.UHF_1,1,{0,1}) -- 388 arg number
elements["UHF_2"] = default_button(_("SA342 UHF 2"),devices.UHF_RADIO,device_commands.Button_7,arg_int.UHF_2,1,{0,1}) -- 389 arg number
elements["UHF_3"] = default_button(_("SA342 UHF 3"),devices.UHF_RADIO,device_commands.Button_8,arg_int.UHF_3,1,{0,1}) -- 390 arg number
elements["UHF_4"] = default_button(_("SA342 UHF 4"),devices.UHF_RADIO,device_commands.Button_9,arg_int.UHF_4,1,{0,1}) -- 391 arg number
elements["UHF_5"] = default_button(_("SA342 UHF 5"),devices.UHF_RADIO,device_commands.Button_10,arg_int.UHF_5,1,{0,1}) -- 392 arg number
elements["UHF_6"] = default_button(_("SA342 UHF 6"),devices.UHF_RADIO,device_commands.Button_11,arg_int.UHF_6,1,{0,1}) -- 393 arg number
elements["UHF_7"] = default_button(_("SA342 UHF 7"),devices.UHF_RADIO,device_commands.Button_12,arg_int.UHF_7,1,{0,1}) -- 394 arg number
elements["UHF_8"] = default_button(_("SA342 UHF 8"),devices.UHF_RADIO,device_commands.Button_13,arg_int.UHF_8,1,{0,1}) -- 395 arg number
elements["UHF_9"] = default_button(_("SA342 UHF 9"),devices.UHF_RADIO,device_commands.Button_14,arg_int.UHF_9,1,{0,1}) -- 396 arg number
elements["UHF_0"] = default_button(_("SA342 UHF 0"),devices.UHF_RADIO,device_commands.Button_15,arg_int.UHF_0,1,{0,1}) -- 397 arg number


for i,o in pairs(elements) do
	if  o.class[1] == class_type.TUMB or 
	   (o.class[2]  and o.class[2] == class_type.TUMB) or
	   (o.class[3]  and o.class[3] == class_type.TUMB)  then
	   o.updatable = true
	   o.use_OBB   = true
	end
end