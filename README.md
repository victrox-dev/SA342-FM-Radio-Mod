# SA342 FM Radio Mod
 This modification to the FM radio enables the use of all the buttons and functions similar to that of the UHF radio

 Within your DCS main install directory, make a backup copy of the SA342 aircraft Cockpit folder. You will want this in-case you desire to revert the aircraft to its original state, or if something goes wrong during installation.
 E.g.: C:\Programs\DCS World OpenBeta\Mods\aircraft\SA342\Cockpit

 Following the backup of your Cockpit folder, go up one directory "..\SA342". Drag and drop the "Cockpit" folder included with this install into that folder in order to overwrite existing SA342 files.

 Under DCS Saved Games directory, drag and drop the "Mods" folder included with this installation.
 E.g.: C:\Users\YourUsername\Saved Games\DCS.openbeta

 Next, under the same DCS Saved Games directory, look in the "Scripts" folder. If you already have an "Export.lua" file, open it and append the one line of code from this install's "Export.lua" to the end of your existing Export.lua file. If you don't have an Export.lua file already, you may drag and drop this install's version into your DCS Saved Games\Scripts folder.

 Following these steps, the next time you load DCS the mod will be fully functional. It will interface with SRS correctly, but you may experience frequency jumps when quickly changing presets using the knob. This will have a short-term effect and endup settling on the proper frequency for the selected preset.