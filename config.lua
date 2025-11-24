Config = {}

Config.Locale = 'fr'

Config.Target = {
    radius = 2.0,
    icon = 'fa-solid fa-bag-shopping',
    label = 'Parler au caissier'
}

Config.Blips = {
    enabled = true,
    single = true,
    sprite = 52,
    scale = 0.75,
    colour = 2,
    label = 'Supérette',
    coords = nil -- laissez à nil pour utiliser le premier shop ou indiquez vec3(x, y, z)
}

Config.Shops = {
    { coords = vec3(24.44, -1346.04, 29.5) },
    { coords = vec3(-47.3, -1759.99, 29.42) },
    { coords = vec3(-706.07, -914.81, 19.22) },
    { coords = vec3(1135.68, -982.72, 46.42) },
    { coords = vec3(373.92, 325.43, 103.57) },
    { coords = vec3(2556.65, 380.84, 108.62) },
    { coords = vec3(549.16, 2671.14, 42.16) },
    { coords = vec3(1960.07, 3740.05, 32.34) },
    { coords = vec3(1698.01, 4924.56, 42.06) },
    { coords = vec3(2678.15, 3279.54, 55.24) },
    { coords = vec3(-3039.58, 585.73, 7.91) },
    { coords = vec3(-3242.7, 1001.46, 12.83) },
    { coords = vec3(-2967.76, 390.93, 15.05) },
    { coords = vec3(-1487.06, -379.46, 40.16) },
    { coords = vec3(1165.24, 2709.35, 38.16) },
    { coords = vec3(1392.64, 3604.94, 34.98) },
    { coords = vec3(-1820.37, 794.3, 138.09) }
}

Config.Categories = {
    {
        name = 'nourriture',
        label = 'Nourriture',
        color = '#7BD88F',
        icon = '🥐',
        items = {
            { name = 'bread', label = 'Baguette croustillante', price = 6, image = 'bread.svg' },
            { name = 'chocolate', label = 'Tablette de chocolat', price = 10, image = 'chocolate.svg' },
            { name = 'sandwich', label = 'Sandwich club', price = 18, image = 'sandwich.svg' },
            { name = 'chips', label = 'Chips paprika', price = 12, image = 'chips.svg' }
        }
    },
    {
        name = 'boissons',
        label = 'Boissons',
        color = '#7EC4FF',
        icon = '🧃',
        items = {
            { name = 'water', label = 'Eau minérale', price = 5, image = 'water.svg' },
            { name = 'cola', label = 'Soda cola', price = 9, image = 'cola.svg' },
            { name = 'energy', label = 'Boisson énergisante', price = 14, image = 'energy.svg' },
            { name = 'coffee', label = 'Café frappé', price = 11, image = 'coffee.svg' }
        }
    },
    {
        name = 'essentiels',
        label = 'Essentiels',
        color = '#FFCF7F',
        icon = '🛒',
        items = {
            { name = 'bandage', label = 'Bandage stérile', price = 35, image = 'bandage.svg' },
            { name = 'lockpick', label = 'Crochet discret', price = 75, image = 'lockpick.svg' },
            { name = 'phone', label = 'Téléphone basique', price = 350, image = 'phone.svg' },
            { name = 'lighter', label = 'Briquet tempête', price = 15, image = 'lighter.svg' }
        }
    }
}

Config.MaxPurchase = 25
