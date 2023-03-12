Config = {}

Config.From             = 0     -- Starting progress percentage
Config.To               = 100   -- Ending progress percentage

Config.Async            = true  -- Whether to run the progress bar asyncronously

Config.Duration         = 5000
Config.Label            = "Loading..."
Config.LabelPosition    = "right"

Config.Color            = "rgba(34, 176, 227, 0.8)"    -- Progress bar colour
Config.BGColor          = "rgba(255, 255, 255, 0.4)"          -- Progress background colour

Config.x            = 0.45 -- Horizontal position
Config.y            = 0.94 -- Vertical position

Config.Rotation     = 0         -- Rotation angle of dial
Config.MaxAngle     = 360       -- Max arc in degrees - 360 will be a full circle, 90 will be a quarter of a circle, etc
Config.Radius       = 30        -- Radius of the radial dial
Config.Stroke       = 8        -- stroke width of the radial dial
Config.Width        = 300       -- Width of the linear bar
Config.Height       = 40        -- Height of the linear bar
Config.Cap          = 'butt'    -- or 'round'
Config.Padding      = 0         -- Backgound bar padding
Config.CancelKey    = 178       -- X Button

Config.Easing       = "easeLinear" 

Config.DisableControls = {
    disableMovement     = false,
    disableCarMovement  = false,
    disableMouse        = false,
    disableCombat       = false
}

InventoryBusy = function(bool)
    LocalPlayer.state.invBusy  = bool -- for Ox-Inventory
    --TriggerServerEvent("OpenInventory", bool) -- for QB-Inventory 
    --LocalPlayer.state:set("inv_busy", bool, true) -- Busy -- for QB-Inventory Choose whanever what's working on your side I'm using Ox-Inv rn so XD
end

Config.onStart      = function()end
Config.onComplete   = function()end