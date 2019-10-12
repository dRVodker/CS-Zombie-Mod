// Created by Crowbar 0.55

$modelname "cszm/weapons/w_minefrag.mdl"

$bodygroup "FMine"
{
	studio "w_minefrag.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 0 3

$cdmaterials "models/cszm/w_minefrag/"

$texturegroup "skinfamilies"
{
	{ "minefrag_off" }
	{ "minefrag_on"  }
}

$attachment "Light" "Bone.Light" 0 0 0 rotate 0 0 0

$bbox -8 -8 -2 8 8 6

$definebone "Bone.Base" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "Bone.Base" -6.618361 1.249725 3.705473 65.791887 -61.055526 -140.916844 0 0 0 0 0 0
$definebone "Bone.Light" "ValveBiped.Bip01_R_Hand" 3.035806 -6.556957 -1.256691 12.06767 101.70858 -108.995115 0 0 0 0 0 0
$definebone "Bone.FMine" "ValveBiped.Bip01_R_Hand" 3.663552 -5.957757 0.891846 12.06767 101.70858 -108.995183 0 0 0 0 0 0


$sequence "idle" {
	"w_minefrag.smd"
	activity "ACT_VM_IDLE" -1
	fps 30
}

$collisionmodel "w_minefrag_physics.smd"
{
	$mass 60
	$inertia 1
	$damping 0.175
	$rotdamping 0.175
	$rootbone " "
	$concave
	$maxconvexpieces 2
	
}

$KeyValues
{
	prop_data 
	{
		"base" "Metal.Small"
		"health" "0"
	}
}
