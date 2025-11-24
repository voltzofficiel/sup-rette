local ESX = exports['es_extended']:getSharedObject()
local ox_inventory = exports.ox_inventory
local isOpen = false
local currentShop = nil
local targetIds = {}
local blips = {}

local function findItem(itemName)
    for _, category in ipairs(Config.Categories) do
        for _, item in ipairs(category.items) do
            if item.name == itemName then
                return item, category
            end
        end
    end
end

local function openShop(shopId)
    if isOpen then return end

    local categories = {}

    for _, category in ipairs(Config.Categories) do
        local items = {}

        for _, item in ipairs(category.items) do
            local oxItem = ox_inventory:Items(item.name)
            local imageName = oxItem and (oxItem.image or (oxItem.client and oxItem.client.image))
            local imagePath

            if imageName then
                imagePath = ('nui://ox_inventory/web/images/%s'):format(imageName)
            elseif item.image and (item.image:find('^https?://') or item.image:find('^nui://')) then
                imagePath = item.image
            else
                imagePath = ('nui://ox_inventory/web/images/%s.png'):format(item.name)
            end

            items[#items + 1] = {
                name = item.name,
                label = item.label,
                price = item.price,
                image = imagePath
            }
        end

        categories[#categories + 1] = {
            name = category.name,
            label = category.label,
            color = category.color,
            icon = category.icon,
            items = items
        }
    end

    local payload = {
        action = 'open',
        categories = categories,
        shop = shopId
    }

    SetNuiFocus(true, true)
    SendNUIMessage(payload)
    isOpen = true
    currentShop = shopId
end

local function closeShop()
    if not isOpen then return end

    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    isOpen = false
    currentShop = nil
end

RegisterNUICallback('close', function(_, cb)
    closeShop()
    cb(true)
end)

RegisterNUICallback('purchase', function(data, cb)
    local item, category = findItem(data.name)
    if not item then
        ESX.ShowNotification('~r~Article introuvable.')
        cb(false)
        return
    end

    local quantity = tonumber(data.quantity) or 1
    quantity = math.max(1, math.min(quantity, Config.MaxPurchase))

    TriggerServerEvent('sup-rette:buyItem', item.name, quantity, category and category.label)
    cb(true)
end)

RegisterNetEvent('sup-rette:openShop', function(shopId)
    openShop(shopId)
end)

RegisterNetEvent('sup-rette:notify', function(message, notifyType)
    if notifyType == 'success' then
        ESX.ShowNotification('~g~' .. message)
    elseif notifyType == 'error' then
        ESX.ShowNotification('~r~' .. message)
    else
        ESX.ShowNotification(message)
    end
end)

local function createTargets()
    for i, shop in ipairs(Config.Shops) do
        local targetId = exports.ox_target:addSphereZone({
            coords = shop.coords,
            radius = Config.Target.radius,
            debug = false,
            options = {
                {
                    name = 'sup-rette:' .. i,
                    icon = Config.Target.icon,
                    label = Config.Target.label,
                    distance = Config.Target.radius + 1.0,
                    onSelect = function()
                        TriggerEvent('sup-rette:openShop', i)
                    end
                }
            }
        })

        targetIds[#targetIds + 1] = targetId
    end
end

local function removeTargets()
    for _, id in ipairs(targetIds) do
        exports.ox_target:removeZone(id)
    end
    targetIds = {}
end

local function createBlips()
    if not Config.Blips.enabled then return end

    local function formatLabel(label, index)
        local text = label or 'Supérette'

        if not Config.Blips.single and Config.Blips.showIndex and index then
            text = ('%s #%d'):format(text, index)
        end

        local maxLength = Config.Blips.maxLabelLength
        if maxLength and maxLength > 0 and #text > maxLength then
            text = text:sub(1, maxLength)
        end

        return text
    end

    local function createBlip(coords, label)
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

        SetBlipSprite(blip, Config.Blips.sprite or 52)
        SetBlipScale(blip, Config.Blips.scale or 0.75)
        SetBlipColour(blip, Config.Blips.colour or 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(label)
        EndTextCommandSetBlipName(blip)

        blips[#blips + 1] = blip
    end

    if Config.Blips.single then
        local coords = Config.Blips.coords or (Config.Shops[1] and Config.Shops[1].coords)
        if coords then
            createBlip(coords, formatLabel(Config.Blips.label))
        end
    else
        local baseLabel = Config.Blips.shortLabel or Config.Blips.label or 'Supérette'
        for i, shop in ipairs(Config.Shops) do
            createBlip(shop.coords, formatLabel(baseLabel, i))
        end
    end
end

local function removeBlips()
    for _, blip in ipairs(blips) do
        RemoveBlip(blip)
    end
    blips = {}
end

AddEventHandler('onResourceStart', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    createTargets()
    createBlips()
end)

AddEventHandler('onResourceStop', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    removeTargets()
    removeBlips()
    closeShop()
end)

RegisterCommand('forcesuperette', function()
    createTargets()
end, false)

RegisterKeyMapping('forcesuperette', 'Recharger les zones supérette', 'keyboard', 'END')

RegisterNUICallback('playSound', function(data, cb)
    SendNUIMessage({ action = 'sound', sound = data.sound })
    cb(true)
end)
