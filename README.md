# refine-radialbar
 A standalone customizable radial progressbar. A Revamp version of rprogress and progressbar. <3


## Need Unique Script Experience?
- [Tebex](https://refined.tebex.io/)

## Need Assistance?
- [Discord](https://discord.com/invite/GrGGkQtv5P)


### Features
 * Customizable Color, Position & Styles
 * Smooth Ui, Edge & Animation Effect
 * Full Control at Config File
 * Ox-Lib, Qb-Inventory Support
 * Cancel and not Cancelable Options
 * Any Resolution Support
 * Standalone

![refine-radialbar](https://cdn.discordapp.com/attachments/1084262223423213622/1084262250354847784/image.png)

---

- [Demos](#demos)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
---

## Demos
- [Video](https://youtu.be/GcP9zBSlPek)

---

## Installation
* Drop the `refine-radialbar` directory into you `resources` directory
* Add `ensure refine-radialbar` to your `server.cfg` file
* For QB-Core go to `qb-core>client>function.lua` and look for line `function QBCore.Functions.Progressbar`.
Before:
```lua
    function QBCore.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
        if GetResourceState('progressbar') ~= 'started' then error('progressbar needs to be started in order for QBCore.Functions.Progressbar to work') end
        exports['progressbar']:Progress({
            name = name:lower(),
            duration = duration,
            label = label,
            useWhileDead = useWhileDead,
            canCancel = canCancel,
            controlDisables = disableControls,
            animation = animation,
            prop = prop,
            propTwo = propTwo,
        }, function(cancelled)
            if not cancelled then
                if onFinish then
                    onFinish()
                end
            else
                if onCancel then
                    onCancel()
                end
            end
        end)
    end
```
After:
```lua
    function QBCore.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, space, onFinish, onCancel)
        local name = name
        print(name)
        --add the "space" call since qb-core default function hast propTwo and I forgot that prop is already just one <3
        exports['refine-radialbar']:Custom({
            canCancel = canCancel,       -- Allow cancelling
            deadCancel = useWhileDead,   --Cant Be Cancel Even you Die
            Duration = duration,        -- Duration of the progress
            Label = label,
            Animation = animation,
            PropAttach = prop,
            DisableControls = disableControls,
            onComplete = function(cancelled)
                if not cancelled then
                    if onFinish then
                        onFinish()
                    end
                else
                    if onCancel then
                        onCancel()
                    end
                end 
            end
        })
    end
```

---

## Usage
Old QB-Core Function:
```lua
    QBCore.Functions.Progressbar('impound', 'Test', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'missheistdockssetup1clipboard@base',
        anim = 'base',
        flags = 1,
    }, {
        model = 'prop_notepad_01',
        bone = 18905,
        coords = { x = 0.1, y = 0.02, z = 0.05 },
        rotation = { x = 10.0, y = 0.0, z = 0.0 },
    },{
        model = 'prop_pencil_01',
        bone = 58866,
        coords = { x = 0.11, y = -0.02, z = 0.001 },
        rotation = { x = -120.0, y = 0.0, z = 0.0 },
    }, function() -- Play When Done
        print("Working")
    end, function() -- Play When Cancel
        print("Got Cancel")
    end)
```
New QB-Core `RADIALBAR` Function:
```lua
    QBCore.Functions.Progressbar('impound', 'Test', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'missheistdockssetup1clipboard@base',
        animationName = 'base',
        flags = 1,
    }, {
        model = 'prop_notepad_01',
        bone = 18905,
        coords = vec3(0.1, 0.02, 0.05),
        rotation = vec3(10.0, 0.0, 0.0),
        modeltwo = 'prop_pencil_01',
        bonetwo = 58866,
        coordstwo = vec3(0.11, -0.02, 0.001),
        rotationtwo = vec3(-120.0, 0.0, 0.0),
    }, function() -- Play When Done
        print("Working")
    end, function() -- Play When Cancel
        print("Got Cancel")
    end)
```

---

## Examples
```lua
    exports['refine-radialbar']:Custom({
        Async = true,  --thanks for this option rprogress by Mobius1 <3
        canCancel = false, -- can cancel 
        deadCancel = false, -- cannot be cancel even if you die 
        Duration = 5000,      
        Color = "rgba(224, 53, 40, 1.0)",
        Label = "This is Red Radial",
        Animation = {
            --task = "WORLD_HUMAN_AA_SMOKE", 
            animDict = "missarmenian2", 
            anim = "drunk_loop",
            flags = 1,
        },
        DisableControls = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },    
        onStart = function()
            --You can Create a Thread here for checking animation or leave it empty :)
        end,
        onComplete = function(cancelled)
            if cancelled then
               -- if you cancel event like not working
               -- Ex: Stop drinking Water Event ClearpedTask
            else
                --if you succeed finish the event 
                --Ex: Fill Thirst Metadata with ClearpedTask
            end
        end
    })
```
