ESX = exports["es_extended"]:getSharedObject()

local open = false -- Variabile per tenere traccia dello stato della visualizzazione dei documenti

-- Evento che si attiva quando viene richiesto di aprire i documenti
RegisterNetEvent('krs:apridocumenti')
AddEventHandler('krs:apridocumenti', function(data)
    if not data then return end
    if not open then
        open = true
        if data.customfoto == nil then
            -- Invia un messaggio NUI per aprire i documenti con i dati ricevuti
            SendNUIMessage({
                action = "open",
                f = data.f,
                l = data.l,
                s = data.s,
                dob = data.dob,
                h = data.h,
                foto = data.foto,
                array = data,
                type = data.tipologia,
            })
        elseif data.customfoto ~= nil then
            -- Invia un messaggio NUI per visualizzare una foto personalizzata
            SendNUIMessage({
                action = "customfoto",
                foto = data.customfoto
            })
        end
    end
end)

-- Registra il tasto per chiudere i documenti
RegisterKeyMapping('_chiudidoc_', 'Chiudi Documenti', 'KEYBOARD', 'BACK')
RegisterCommand('_chiudidoc_', function()
	if open then
		SendNUIMessage({
			action = "close"
		})
		open = false
	end
end)

-- Registra il comando per creare i documenti

-- RegisterCommand('creadocumento', function()
-- 	TriggerEvent('krs-idcard:creadocumenti', 'documento')
-- end)
-- RegisterCommand('creapatente', function()
-- 	TriggerEvent('krs-idcard:creadocumenti', 'patenteb')
-- end)
-- RegisterCommand('creaportoarmi', function()
-- 	TriggerEvent('krs-idcard:creadocumenti', 'portoarmi')
-- end)



local fotocamera = nil 

-- Evento che si attiva quando viene richiesta la creazione dei documenti
RegisterNetEvent('krs-idcard:creadocumenti')
AddEventHandler('krs-idcard:creadocumenti', function(tipo)
	local ped = PlayerPedId() -- Ottiene l'ID del personaggio giocante
	SetBlockingOfNonTemporaryEvents(ped, true) -- Impedisce eventi temporanei al personaggio
	TaskStandStill(ped, -1) -- Impone al personaggio di stare fermo
	ClearPedTasksImmediately(ped) -- Rimuove eventuali task precedentemente assegnati al personaggio
	FreezeEntityPosition(ped, true) -- Congela la posizione del personaggio
	BloccaTasti() -- Blocca tutti i comandi del giocatore

	-- Attende finché il personaggio non smette di muoversi
	while GetEntitySpeed(ped) > 0 do
		Wait(25)
	end

	-- Ottiene le coordinate della fotocamera posizionata davanti al personaggio
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.75, 0)

	-- Crea la fotocamera
	fotocamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamActive(fotocamera, true)
	RenderScriptCams(true, false, 0, true, true)
	SetCamCoord(fotocamera, coords.x, coords.y, coords.z + 0.65) -- Imposta la posizione della fotocamera
	SetCamFov(fotocamera, 38.0) -- Imposta il campo visivo della fotocamera
	SetCamRot(fotocamera, 0.0, 0.0, GetEntityHeading(ped) + 180) -- Imposta la rotazione della fotocamera
	PointCamAtPedBone(fotocamera, ped, 31086, 0.0, 0.0, 0.03, 1) -- Puntala fotocamera verso un osso del personaggio

	local camCoords = GetCamCoord(fotocamera) -- Ottiene le coordinate della fotocamera
	TaskLookAtCoord(ped, camCoords.x, camCoords.y, camCoords.z, 5000, 1, 1) -- Impone al personaggio di guardare verso le coordinate della fotocamera

	Wait(280) 

	-- Richiede l'invio dello screenshot a un webhook Discord
	exports['screenshot-basic']:requestScreenshotUpload(Config.webhooks, 'files[]', function(data)
		local resp = json.decode(data)
		local photo = nil
		for k, v in pairs(resp.attachments) do
			photo = v.url
		end
		while not photo do
			Wait(25)
		end

		-- Invia l'URL della foto al server tramite un evento personalizzato
		TriggerServerEvent("krs-idcard:givedocumenti", photo, tipo)
		Wait(500)
		RenderScriptCams(false, true, 250, 1, 0) -- Disattiva la fotocamera
		DestroyCam(fotocamera, false) -- Distrugge la fotocamera
		fotocamera = nil -- Resetta la variabile della fotocamera
		SetBlockingOfNonTemporaryEvents(ped, false) -- Permette nuovamente gli eventi temporanei al personaggio
		FreezeEntityPosition(ped, false) -- Rimuove la congela della posizione del personaggio
		ClearPedTasks(ped) -- Rimuove eventuali task assegnati al personaggio
		TaskClearLookAt(ped) -- Interrompe lo sguardo del personaggio
	end)
end)

-- Blocca i tasti del giocatore durante l'utilizzo della fotocamera
function BloccaTasti()
	CreateThread(function()
		while fotocamera ~= nil do
			DisableAllControlActions(0)
			Wait(0)
		end
		EnableAllControlActions(0)
	end)
end



-- Patente --
local numFotoScattatePatente = 1 -- Imposta il numero massimo di foto per la patente desiderato
local maxNumFotoPerPatente = 2 -- Imposta il numero massimo di foto per la patente desiderato

local numFotoScattatePortoArmi = 1 -- Imposta il numero massimo di foto per il porto d'armi desiderato
local maxNumFotoPerPortoArmi = 2 -- Imposta il numero massimo di foto per il porto d'armi desiderato

local numFotoScattate = 1 -- Imposta il numero massimo di foto per il porto d'armi desiderato
local maxNumFotoPerCarta = 2 -- Imposta il numero massimo di foto per il porto d'armi desiderato


local scuolaguida = {
    {
        icon = 'fas fa-id-card',
        label = 'Scatta la foto per la patente',
        distance = 10.5,
        onSelect = function(data)
            if numFotoScattatePatente < maxNumFotoPerPatente then
                TriggerEvent('krs-idcard:creadocumenti', 'patenteb', 'patentea', 'patentec')	
                ESX.ShowNotification('Documento della patente creato')
                numFotoScattatePatente = numFotoScattatePatente + 1
            else
                ESX.ShowNotification('Hai già scattato il numero massimo di foto per la patente.')
            end
        end,
        canInteract = function(entity, distance, coords, name, bone)
            return not IsEntityDead(entity)
        end
    }
}

Citizen.CreateThread(function()
    for i = 1, #Config.NpcPosizioneScuolaGuida, 1 do
        if not HasModelLoaded(Config.NpcPosizioneScuolaGuida[i].modellonpc) then
            RequestModel(Config.NpcPosizioneScuolaGuida[i].modellonpc)
            while not HasModelLoaded(Config.NpcPosizioneScuolaGuida[i].modellonpc) do
                Citizen.Wait(5)
            end
        end
        NpcScuolaGuida = CreatePed(4, Config.NpcPosizioneScuolaGuida[i].modellonpc, Config.NpcPosizioneScuolaGuida[i].posizionenpc, false, true)
        FreezeEntityPosition(NpcScuolaGuida, true)
        SetEntityInvincible(NpcScuolaGuida, true)
        SetBlockingOfNonTemporaryEvents(NpcScuolaGuida, true)
       
        exports.ox_target:addLocalEntity(NpcScuolaGuida, scuolaguida)
    end
end)


-- carta d\'identità --
local documentospawn = {
    {
        icon = 'fas fa-id-card',
        label = 'Scatta la foto per la carta d\'identità',
        distance = 10.5,
        onSelect = function(data)
            if numFotoScattate < maxNumFotoPerCarta then
                TriggerEvent('krs-idcard:creadocumenti', 'documento')
                ESX.ShowNotification('Documento della carta d\'identità creato')
                numFotoScattate = numFotoScattate + 1
            else
                ESX.ShowNotification('Hai già scattato il numero massimo di foto per la carta d\'identità.')
            end
        end,
        canInteract = function(entity, distance, coords, name, bone)
            return not IsEntityDead(entity)
        end
    }
}

Citizen.CreateThread(function()
    for i = 1, #Config.NpcPosizioneDocumento, 1 do
        if not HasModelLoaded(Config.NpcPosizioneDocumento[i].modellonpcd) then
            RequestModel(Config.NpcPosizioneDocumento[i].modellonpc)
            while not HasModelLoaded(Config.NpcPosizioneDocumento[i].modellonpcd) do
                Citizen.Wait(5)
            end
        end
        NpcDocumento = CreatePed(4, Config.NpcPosizioneDocumento[i].modellonpcd, Config.NpcPosizioneDocumento[i].posizionenpcd, false, true)
        FreezeEntityPosition(NpcDocumento, true)
        SetEntityInvincible(NpcDocumento, true)
        SetBlockingOfNonTemporaryEvents(NpcDocumento, true)
       
        exports.ox_target:addLocalEntity(NpcDocumento, documentospawn)
    end
end)


-- porto d\'armi --
local portoarmi = {
    {
        icon = 'fas fa-id-card',
        label = 'Scatta la foto per il porto d\'armi',
        distance = 10.5,
        onSelect = function(data)
            if numFotoScattatePortoArmi < maxNumFotoPerPortoArmi then
                TriggerEvent('krs-idcard:creadocumenti', 'portoarmi')
                ESX.ShowNotification('Documento del porto d\'armi creato')
                numFotoScattatePortoArmi = numFotoScattatePortoArmi + 1
            else
                ESX.ShowNotification('Hai già scattato il numero massimo di foto per il porto d\'armi.')
            end
        end,
        canInteract = function(entity, distance, coords, name, bone)
            return not IsEntityDead(entity)
        end
    }
}

Citizen.CreateThread(function()
    for i = 1, #Config.NpcPosizionePortoArmi, 1 do
        if not HasModelLoaded(Config.NpcPosizionePortoArmi[i].modellonpcp) then
            RequestModel(Config.NpcPosizionePortoArmi[i].modellonpc)
            while not HasModelLoaded(Config.NpcPosizionePortoArmi[i].modellonpcp) do
                Citizen.Wait(5)
            end
        end
        NpcPortoArmi = CreatePed(4, Config.NpcPosizionePortoArmi[i].modellonpcp, Config.NpcPosizionePortoArmi[i].posizionenpcp, false, true)
        FreezeEntityPosition(NpcPortoArmi, true)
        SetEntityInvincible(NpcPortoArmi, true)
        SetBlockingOfNonTemporaryEvents(NpcPortoArmi, true)
       
        exports.ox_target:addLocalEntity(NpcPortoArmi, portoarmi)
    end
end)

