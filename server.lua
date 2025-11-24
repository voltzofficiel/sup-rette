local ESX = exports['es_extended']:getSharedObject()

local function findItem(itemName)
    for _, category in ipairs(Config.Categories) do
        for _, item in ipairs(category.items) do
            if item.name == itemName then
                return item, category
            end
        end
    end
end

RegisterNetEvent('sup-rette:buyItem', function(itemName, quantity, categoryLabel)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then return end

    local item = findItem(itemName)
    if not item then
        TriggerClientEvent('sup-rette:notify', src, 'Article introuvable.', 'error')
        return
    end

    local qty = math.max(1, math.min(tonumber(quantity) or 1, Config.MaxPurchase))
    local price = item.price * qty

    if xPlayer.getMoney() < price then
        TriggerClientEvent('sup-rette:notify', src, 'Fonds insuffisants.', 'error')
        return
    end

    local label = item.label or item.name
    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem(item.name, qty)

    local categoryText = categoryLabel and (' (' .. categoryLabel .. ')') or ''
    TriggerClientEvent('sup-rette:notify', src, ('Achat de %s x%d%s réussi pour $%d.'):format(label, qty, categoryText, price), 'success')
end)
