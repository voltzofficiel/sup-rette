local ox_inventory = exports.ox_inventory

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

    local item = findItem(itemName)
    if not item then
        TriggerClientEvent('sup-rette:notify', src, 'Article introuvable.', 'error')
        return
    end

    local oxItem = ox_inventory:Items(item.name)

    if not oxItem then
        TriggerClientEvent('sup-rette:notify', src, 'Article indisponible dans ox_inventory.', 'error')
        return
    end

    local qty = math.max(1, math.min(tonumber(quantity) or 1, Config.MaxPurchase))
    local price = item.price * qty
    local cash = ox_inventory:Search(src, 'count', 'money') or 0

    if cash < price then
        TriggerClientEvent('sup-rette:notify', src, 'Fonds insuffisants.', 'error')
        return
    end

    local removed = ox_inventory:RemoveItem(src, 'money', price)

    if not removed or removed < price then
        TriggerClientEvent('sup-rette:notify', src, 'Impossible de retirer l\'argent.', 'error')
        return
    end

    local added = ox_inventory:AddItem(src, item.name, qty)

    if not added then
        ox_inventory:AddItem(src, 'money', price)
        TriggerClientEvent('sup-rette:notify', src, 'Inventaire plein.', 'error')
        return
    end

    local label = (oxItem.label or item.label) or item.name

    local categoryText = categoryLabel and (' (' .. categoryLabel .. ')') or ''
    TriggerClientEvent('sup-rette:notify', src, ('Achat de %s x%d%s réussi pour $%d.'):format(label, qty, categoryText, price), 'success')
end)
