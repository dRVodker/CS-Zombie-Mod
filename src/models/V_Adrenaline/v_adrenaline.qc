$modelname "cszm/weapons/v_adrenaline.mdl"

$bodygroup "studio"
{
	studio "v_adrenaline_ref.smd"
}

$origin 0 2.5 0

$include "sharedbones.qci"

$cdmaterials "models/cszm/v_adrenaline/"

$surfaceprop "default"

$contents "solid"

$sequence "idle" "anims/idle.smd" {
	fps 20
	activity "ACT_VM_IDLE" 1
	loop
	snap
}

$sequence "draw" "anims/draw.smd" {
	fps 35
	activity "ACT_VM_DRAW" 1
	snap

	{ event AE_CL_PLAYSOUND 1 "Weapon_Glock.Draw" }
}

$sequence "shot" "anims/fire.smd" {
	fps 55
	activity "ACT_VM_PRIMARYATTACK" 1
	snap
	
	{ event 800 53 }
	{ event AE_CL_PLAYSOUND 32 "Adrenaline.CapOff" }
	{ event AE_CL_PLAYSOUND 38 "Adrenaline.NeedleOpen" }
	{ event AE_CL_PLAYSOUND 53 "Adrenaline.NeedleIn" }
}

$sequence "holster" "anims/holster.smd" {
	fps 35
	activity "ACT_VM_HOLSTER" 1
	snap
}

$sequence "interact_use" "anims/use.smd" {
	fps 35
	activity "ACT_VM_INTERACT_USE" 1
	snap
}

$sequence "interact_grab" "anims/grab.smd" {
	fps 35
	activity "ACT_VM_INTERACT_GRAB" 1
	snap
}
