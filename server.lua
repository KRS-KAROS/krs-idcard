ESX = exports["es_extended"]:getSharedObject()


RegisterServerEvent('krs-idcard:givedocumenti', function(link, tipo)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not link or not tipo then
        return
    end
    
    local documentConfig = Config.DocumentTypes[tipo] 
    
    if not documentConfig then
        print('cheater')
        return
    end
    
    local label = documentConfig.label 
    
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(res)
        if not res or #res == 0 then
            return
        end
        
        local playerData = res[1]
        local metadata = {
            f = playerData.firstname,
            l = playerData.lastname,
            s = playerData.sex,
            dob = playerData.dateofbirth,
            h = playerData.height,
            foto = link,
            tipologia = tipo,
            description = label .. ' di ' .. playerData.firstname .. ' ' .. playerData.lastname
        }
        
        print(xPlayer.source, tipo, 1, metadata) -- Stampa le informazioni per debug
        
        -- Aggiunge il documento all'inventario del giocatore utilizzando il sistema di inventario specifico (in questo caso 'ox_inventory')
        exports.ox_inventory:AddItem(xPlayer.source, tipo, 1, metadata)
    end)
end)




-- Registra l'utilizzo degli oggetti 'patentea','patente','patentec','documento','portoarmi'
ESX.RegisterUsableItem('patentea', function(source, slot, fra)
    local xPlayer = ESX.GetPlayerFromId(source)
    if fra.metadata ~= nil then
        TriggerClientEvent("krs:apridocumenti", source, fra.metadata)
        print('krs:apridocumenti')
    else
        xPlayer.showNotification("Questo documento è vuoto")
    end
end)

ESX.RegisterUsableItem('patenteb', function(source, slot, fra)
    local xPlayer = ESX.GetPlayerFromId(source)
    if fra.metadata ~= nil then
        TriggerClientEvent("krs:apridocumenti", source, fra.metadata)
        print('krs:apridocumenti')
    else
        xPlayer.showNotification("Questo documento è vuoto")
    end
end)

ESX.RegisterUsableItem('patentec', function(source, slot, fra)
    local xPlayer = ESX.GetPlayerFromId(source)
    if fra.metadata ~= nil then
        TriggerClientEvent("krs:apridocumenti", source, fra.metadata)
        print('krs:apridocumenti')
    else
        xPlayer.showNotification("Questo documento è vuoto")
    end
end)

ESX.RegisterUsableItem('documento', function(source, slot, fra)
    local xPlayer = ESX.GetPlayerFromId(source)
    if fra.metadata ~= nil then
        TriggerClientEvent("krs:apridocumenti", source, fra.metadata)
        print('krs:apridocumenti')
    else
        xPlayer.showNotification("Questo documento è vuoto")
    end
end)

ESX.RegisterUsableItem('portoarmi', function(source, slot, fra)
    local xPlayer = ESX.GetPlayerFromId(source)
    if fra.metadata ~= nil then
        TriggerClientEvent("krs:apridocumenti", source, fra.metadata)
        print('krs:apridocumenti')
    else
        xPlayer.showNotification("Questo documento è vuoto")
    end
end)

ESX.RegisterUsableItem('foto', function(source, slot, shuttle)
    local xPlayer = ESX.GetPlayerFromId(source)
    if shuttle.metadata ~= nil then
        TriggerClientEvent("krs:apridocumenti", source, shuttle.metadata)
        print('krs:apridocumenti')
    else
        xPlayer.showNotification("Questa foto è vuota")
    end
end)

