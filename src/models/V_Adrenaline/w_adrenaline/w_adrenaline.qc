$modelname "cszm/weapons/w_adrenaline.mdl"

$bodygroup "adrenaline"
{
	studio "w_adrenaline_ref.smd"
}

$surfaceprop "item"

$cdmaterials "models/cszm/v_adrenaline/"

$sequence "idle" {
	"w_adrenaline_ref.smd"
	activity "ACT_IDLE" -1
	fadein 0.2
	fadeout 0.2
	fps 1
}

$collisionmodel "w_adrenaline_phys.smd"
{
	$mass 5
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 4

}

$KeyValues
{
	prop_data 
	{
		"base" "item.small"
		"health" "0"
		"physicsmode" "0"
		"dmg.bullets" "0.0"
		"dmg.club" "0.0"
		"dmg.explosive" "0.0"
		"explosive_radius" "0"
		"explosive_damage" "0.0"
	}
}
