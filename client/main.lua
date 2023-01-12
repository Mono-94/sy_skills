lib.locale()

RegisterNetEvent('esx:playerLoaded', function()
	Citizen.CreateThread(function()
		FetchSkills()
		while true do
			local seconds = Config.UpdateFrequency * 1000
			Citizen.Wait(seconds)
			for skill, value in pairs(Config.Skills) do
				UpdateSkill(skill, value["RemoveAmount"])
			end
			TriggerServerEvent("skillsystem:update", json.encode(Config.Skills))
		end
	end)
	RegisterNetEvent('esx:onPlayerDeath', function()
	if Config.ResetSkillsDeath then
		for skill, value in pairs(Config.Skills) do
			Config.Skills[skill]["Current"] = 0
		end
	end
end)

end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(100)
		FetchSkills()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50000)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsUsing(ped)
		if IsPedRunning(ped) then
			UpdateSkill("Stamina", 0.2)
		elseif IsPedInMeleeCombat(ped) then
			UpdateSkill("Strength", 0.2)
		elseif IsPedSwimmingUnderWater(ped) then
			UpdateSkill("Lung Capacity", 0.2)
		elseif IsPedShooting(ped) then
			UpdateSkill("Shooting", 0.2)
		elseif DoesEntityExist(vehicle) then
			local speed = GetEntitySpeed(vehicle) * 3.6

			if GetVehicleClass(vehicle) == 8 or GetVehicleClass(vehicle) == 13 and speed >= 5 then
				local rotation = GetEntityRotation(vehicle)
				if IsControlPressed(0, 210) then
					if rotation.x >= 25.0 then
						UpdateSkill("Wheelie", 0.2)
					end
				end
			end
			if speed >= 80 then
				UpdateSkill("Driving", 0.2)
			end
		end
	end
end)

Citizen.CreateThread(function()
	if Config.WeaponLvlCheck then
		while true do
			Citizen.Wait(1000)
			for k,v in pairs(Config.WeaponLvL) do
				local ped = PlayerPedId()
				local weaponHash = k
				local weapon = HasPedGotWeapon(ped, weaponHash, false)
				local skill = Config.CheckWeaponSkill
				CheckSkill(skill, v.xp, function(checkit)
					if checkit then
					else
						if weapon then 
							lib.notify({
								title = locale('skills'),  
								description = locale('weaponcheck1')..v.xp..locale('weaponcheck2')..Config.Skills[skill].SkillLang,
								position = 'bottom',
								style = {
									backgroundColor = '#141517',
									color = '#909296'
								},
								icon = 'hand-fist',
								iconColor = '#C53030',
								duration = 5000
							})
						TriggerEvent('ox_inventory:disarm', k)
						Citizen.Wait(400)
						end
					end
				end)
			end
		end
	end
end)


