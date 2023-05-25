Config = {}

Config.webhooks = 'https://discord.com/api/webhooks/1111209181459009536/R66Z3R7Gko3vfifhdFEA34H1NKxDvaS6s8R2uBlmhfdB9Y_4r28CzJXvTzNbYt0tBX8X' -- Qui inserite il vostro Webhooks Discord

Config.NpcPosizioneScuolaGuida = {
    {
     modellonpc = 'cs_beverly', -- https://docs.fivem.net/docs/game-references/ped-models/ --
     posizionenpc = vector4(219.3674, -1390.1313, 29.5875, 318.8539),
    }
}

Config.NpcPosizioneDocumento = {
    {
     modellonpcd = 'cs_beverly', -- https://docs.fivem.net/docs/game-references/ped-models/ --
     posizionenpcd = vector4(-1041.8595, -2735.1958, 19.1693, 239.5466),
    }
}

Config.NpcPosizionePortoArmi = {
    {
     modellonpcp = 'cs_beverly', -- https://docs.fivem.net/docs/game-references/ped-models/ --
     posizionenpcp = vector4(437.9136, -993.3586, 29.6896, 85.5062),
    }
}

Config.DocumentTypes = {

    ['patenteb'] = {
        label = 'Patente B',
    },
    ['patentea'] = {
        label = 'Patente A',
    },
    ['patentec'] = {
        label = 'Patente C',
    },
    ['documento'] = {
        label = 'Documento',
    },
    ['portoarmi'] = {
        label = 'Porto D\'Armi',
    }
}
