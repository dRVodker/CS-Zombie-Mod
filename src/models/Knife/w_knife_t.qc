$modelname "cszm/weapons/w_knife_t.mdl"

$bodygroup "studio"
{
	studio "w_knife_t.smd"
}

$surfaceprop "machete"

$cdmaterials "models/cszm/"

$definebone "ValveBiped" "" 0 0 0 0 0 89.999983 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped" -1.514792 -2.172297 0.054295 -83.213582 52.036029 32.893795 0 0 0 0 0 0

$sequence "idle" {
	"w_knife_t.smd"
	fps 30
}

$collisionmodel "w_knife_t_physics.smd"
{
	$mass 10
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}

$keyvalues
{
	prop_data 
	{
		"base"		"Metal.Small"
	}
}
