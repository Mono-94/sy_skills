

lib.locale()

FetchSkills = function()
    ESX.TriggerServerCallback("skillsystem:fetchStatus", function(data)
		if data then
            for status, value in pairs(data) do
                if Config.Skills[status] then
                    Config.Skills[status].Current = value.Current
                else
                    print("Removing: " .. status) 
                end
            end
	end
        RefreshSkills()
    end)
end

GetCurrentSkill = function(skill)
    return Config.Skills[skill]
end

--exports('GetCurrentSkill')

UpdateSkill = function(skill, amount)
    if not Config.Skills[skill] then
        print("Skill " .. skill .. " does not exist")
        return
    end
    local SkillAmount = Config.Skills[skill].Current
    if SkillAmount + tonumber(amount) < 0 then
        Config.Skills[skill].Current = 0
    elseif SkillAmount + tonumber(amount) > 250000 then
        Config.Skills[skill].Current = 100
    else
        Config.Skills[skill].Current = SkillAmount + tonumber(amount)
    end
    RefreshSkills()
    if Config.Notifications and  tonumber(amount) > 0 then
        if Config.NotifyType == 'ox' then
            lib.notify({
                title = locale('rewardtitle'),  
                description = "+" .. amount .. locale('rewardDesc') .. Config.Skills[skill].SkillLang,
                position = 'bottom',
                style = {
                    backgroundColor = '#141517',
                    color = '#909296'
                },
                icon = 'hand-fist',
                iconColor = '#C53030'
            })
        elseif Config.NotifyType == "esx" then
            ESX.ShowNotification(locale('rewardtitle') .. amount .. locale('rewardDesc') .. Config.Skills[skill].SkillLang) 
        end
    end

	TriggerServerEvent("skillsystem:update", json.encode(Config.Skills))
end

function round(num) 
    return math.floor(num+.5) 
end

function round1(num) 
    return math.floor(num+1) 
end

RefreshSkills = function()
    for type, value in pairs(Config.Skills) do
        if Config.Debug then
            print(type .. ": " .. value['Current'])
        elseif Config.Debug and not Config.Skills[skill] then
            print("something went wrong")
        end
        if value.Stat then
            StatSetInt(value.Stat, round(value.Current), true)
        end
    end
end

exports('CheckSkill', function(skill, val, hasskill)
    if Config.Skills[skill] then
        if Config.Skills[skill].Current >= tonumber(val) then
            hasskill(true)
        else
            hasskill(false)
        end
    else
        print("Skill " .. skill .. " doesn't exist")
        hasskill(false)
    end
end)

CheckSkill = function(skill, val, hasskill)
    if Config.Skills[skill] then
        if Config.Skills[skill].Current >= tonumber(val) then
            hasskill(true)
        else
            hasskill(false)
        end
    else
        print("Skill " .. skill .. " doesn't exist")
        hasskill(false)
    end
end
