$modelname "cszm/weapons/v_antidote.mdl"

$bodygroup "studio"
{
	studio "v_antidote_ref.smd"
}

$origin 0 0.75 0

$include "sharedbones.qci"

$cdmaterials "models/items/"
$cdmaterials "models/cszm/v_antidote/"

$surfaceprop "default"

$contents "solid"

$sequence "idle" "anims/idle.smd" {
	fps 10
	activity "ACT_VM_IDLE" 1
	loop
	snap
}

$sequence "draw" "anims/draw.smd" {
	fps 35
	activity "ACT_VM_DRAW" 1
	snap

	{ event AE_CL_PLAYSOUND 9 "Weapon_Inoculator.Draw" }
//	{ event AE_CL_PLAYSOUND 1 "Weapon_Glock.Draw" }
}

$sequence "holster" "anims/holster.smd" {
	fps 40
	activity "ACT_VM_HOLSTER" 1
	snap

	{ event AE_CL_PLAYSOUND 2 "Weapon_Inoculator.Holster" }
}

$sequence "shot" "anims/fire.smd" {
	fps 30
	activity "ACT_VM_PRIMARYATTACK" 1
	snap
	
	{ event 800 15 }
	{ event AE_CL_PLAYSOUND 15 "Weapon_Inoculator.Inject" }
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
