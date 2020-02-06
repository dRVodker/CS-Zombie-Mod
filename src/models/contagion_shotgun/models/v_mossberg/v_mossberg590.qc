$modelname "weapons/custom/v_mossberg.mdl"

$origin 1.105 3.875 0.75

$bodygroup "mossberg590"
{
	studio "mossberg590_reference.smd"
}
$bodygroup "shell"
{
	studio "shell_reference.smd"
}

$surfaceprop "default"

$contents "solid"

$illumposition 3.7 -7.496 -12.798

$cdmaterials "models/weapons/custom/v_mossberg/"

$attachment "muzzle" "ValveBiped.muzzle" 0 0 0 rotate 0 0 0
$attachment "1" "ValveBiped.eject" -0.5 0 0 rotate 30 0 0
//$attachment "shell" "ValveBiped.eject" -0.5 0 0 rotate 30 0 0
//$attachment "flashlight" "ValveBiped.muzzle" -5.1 0 -2.8 rotate 0 0 0
//$attachment "camera" "Contagion.ViewReload" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -17.552 -16.624 -29.702 32.544 24.024 4.105

$definebone "weapon controller" "" -5.795844 -9.1367 -4.023108 0 89.999982 89.999982 0 0 0 0 0 0
$definebone "mossberg590" "weapon controller" 4.081459 -0.23035 0 -89.999982 -89.999982 0 0 0 0 0 0 0
$definebone "bolt" "mossberg590" -0.331989 -6.192928 0.571594 0 0 0 0 0 0 0 0 0
$definebone "trigger" "mossberg590" 0.0057 -1.812722 -1.27483 0 0 0 0 0 0 0 0 0
$definebone "safty" "mossberg590" -0.003708 -0.569412 0.991848 0 0 -20.331467 0 0 0 0 0 0
$definebone "pump" "mossberg590" -0.016619 -15.283115 -0.523075 0 0 0 0 0 0 0 0 0
$definebone "pump_flash" "pump" 0 0.130543 0.025136 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.muzzle" "weapon controller" -24.452829 0.488931 -0.014538 0 -179.999978 89.999982 0 0 0 0 0 0
$definebone "ValveBiped.eject" "weapon controller" -2.108918 0.420616 -0.360206 78.603907 103.140767 15.132617 0 0 0 0 0 0
$definebone "Spine" "" 0 0.005067 -20.92145 -89.95575 179.999909 0 0 0 0 0 0 0
$definebone "Spine1" "Spine" 6.363438 -0.004087 0.002996 0.026986 -0.054431 -36.245082 0 0 0 0 0 0
$definebone "Neck" "Spine1" 6.36344 -0.002058 0 0 0 -0.000002 0 0 0 0 0 0
$definebone "L Clavicle" "Neck" 0.000002 0.002054 1.508082 -46.340136 69.469697 105.123769 0 0 0 0 0 0
$definebone "L UpperArm" "L Clavicle" 5.853648 0 0.000001 46.822794 -19.245308 -59.648226 0 0 0 0 0 0
$definebone "L Forearm" "L UpperArm" 9.221988 0.000001 -0.000001 -0.000003 -79.410409 -0.000001 0 0 0 0 0 0
$definebone "L Hand" "L Forearm" 8.525421 0 0 10.386062 22.658645 142.02306 0 0 0 0 0 0
$definebone "L Finger0" "L Hand" 1.316958 0.232856 -0.887509 9.09857 34.256404 118.393529 0 0 0 0 0 0
$definebone "L Finger01" "L Finger0" 1.569124 0 0 0.000002 -1.58847 0 0 0 0 0 0 0
$definebone "L Finger02" "L Finger01" 1.263928 0.000001 -0.000002 0.000002 -4.99333 0.000001 0 0 0 0 0 0
$definebone "L Finger1" "L Hand" 4.303119 -0.549164 -1.396965 -26.159134 -2.7946 2.961331 0 0 0 0 0 0
$definebone "L Finger11" "L Finger1" 1.775323 0.000001 0.000002 0.000002 67.19506 0.000002 0 0 0 0 0 0
$definebone "L Finger12" "L Finger11" 0.890209 -0.000001 0 0.000002 32.863257 0.000002 0 0 0 0 0 0
$definebone "L Finger2" "L Hand" 4.298709 -0.99995 -0.333787 -18.376014 37.057021 -18.750961 0 0 0 0 0 0
$definebone "L Finger21" "L Finger2" 1.881734 0 -0.000002 0 63.611089 0.000002 0 0 0 0 0 0
$definebone "L Finger22" "L Finger21" 0.99889 -0.000001 0.000002 0.000059 15.158401 0 0 0 0 0 0 0
$definebone "L Finger3" "L Hand" 3.950133 -0.942986 0.812745 1.003193 49.762016 -28.667714 0 0 0 0 0 0
$definebone "L Finger31" "L Finger3" 1.876992 0.000001 0.000002 -0.000001 39.949589 0.000002 0 0 0 0 0 0
$definebone "L Finger32" "L Finger31" 1.002013 0.000002 0 -0.000002 12.12974 0.000002 0 0 0 0 0 0
$definebone "L Finger4" "L Hand" 3.482875 -0.57292 1.763047 5.939454 41.885165 -33.061391 0 0 0 0 0 0
$definebone "L Finger41" "L Finger4" 1.367765 0.000001 0.000002 -0.000003 44.201402 0 0 0 0 0 0 0
$definebone "L Finger42" "L Finger41" 0.725977 0.000001 0.000002 -0.000002 -17.665147 0.000002 0 0 0 0 0 0
$definebone "L ForeTwist" "L UpperArm" 9.221988 0.000001 -0.000001 -0.000003 -79.410409 -16.095529 0 0 0 0 0 0
$definebone "L ForeTwist1" "L ForeTwist" 1.217917 0.000002 0 -0.000003 0.000001 -16.095529 0 0 0 0 0 0
$definebone "L ForeTwist2" "L ForeTwist1" 1.217918 0 0 -0.000003 -0.000002 -16.095527 0 0 0 0 0 0
$definebone "L ForeTwist3" "L ForeTwist2" 1.217917 0.000001 0 -0.000002 0 -16.095527 0 0 0 0 0 0
$definebone "L ForeTwist4" "L ForeTwist3" 1.217918 0 0 -0.000003 0 -16.095529 0 0 0 0 0 0
$definebone "L ForeTwist5" "L ForeTwist4" 1.217917 -0.000001 0 -0.000002 0 -16.095525 0 0 0 0 0 0
$definebone "L ForeTwist6" "L ForeTwist5" 1.217917 -0.000001 -0.000002 0 -0.000003 -16.095522 0 0 0 0 0 0
$definebone "L Cuff" "L ForeTwist" 7.622455 -0.033171 0.183294 -2.131571 94.859696 -0.352833 0 0 0 0 0 0
$definebone "R Clavicle" "Neck" 0.000002 0.002063 -1.508082 37.030256 -55.477566 112.53654 0 0 0 0 0 0
$definebone "R UpperArm" "R Clavicle" 5.853648 0 -0.000001 -8.146313 -84.190203 40.910736 0 0 0 0 0 0
$definebone "R Forearm" "R UpperArm" 9.221992 0 0.000001 0 -125.287663 0 0 0 0 0 0 0
$definebone "R Hand" "R Forearm" 8.525423 -0.000002 0 -36.556197 36.124362 168.896207 0 0 0 0 0 0
$definebone "R Finger0" "R Hand" 1.316959 0.232854 0.887511 -21.526825 45.598568 -113.816408 0 0 0 0 0 0
$definebone "R Finger01" "R Finger0" 1.569123 0 0 -0.000007 38.58423 -0.000007 0 0 0 0 0 0
$definebone "R Finger02" "R Finger01" 1.26393 0 0 0.000002 58.892049 -0.00001 0 0 0 0 0 0
$definebone "R Finger1" "R Hand" 4.303116 -0.549163 1.396964 6.602996 12.418515 -5.762808 0 0 0 0 0 0
$definebone "R Finger11" "R Finger1" 1.775324 0 -0.000001 -0.000002 27.583903 0.000001 0 0 0 0 0 0
$definebone "R Finger12" "R Finger11" 0.890209 -0.000001 0 -0.000003 47.826511 0.000002 0 0 0 0 0 0
$definebone "R Finger2" "R Hand" 4.298708 -0.999951 0.333787 4.635112 91.740683 1.599187 0 0 0 0 0 0
$definebone "R Finger21" "R Finger2" 1.881733 0 -0.000001 -0.000003 39.432147 0.000002 0 0 0 0 0 0
$definebone "R Finger22" "R Finger21" 0.998891 -0.000001 0 -0.000003 51.148056 -0.000002 0 0 0 0 0 0
$definebone "R Finger3" "R Hand" 3.950135 -0.942986 -0.812747 -10.56964 93.781626 5.26663 0 0 0 0 0 0
$definebone "R Finger31" "R Finger3" 1.87699 0.000001 0 -0.000003 40.649464 0.000001 0 0 0 0 0 0
$definebone "R Finger32" "R Finger31" 1.002013 -0.000001 0 -0.000002 44.703598 -0.000001 0 0 0 0 0 0
$definebone "R Finger4" "R Hand" 3.482875 -0.57292 -1.763048 -20.865801 78.401201 16.281115 0 0 0 0 0 0
$definebone "R Finger41" "R Finger4" 1.367766 0 -0.000001 0.000003 27.406283 0.000006 0 0 0 0 0 0
$definebone "R Finger42" "R Finger41" 0.725976 0 0 -0.000002 50.517626 0.000005 0 0 0 0 0 0
$definebone "R ForeTwist" "R UpperArm" 9.221992 0 0.000001 0 -125.287663 12.935499 0 0 0 0 0 0
$definebone "R ForeTwist1" "R ForeTwist" 1.217917 0 0 -0.000001 -0.000007 12.935495 0 0 0 0 0 0
$definebone "R ForeTwist2" "R ForeTwist1" 1.217916 -0.000001 0 -0.000003 -0.000002 12.935489 0 0 0 0 0 0
$definebone "R ForeTwist3" "R ForeTwist2" 1.217918 0 0.000001 -0.000002 0 12.93549 0 0 0 0 0 0
$definebone "R ForeTwist4" "R ForeTwist3" 1.217918 0 0 -0.000002 0.000001 12.93549 0 0 0 0 0 0
$definebone "R ForeTwist5" "R ForeTwist4" 1.217917 0 0 -0.000002 0 12.935489 0 0 0 0 0 0
$definebone "R ForeTwist6" "R ForeTwist5" 1.217918 0 0 -0.000002 -0.000001 12.935495 0 0 0 0 0 0
$definebone "R Cuff" "R ForeTwist" 7.560967 -0.009612 -0.200776 -2.751574 -85.294904 179.196857 0 0 0 0 0 0
$definebone "Contagion.ViewReload" "" 0 6 0 0 -89.999982 0 0 0 0 0 0 0
$definebone "shell01" "" 0 9.468495 -28.179134 0 0 0 0 0 0 0 0 0
$definebone "shell02" "" 0 13.134872 -28.219837 0 0 0 0 0 0 0 0 0

$bonemerge "Spine"
$bonemerge "Spine1"
$bonemerge "Neck"
$bonemerge "L Clavicle"
$bonemerge "L UpperArm"
$bonemerge "L Forearm"
$bonemerge "L Hand"
$bonemerge "L Finger0"
$bonemerge "L Finger01"
$bonemerge "L Finger02"
$bonemerge "L Finger1"
$bonemerge "L Finger11"
$bonemerge "L Finger12"
$bonemerge "L Finger2"
$bonemerge "L Finger21"
$bonemerge "L Finger22"
$bonemerge "L Finger3"
$bonemerge "L Finger31"
$bonemerge "L Finger32"
$bonemerge "L Finger4"
$bonemerge "L Finger41"
$bonemerge "L Finger42"
$bonemerge "L ForeTwist"
$bonemerge "L ForeTwist1"
$bonemerge "L ForeTwist2"
$bonemerge "L ForeTwist3"
$bonemerge "L ForeTwist4"
$bonemerge "L ForeTwist5"
$bonemerge "L ForeTwist6"
$bonemerge "L Cuff"
$bonemerge "R Clavicle"
$bonemerge "R UpperArm"
$bonemerge "R Forearm"
$bonemerge "R Hand"
$bonemerge "R Finger0"
$bonemerge "R Finger01"
$bonemerge "R Finger02"
$bonemerge "R Finger1"
$bonemerge "R Finger11"
$bonemerge "R Finger12"
$bonemerge "R Finger2"
$bonemerge "R Finger21"
$bonemerge "R Finger22"
$bonemerge "R Finger3"
$bonemerge "R Finger31"
$bonemerge "R Finger32"
$bonemerge "R Finger4"
$bonemerge "R Finger41"
$bonemerge "R Finger42"
$bonemerge "R ForeTwist"
$bonemerge "R ForeTwist1"
$bonemerge "R ForeTwist2"
$bonemerge "R ForeTwist3"
$bonemerge "R ForeTwist4"
$bonemerge "R ForeTwist5"
$bonemerge "R ForeTwist6"
$bonemerge "R Cuff"

$sequence "idle" {
	"v_mossberg590_anims/a_idle.smd"
	fps 27
	activity "ACT_VM_IDLE" 1
	loop
	fadein 0.0
	fadeout 0.0
	node "0"
}

$sequence "draw" {
	"v_mossberg590_anims/draw.smd"
	activity "ACT_VM_DRAW" -1
	fadein 0.0
	fadeout 0.0
	snap
	fps 35
	
	{ event AE_CL_PLAYSOUND 0 "Weapon_870.Draw" }
	{ event AE_CL_PLAYSOUND 10 "Weapon_M4.Slap" }
}

$sequence "holster" {
	"v_mossberg590_anims/holster_fixed.smd"
	activity "ACT_VM_HOLSTER" -1
	fadein 0.5
	fadeout 0.5
	fps 35
}

$sequence "dryfire" {
	"v_mossberg590_anims/fire_empty.smd"
	activity "ACT_VM_DRYFIRE" -1
	fadein 0.0
	fadeout 0.0
	node "2"
	fps 45
}

$sequence "fire01" {
	"v_mossberg590_anims/fire01.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	{ event AE_MUZZLEFLASH 0 "SHOTGUN MUZZLE" }
	fadein 0.0
	fadeout 0.0
	node "2"
	snap
	fps 50
}

$sequence "fire02" {
	"v_mossberg590_anims/fire02.smd"
	activity "ACT_VM_PRIMARYATTACK" 2
	{ event AE_MUZZLEFLASH 0 "SHOTGUN MUZZLE" }
	fadein 0.0
	fadeout 0.0
	node "2"
	snap
	fps 50
}

$sequence "fire03" {
	"v_mossberg590_anims/fire03.smd"
	activity "ACT_VM_PRIMARYATTACK" 3
	{ event AE_MUZZLEFLASH 0 "SHOTGUN MUZZLE" }
	fadein 0.0
	fadeout 0.0
	node "2"
	snap
	fps 50
}

$sequence "pump01" {
	"v_mossberg590_anims/pump01.smd"
	activity "ACT_VM_SINGLEACTION_PUMP" 1
	{ event 6001 12 "2" }
	{ event AE_CL_PLAYSOUND 9 "Weapon_870.Pump" }
	fadein 0.0
	fadeout 0.0
	fps 37
}

$sequence "pump02" {
	"v_mossberg590_anims/pump02.smd"
	activity "ACT_VM_SINGLEACTION_PUMP" 2
	{ event 6001 12 "2" }
	{ event AE_CL_PLAYSOUND 9 "Weapon_870.Pump" }
	fadein 0.0
	fadeout 0.0
	fps 37
}

$sequence "pump03" {
	"v_mossberg590_anims/pump03.smd"
	activity "ACT_VM_SINGLEACTION_PUMP" 3
	{ event 6001 12 "2" }
	{ event AE_CL_PLAYSOUND 9 "Weapon_870.Pump" }
	fadein 0.0
	fadeout 0.0
	fps 37
}

$sequence "reload_start" {
	"v_mossberg590_anims/reload_start.smd"
	activity "ACT_VM_RELOAD_START" -1
	fadein 0.0
	fadeout 0.0
	fps 40
	{ event AE_CL_PLAYSOUND 1 "Weapon_870.Reload_Start" }
}

$sequence "reload_loop" {
	"v_mossberg590_anims/reload_loop_fixed.smd"
	activity "ACT_VM_RELOAD" -1
	fadein 0.0
	fadeout 0.0
	fps 44
	loop
	
	{ event AE_CL_PLAYSOUND 4 "Weapon_870.Reload" }
}

$sequence "reload_end" {
	"v_mossberg590_anims/reload_end.smd"
	activity "ACT_VM_RELOAD_FINISH" -1
	fadein 0.0
	fadeout 0.0
	transition "Reloading" "Idle"
	fps 42
	
	{ event AE_CL_PLAYSOUND 0 "Weapon_870.Reload_Finish" }
}

$sequence "unload_start" {
	"v_mossberg590_anims/unload_start.smd"
	activity "ACT_VM_UNLOAD_START" -1
	fadein 0.0
	fadeout 0.0
	fps 32
	
	{ event AE_CL_PLAYSOUND 1 "Weapon_870.Reload_Start" }
}

$sequence "unload_loop" {
	"v_mossberg590_anims/unload_loop.smd"
	activity "ACT_VM_UNLOAD" -1
	fadein 0.0
	fadeout 0.0
	fps 37
	loop
	
	{ event AE_CL_PLAYSOUND 3 "Weapon_870.Pump" }
}

$sequence "unload_end" {
	"v_mossberg590_anims/unload_end.smd"
	activity "ACT_VM_UNLOAD_FINISH" -1
	fadein 0.0
	fadeout 0.0
	fps 39
	
	{ event AE_CL_PLAYSOUND 3 "Weapon_870.Pump" }
	{ event AE_CL_PLAYSOUND 18 "Weapon_870.Reload_Finish" }
}

$sequence "interact_use" {
	"v_mossberg590_anims/use.smd"
	activity "ACT_VM_INTERACT_USE" -1
	fadein 0.2
	fadeout 0.2
	fps 32
}

$sequence "interact_grab" {
	"v_mossberg590_anims/use_item.smd"
	activity "ACT_VM_INTERACT_GRAB" -1
	fadein 0.0
	fadeout 0.0
	fps 32
}
