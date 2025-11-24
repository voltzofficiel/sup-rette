local ESX = exports['es_extended']:getSharedObject()
local isOpen = false
local currentShop = nil
local targetIds = {}

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

    local payload = {
        action = 'open',
        categories = Config.Categories,
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

AddEventHandler('onResourceStart', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    createTargets()
end)

AddEventHandler('onResourceStop', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    removeTargets()
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
