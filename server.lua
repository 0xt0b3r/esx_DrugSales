ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local selling = false
	local success = false
	local copscalled = false
	local notintrested = false

  
  
RegisterNetEvent('drugs:trigger')
AddEventHandler('drugs:trigger', function()
	selling = true
	if selling == true then
		TriggerEvent('pass_or_fail')
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'Inform', text = 'Trying to convince person to buy your product!' })
 	end
end)

RegisterServerEvent('fetchjob')
AddEventHandler('fetchjob', function()
    local xPlayer  = ESX.GetPlayerFromId(source)
    TriggerClientEvent('getjob', source, xPlayer.job.name)
end)


  RegisterNetEvent('drugs:sell')
  AddEventHandler('drugs:sell', function()
  	local xPlayer = ESX.GetPlayerFromId(source)
	local meth = xPlayer.getInventoryItem('meth').count
	local coke 	  = xPlayer.getInventoryItem('cocaine').count
	local weed = xPlayer.getInventoryItem('dope').count
	local opium = xPlayer.getInventoryItem('opium_pooch').count
	local paymentc = math.random (1550,1550)
	local paymentw = math.random (700,825)
	local paymentm = math.random (1450,1450)
	local paymento = math.random (1650,1650)


		if coke >= 1 and success == true then
			    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You have sold a bag of cocaine for $' .. paymentc })
			TriggerClientEvent("animations", source)
			xPlayer.removeInventoryItem('cocaine', 1)
  			xPlayer.addAccountMoney('black_money', paymentc)
  			selling = false
  		elseif weed >= 1 and success == true then
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold a Q Oz of weed for $' .. paymentw })
            TriggerClientEvent("animations", source)
  			xPlayer.removeInventoryItem('dope', 1)
  			xPlayer.addAccountMoney('black_money', paymentw)
  			selling = false
  		  elseif meth >= 1 and success == true then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You have sold a bag of Meth for $' .. paymentm })
			TriggerClientEvent("animations", source)
  			xPlayer.removeInventoryItem('meth', 1)
  			xPlayer.addAccountMoney('black_money', paymentm)
  			selling = false
  			elseif opium >= 1 and success == true then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You have sold a bag of Crack for $' .. paymento })
			TriggerClientEvent("animations", source)
			xPlayer.removeInventoryItem('opium_pooch', 1)
  			xPlayer.addAccountMoney('black_money', paymento)
  			selling = false
			elseif selling == true and success == false and notintrested == true then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'They are not interested!' })
  			selling = false
  			elseif meth < 1 and coke < 1 and weed < 1 and opium < 1 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have any drugs to supply them with!' })
			elseif copscalled == true and success == false then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Offer rejected they called the police!' })
			TriggerClientEvent("notifyc", source)
  			selling = false
  		end
end)

RegisterNetEvent('pass_or_fail')
AddEventHandler('pass_or_fail', function()
  		
  		local percent = math.random(1, 11)

  		if percent == 7 or percent == 8 or percent == 9 then
  			success = false
  			notintrested = true
  		elseif percent ~= 8 and percent ~= 9 and percent ~= 10 and percent ~= 7 then
  			success = true
  			notintrested = false
  		else
  			notintrested = false
  			success = false
  			copscalled = true
  		end
end)

RegisterNetEvent('sell_dis')
AddEventHandler('sell_dis', function()
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You moved to far away!' })
end)

RegisterNetEvent('checkD')
AddEventHandler('checkD', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local meth = xPlayer.getInventoryItem('meth').count
	local coke 	  = xPlayer.getInventoryItem('cocaine').count
	local weed = xPlayer.getInventoryItem('dope').count
	local opium = xPlayer.getInventoryItem('opium_pooch').count

	if meth >= 1 or coke >= 1 or weed >= 1 or opium >= 1 then
		TriggerClientEvent("checkR", source, true)
	else
		TriggerClientEvent("checkR", source, false)
	end

end)
