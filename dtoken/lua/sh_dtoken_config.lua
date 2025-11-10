DToken.Config = {}

DToken.Config.Tiers = { 
 
        [1] = { 
                color = Color(100,0,0), 
                price = 0, -- The price doesn't matter for the first tier, just keep it 0 
                amount = 100 -- Ile Print
        }, 
        [2] = { 
                color = Color(200,0,0), 
                price = 100,
                amount = 200
        }, 
        [3] = { 
                color = Color(200,100,0), 
                price = 300,
                amount = 300
        }, 
        [4] = { 
                color = Color(200,200,0), 
                price = 500,
                amount = 400
        }, 
        [5] = { 
                color = Color(100,200,0), 
                price = 750,
                amount = 500
        },
}
-- Co ile sie uzywa bateria
DToken.Config.BatteryTime = 1
-- Co ile sie printuje
DToken.Config.PrintInterval = 2
-- Max Zasoby
DToken.Config.MaxInk = 15
DToken.Config.MaxPaper = 15
-- Ile Dodaje zasobów z 1 entity
DToken.Config.AddInk = 15
DToken.Config.AddPaper = 15
