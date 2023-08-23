RicochetCounter = RicochetCounter or {}
RicochetCounter.color = Color(255, 0, 50, 255) / 255
RicochetCounter.ricdamage = 0
RicochetCounter.totalric = 0
RicochetCounter.riccount = 0
RicochetCounter.rickills = 0
RicochetCounter.explosion = false

function RicochetCounter.Reset()
	RicochetCounter.ricdamage = 0
	RicochetCounter.totalric = 0
	RicochetCounter.riccount = 0
	RicochetCounter.rickills = 0
end

function RicochetCounter.addric()
	--managers.chat:_receive_message(managers.chat.GAME, "debug1", "made it to function!", RicochetCounter.color)
	--For some reason, the damage reported via the hook is 10% of the actual damage, hence multiplying it by 10 here.
	RicochetCounter.ricdamage = RicochetCounter.ricdamage * 10
	RicochetCounter.totalric = RicochetCounter.totalric + RicochetCounter.ricdamage
	RicochetCounter.riccount = RicochetCounter.riccount + 1
end

function RicochetCounter.rickill()
	RicochetCounter.rickills = RicochetCounter.rickills + 1
end

function RicochetCounter.SetupHooks() 
	if RequiredScript == "lib/states/missionendstate" then
		Hooks:PostHook(MissionEndState,"at_enter", "post_results", function(self, ...)
			managers.chat:_receive_message(managers.chat.GAME, "Ricochet Counter", "You ricocheted a total of " .. RicochetCounter.riccount .. " times, dealing " .. RicochetCounter.totalric .. " total damage!", RicochetCounter.color)
			managers.chat:_receive_message(managers.chat.GAME, "Ricochet Counter", "Your ricochets killed " .. RicochetCounter.rickills .. " enemies.", RicochetCounter.color)
			RicochetCounter.Reset()
		end )
	elseif RequiredScript == "lib/units/enemies/cop/copdamage" then
		Hooks:PostHook(CopDamage, "damage_simple", "ricochetstuff", function(self,attack_data,...)
		--damage_simple is (allegedly) only called for two things: ricochet, and Sharpshooter Graze. Thankfully, there are differentiated by the .variant attribute
			if attack_data.variant == "bullet" then
				RicochetCounter.ricdamage = attack_data.damage
				RicochetCounter.addric()
				--managers.chat:_receive_message(managers.chat.GAME, "debug1", "parried", RicochetCounter.color)
				--managers.chat:_receive_message(managers.chat.GAME, "debug1", "damage: " .. tostring(RicochetCounter.totalric), RicochetCounter.color)
				--attack_data can also determine if the damage dealt to the cop kills said cop. If so, add that counter.
				if not attack_data.result then
					--managers.chat:_receive_message(managers.chat.GAME, "ricochet_debug", "You got nil'd!", RicochetCounter.color)
				elseif attack_data.result.type == "death" then
					RicochetCounter.rickill()
					--managers.chat:_receive_message(managers.chat.GAME, "debug1", "GET DUNKED ON", RicochetCounter.color)
				end
			end
		end )
	end
end

RicochetCounter.SetupHooks()