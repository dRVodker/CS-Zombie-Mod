void CacheModels()
{   
    //ZM Antidote Model
     Engine.PrecacheFile(model, "models/healthvial.mdl");

    //ZM Player Models
    Engine.PrecacheFile(model, "models/cszm/carrier.mdl");
    Engine.PrecacheFile(model, "models/cszm/zombie_classic.mdl");
    Engine.PrecacheFile(model, "models/cszm/zombie_sci.mdl");
    Engine.PrecacheFile(model, "models/cszm/zombie_corpse1.mdl");
    Engine.PrecacheFile(model, "models/cszm/zombie_charple.mdl");
    Engine.PrecacheFile(model, "models/cszm/zombie_charple2.mdl");
    Engine.PrecacheFile(model, "models/cszm/zombie_sawyer.mdl");
    Engine.PrecacheFile(model, "models/cszm/zombie_eugene.mdl");

    //ZM First Infected Model
    Engine.PrecacheFile(model, "models/cszm/zombie_corpse2.mdl");
    
    //ZM Lobby Guy Model
    Engine.PrecacheFile(model, "models/cszm/lobby_guy.mdl");
    
    //ZM Knife Model
    Engine.PrecacheFile(model, "models/cszm/weapons/w_knife_t.mdl");

    //ZM CSS Arms
    Engine.PrecacheFile(model, "models/cszm/weapons/c_cszm_arms.mdl");
    Engine.PrecacheFile(model, "models/cszm/weapons/c_cszm_zombie_arms.mdl");
}

void CacheSounds()
{
    //Antidote PickUp sound
    Engine.PrecacheFile(sound, "items/smallmedkit1.wav");

    //Various item_adrenaline related sounds
    Engine.PrecacheFile(sound, "cszm_fx/weapons/adrenaline_cap_off.wav");
	Engine.PrecacheFile(sound, "cszm_fx/weapons/adrenaline_needle_open.wav");
	Engine.PrecacheFile(sound, "cszm_fx/weapons/adrenaline_needle_in.wav");

    //Deny Choose/Spawn sound
    Engine.PrecacheFile(sound, "common/wpn_denyselect.wav");

    //Boom HeadShot sound
    Engine.PrecacheFile(sound, ")impacts/flesh_impact_headshot-01.wav");
	
	//Item Respawn sound
    Engine.PrecacheFile(sound, "items/suitchargeok1.wav");
	
	//ZM Leave Warning sound
    Engine.PrecacheFile(sound, "common/warning.wav");
    
    //ZM First Turn sound
    Engine.PrecacheFile(sound, "@cszm_fx/misc/suspense.wav");
    
    //ZM WarmUp End sound
    Engine.PrecacheFile(sound, "@buttons/button3.wav");
    
    //ZM Countdown sounds
    Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv10.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv9.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv8.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv7.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv6.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv5.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv4.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv3.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv2.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/fvox/fv1.wav");
    
    //ZM Turn sounds
    Engine.PrecacheFile(sound, "cszm_fx/player/plr_scream1.wav");
    Engine.PrecacheFile(sound, "cszm_fx/player/plr_scream2.wav");
    
    //ZM Die sounds
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_die1.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_die2.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_die3.wav");
    
    //ZM Pain sounds
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain1.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain2.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain3.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain4.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain5.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_pain6.wav");
    
    //ZM Idle sounds
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle1.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle2.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle3.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle4.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle5.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle6.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle7.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle8.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle9.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle10.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle11.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle12.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle13.wav");
    Engine.PrecacheFile(sound, ")npc/zombie/zombie_voice_idle14.wav");
    
    //ZM Pain2 sounds
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/pain_01.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/pain_02.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/pain_03.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/pain_04.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/pain_05.wav");

    //ZM Die2 sounds
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/die_01.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/die_02.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/die_03.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/die_04.wav");
    
    //ZM Idle2 sounds
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_01.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_02.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_03.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_04.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_05.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_06.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_07.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_08.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie/idle_09.wav");
    
    //ZM Pain3 sounds
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_pain01.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_pain02.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_pain03.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_pain04.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_pain05.wav");
    
    //ZM Die3 sounds
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_death01.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_death02.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_death03.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_death04.wav");
    
    //ZM Idle3 sounds
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle03.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle04.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle05.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle06.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle07.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle08.wav");
    Engine.PrecacheFile(sound, ")cszm_fx/zombie_d3/zombie_idle09.wav");

    //ZM Radio sounds
    Engine.PrecacheFile(sound, "@cszm_fx/radio/gogogo.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/radio/moveout.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/radio/letsgo.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/radio/locknload.wav");
    
    //ZM Win sounds
    Engine.PrecacheFile(sound, "@cszm_fx/misc/hwin.wav");
    Engine.PrecacheFile(sound, "@cszm_fx/misc/zwin.wav");
    
    //ZM Weapon Impact sounds	
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard1.wav");
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard2.wav");
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard3.wav");		
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft1.wav");
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft2.wav");
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft3.wav");	
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard1.wav");
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard2.wav");
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_hard3.wav");	
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft1.wav");
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft2.wav");
    Engine.PrecacheFile(sound, "physics/metal/weapon_impact_soft3.wav");
    
    //COMMA
    Engine.PrecacheFile(sound, "npc/combine_soldier/vo/_comma.wav");
}