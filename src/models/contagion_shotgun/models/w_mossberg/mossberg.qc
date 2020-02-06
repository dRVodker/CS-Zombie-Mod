$modelname "weapons/custom/w_mossberg.mdl"

$bodygroup "studio"
{
	studio "gun.smd"
}

$lod 10
{
	replacemodel "gun.smd" "lod1.smd"
	nofacial
}
$lod 20
{
	replacemodel "gun.smd" "lod2.smd"
	nofacial
}
$shadowlod
{
	replacemodel "gun.smd" "lod3.smd"
	nofacial
}

$surfaceprop "weapon"

$contents "solid"

$cdmaterials "models/weapons/custom/w_mossberg/"

$attachment "muzzle" "muzzle" 0 0 0 rotate 0 0 0
$attachment "1" "1" 0 0 0 rotate 0 0 0

$sequence "idle" {
	"anim.smd"
	activity "ACT_VM_IDLE" -1
	fps 30
	loop
}

$sequence "attack1" {
	"anim.smd"
	activity "ACT_ZP_ATTACK" -1
	{ event AE_NPC_MUZZLEFLASH 0 "SHOTGUN MUZZLE" }
	{ event 3004 0 "" }
	fps 5
}

$sequence "pump" {
	"anim.smd"
	activity "ACT_ZP_PUMP" -1
	{ event 6001 3 "2" }
	fps 5
}

$collisionmodel "collison_mesh.smd"
{
	$mass 25
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 2
}
