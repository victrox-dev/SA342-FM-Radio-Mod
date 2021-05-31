dofile(LockOn_Options.script_path.."Radio/Indicator/FM/definitions.lua")

local FM_Freq 			= CreateElement "ceStringPoly"
FM_Freq.name			= "FM_Freq"
FM_Freq.material		= "font_FM"
FM_Freq.init_pos		= {posleftx, 0, 0}
FM_Freq.alignment		= "LeftCenter"
FM_Freq.stringdefs		= fm_strdef
FM_Freq.element_params	= {"FM_Freq_vis","New_FM"} -- Modified
FM_Freq.formats			= {"%.3f"}
FM_Freq.controllers		= {{"opacity_using_parameter",0},{"text_using_parameter",1,0}}
FM_Freq.collimated		= false
FM_Freq.additive_alpha	= false
FM_Freq.use_mipfilter	= true
FM_Freq.isdraw			= true	
FM_Freq.h_clip_relation	= h_clip_relations.COMPARE
FM_Freq.level			= DEFAULT_LEVEL
Add(FM_Freq)