----------------------------------------------------------------------------------------------
-----		commando.lua
-----		Written by Saturnyoshi
-----
-----		Translation of Commando from GML to Lua
-----
-----		Meant to serve as an example or base when writing your own characters.
-----
-----		Some things are fairly messy, but this is pretty much a direct
-----		translation, so blame Hopoo.
----------------------------------------------------------------------------------------------

	-----------------------------------------------------------
	---				Loaded			
	-----------------------------------------------------------

-- Add new class ID
lua_commando_id = class_add()
-- Set all the hooks
class_set_hook(lua_commando_id, "init", "onClassInit")
class_set_hook(lua_commando_id, "step", "onClassStep")
class_set_hook(lua_commando_id, "activity", "onClassSkill")
class_set_hook(lua_commando_id, "scepter", "onClassScepter")
class_set_hook(lua_commando_id, "level up", "onClassLevelUp")
-- Set select screen info, title sprite, and class colour
class_set_info(lua_commando_id, "Lua Commando", sSelectCharGMan, sGManSkills, 
	"The &y&Commando&!& is characterized by long range and mobility. #Effective use of his &y&Tactical Dive&!& will grant increased survivability,#while &y&suppressive fire&!& deals massive damage. #&y&FMJ&!& can then be used to dispose of large mobs.", 
	"Double Tap", "Shoot twice for &y&2x60% damage.&!&", 
	"Full Metal Jacket", "Shoot &y&through enemies&!& for &y&230% damage,#knocking them back.&!&", 
	"Tactical Dive", "&y&Roll forward&!& a small distance.#You &b&cannot be hit&!& while rolling.", 
	"Suppressive Fire", "Fire rapidly, &y&stunning&!& and hitting nearby enemies#for &y&480% damage&!&.",
	0, sGManWalk, make_color_rgb(193,128,62)
)
-- Deactivate vanilla Commando
class_set_active(class_commando,0)



	-----------------------------------------------------------
	---				Initialize class variables				
	-----------------------------------------------------------
function onClassInit(myPlayer)
	myPlayer.name = "Lua Commando"
 
	-- Sprites
	myPlayer.sprite_idle = sGManIdle
	myPlayer.sprite_walk = sGManWalk
	myPlayer.sprite_jump = sGManJump
	myPlayer.sprite_shoot1 = sGManShoot1
	myPlayer.sprite_shoot2 = sGManShoot2
	myPlayer.sprite_shoot3 = sGManShoot3
	myPlayer.sprite_shoot4_1 = sGManShoot4_1
	myPlayer.sprite_shoot4_2 = sGManShoot4_2
	myPlayer.sprite_climb = sGManClimb
	myPlayer.sprite_dead = sGManDeath
	
	-- Stats
	myPlayer.pHmax = 1.3
	myPlayer.damage= 12 * (1 + artifact_get_active(artifact_glass) * 4)
	myPlayer.maxhp = 110 * (1 - artifact_get_active(artifact_glass) * 0.9)
	myPlayer.hp_regen=0.01
	
	-- Skills
	skill_set(myPlayer, 1, "Double Tap", "Fire your gun twice for 2x60% damage.", sGManSkills, 0, 22, 0.6 )
	skill_set(myPlayer, 2, "Full Metal Jacket", "Shoot a bullet that passes through enemies for 230% damage, knocking them back.", sGManSkills, 1, 180, 2.3 )
	skill_set(myPlayer, 3, "Tactical Dive", "Rolls forward a small distance.", sGManSkills, 2, 240, 0 )
	skill_set(myPlayer, 4, "Suppressive Fire", "Fires rapidly, stunning and hitting nearby enemies for 6x60% damage total.", sGManSkills, 3, 300, 0.6 )
end



	-----------------------------------------------------------
	---				Class step event 						
	-----------------------------------------------------------
function onClassStep(myPlayer, skillActive)
	-- Set skill
	if myPlayer.activity == 0 then
		if skillActive == 1 then				-- Double Tap
			myPlayer.activity = 1
			myPlayer.activity_var1 = 0
			skill_cd(myPlayer,1)
		elseif skillActive == 2 then			-- FMJ
			myPlayer.activity = 2
			myPlayer.activity_var1 = 0
			skill_cd(myPlayer,2)
		elseif skillActive == 3 then			-- Tactical Dive
			myPlayer.activity = 3
			myPlayer.activity_var1 = 0
			skill_cd(myPlayer,3)
		elseif skillActive == 4 then			-- Suppressive Fire
			if bullet_trace(myPlayer.x, myPlayer.y, 0, 300, myPlayer.team) ~= noone and bullet_trace(myPlayer.x, myPlayer.y, 180, 300, myPlayer.team) ~= noone then
				myPlayer.activity = 4.1	-- Both directions
			else
				myPlayer.activity = 4.2	-- Single direction
			end
			myPlayer.activity_var1 = 0
			skill_cd(myPlayer,4)
		end
	end
end



	-----------------------------------------------------------
	---				Skills			 						
	-----------------------------------------------------------
function onClassSkill(myPlayer, activity)
	if activity == 1 then
			-----------------------------------------
			--		Double Tap
			-----------------------------------------
			
			
			
		if myPlayer.free == 0 then 
			myPlayer.pHspeed = 0
		end
		
		if myPlayer.activity_var1 == 0 then
			myPlayer.activity_var1 = 1
			myPlayer.z_count = myPlayer.z_count + 1
			
				-- Heaven Cracker
			if myPlayer.drill ~= 0 and myPlayer.z_count >= 5 - myPlayer.drill then
				sound_play(wDrill)
				fire_bullet(myPlayer, myPlayer.x, myPlayer.y, 90 - 90 * myPlayer.image_xscale, 700, skill_get_damage(myPlayer, 1), sSparks1, bullet_pierce)
                local newEffect = instance_create(myPlayer.x, myPlayer.y, oEfBullet2)
				newEffect.sprite_index = sEfDrill
				newEffect.image_xscale = myPlayer.image_xscale
				myPlayer.z_count = 0
			else
				-- Normal shot
				for i = 0, myPlayer.sp do
					local newBullet = fire_bullet(myPlayer, myPlayer.x, myPlayer.y, 90 - 90 * myPlayer.image_xscale, 700, skill_get_damage(myPlayer, 1), sSparks1, 0)
					newBullet.climb = i * 8
				end
				sound_play_ext(wBullet1, 0.85 + math.random() * 0.15, 1)
			end
			
		elseif myPlayer.activity_var1 == 1 and math.floor(myPlayer.image_index) == 2 then
			myPlayer.activity_var1 = 2
			for i = 0, myPlayer.sp do
				local newBullet = fire_bullet(myPlayer, myPlayer.x, myPlayer.y, 90 - 90 * myPlayer.image_xscale, 700, skill_get_damage(myPlayer, 1), sSparks1, 0)
				newBullet.climb = i * 8 + 9
			end
			sound_play_ext(wBullet1, 0.85 + math.random() * 0.15, 1)
		end
		
		myPlayer.sprite_index = myPlayer.sprite_shoot1
		myPlayer.image_speed = 0.25 * myPlayer.attack_speed
		myPlayer.activity_type = 1
		
		if math.floor(myPlayer.image_index) == myPlayer.image_number - 1 then
			myPlayer.activity = 0
			myPlayer.activity_type = 0
			myPlayer.image_speed = 0
		end
		
		
	elseif activity == 2 then
			-----------------------------------------
			--		Full Metal Jacket
			-----------------------------------------
			
			
			
		if myPlayer.free == 0 then 
			myPlayer.pHspeed = 0
		end
		
		if myPlayer.activity_var1 == 0 then
			myPlayer.activity_var1 = 1
			sound_play(wBullet2)
			screen_shake(4)
				-- Fire a bullet, 2 with a shadow partner (Shattered Mirror)
			for i = 0, myPlayer.sp do
				local newBullet = fire_bullet(myPlayer, myPlayer.x, myPlayer.y, 90 - 90 * myPlayer.image_xscale, 700, skill_get_damage(myPlayer, 2), sSparks2, bullet_pierce)
				newBullet.knockback = newBullet.knockback + 6
				newBullet.climb = i * 8
			end
		end
		
		myPlayer.sprite_index = myPlayer.sprite_shoot2
		myPlayer.image_speed = 0.25 * myPlayer.attack_speed
		myPlayer.activity_type = 1
		
		if math.floor(myPlayer.image_index) == myPlayer.image_number - 1 then
			myPlayer.activity = 0
			myPlayer.activity_type = 0
			myPlayer.image_speed = 0
		end
		
		
	elseif activity == 3 then
			-----------------------------------------
			--		Tactical Dive
			-----------------------------------------
			
			
			
		if myPlayer.invincible < 5 then
			myPlayer.invincible = 5
		end
		
		if myPlayer.pHspeed ~= 0 then 
			myPlayer.pHspeed = myPlayer.pHmax * 2 * myPlayer.image_xscale
		else
			myPlayer.pHspeed = myPlayer.pHmax * 2.6 * myPlayer.image_xscale
		end
		
		myPlayer.sprite_index = myPlayer.sprite_shoot3
		myPlayer.image_speed = 0.25
		myPlayer.activity_type = 1
		
		if math.floor(myPlayer.image_index) == myPlayer.image_number - 1 then
			if myPlayer.invincible <= 5 then
				myPlayer.invincible = 0
			end
			myPlayer.pHspeed = 0
			myPlayer.activity = 0
			myPlayer.activity_type = 0
			myPlayer.image_speed=0
		end
	elseif activity == 4.1 then
			-----------------------------------------
			--		Suppressive Fire (Both directions)
			-----------------------------------------
			
		
		
		if myPlayer.free == 0 then 
			myPlayer.pHspeed = 0
		end
	
		local currentFrame = math.floor(myPlayer.image_index)
		
		if (myPlayer.activity_var1 == 0 and (currentFrame == 1 or currentFrame == 5 or currentFrame == 9 or (myPlayer.scepter ~= 0 and (currentFrame == 13 or currentFrame == 17))))
		or (myPlayer.activity_var1 == 1 and (currentFrame == 3 or currentFrame == 7 or currentFrame == 11 or (myPlayer.scepter ~= 0 and (currentFrame == 15 or currentFrame == 19)))) then
			if myPlayer.activity_var1 == 0 then
				myPlayer.activity_var1 = 1
			else
				myPlayer.activity_var1 = 0
			end
			
			for i = 0, myPlayer.sp do
				local newBullet = fire_bullet(myPlayer, myPlayer.x, myPlayer.y, 90 - 90 * myPlayer.image_xscale + myPlayer.activity_var1 * 180 - 2 + math.random() * 4 , 700, skill_get_damage(myPlayer, 4), sSparks1, 0)
				newBullet.stun = 0.5
				newBullet.climb = i * 8
				if myPlayer.scepter > 0 then
					sound_play_ext(wGuardDeath, 1.8 + math.random() * 0.2, 1)
				end
			end
			sound_play_ext(wBullet3, 0.85 + math.random() * 0.15, 1)
		end
		
		myPlayer.sprite_index = myPlayer.sprite_shoot4_1
        if myPlayer.scepter ~= 0 then
			myPlayer.image_speed = 0.4 * myPlayer.attack_speed
		else
			myPlayer.image_speed = 0.3 * myPlayer.attack_speed
		end
		
		myPlayer.activity_type = 1
		
		if math.floor(myPlayer.image_index) == myPlayer.image_number - 1 then
			myPlayer.activity = 0
			myPlayer.activity_type = 0
			myPlayer.image_speed = 0
		end
	elseif activity == 4.2 then
			-----------------------------------------
			--		Suppressive Fire
			-----------------------------------------
			
		
		
		if myPlayer.free == 0 then 
			myPlayer.pHspeed = 0
		end
	
		local currentFrame = math.floor(myPlayer.image_index)
		
		if (myPlayer.activity_var1 == 0 and (currentFrame == 1 or currentFrame == 5 or currentFrame == 9 or (myPlayer.scepter ~= 0 and (currentFrame == 13 or currentFrame == 17))))
		or (myPlayer.activity_var1 == 1 and (currentFrame == 3 or currentFrame == 7 or currentFrame == 11 or (myPlayer.scepter ~= 0 and (currentFrame == 15 or currentFrame == 19)))) then
			if myPlayer.activity_var1 == 0 then
				myPlayer.activity_var1 = 1
			else
				myPlayer.activity_var1 = 0
			end
			
			for i = 0, myPlayer.sp do
				local newBullet = fire_bullet(myPlayer, myPlayer.x, myPlayer.y, 90 - 90 * myPlayer.image_xscale - 2 + math.random() * 4 , 700, skill_get_damage(myPlayer, 4), sSparks1, 0)
				newBullet.stun = 0.5
				newBullet.climb = i * 8
				if myPlayer.scepter > 0 then
					sound_play_ext(wGuardDeath, 1.8 + math.random() * 0.2, 1)
				end
			end
			sound_play_ext(wBullet3, 0.85 + math.random() * 0.15, 1)
		end
		
		myPlayer.sprite_index = myPlayer.sprite_shoot4_2
        if myPlayer.scepter ~= 0 then
			myPlayer.image_speed = 0.4 * myPlayer.attack_speed
		else
			myPlayer.image_speed = 0.3 * myPlayer.attack_speed
		end
		
		myPlayer.activity_type = 1
		
		if math.floor(myPlayer.image_index) == myPlayer.image_number - 1 then
			myPlayer.activity = 0
			myPlayer.activity_type = 0
			myPlayer.image_speed = 0
		end
	end
end


	-----------------------------------------------------------
	---				Level Up
	-----------------------------------------------------------
function onClassLevelUp(myPlayer) 
	local glass_on = artifact_get_active(artifact_glass)
	local hp_bonus = 32
	local damage_bonus = 3
	if glass_on == 1 then
		hp_bonus = hp_bonus * 0.75
		damage_bonus = damage_bonus * 5
	end
    myPlayer.maxhp = myPlayer.maxhp + hp_bonus
    myPlayer.maxhp_base = myPlayer.maxhp_base + hp_bonus
    myPlayer.hp = myPlayer.hp + hp_bonus
    myPlayer.damage = myPlayer.damage + damage_bonus
	myPlayer.armor = myPlayer.armor + 2
    myPlayer.hp_regen =  myPlayer.hp_regen + 0.002
end


	-----------------------------------------------------------
	---				Picked up Ancient Scepter	
	-----------------------------------------------------------
function onClassScepter(myPlayer) 
	skill_set(myPlayer, 4, "Suppressive Barrage", "Fires rapidly, stunning and hitting nearby enemies for 10x60% damage total.", sGManSkills, 4, 300, 0.6 )
	myPlayer.sprite_shoot4_1 = sGManShoot5_1
	myPlayer.sprite_shoot4_2 = sGManShoot5_2
end