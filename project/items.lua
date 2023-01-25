-- Items
items = {}
items.life_restored = love.graphics.newImage('sprites/items/life-restored.png')
items.fast_shot = love.graphics.newImage('sprites/items/fast-shot.png')
items.wave2 = true
items.wave3 = true
items.draw = {}

-- *** love.update() Functions ***

-- Items Spawn
function items_spawn()
    if ws.current == 2 and items.wave2 then
        life_restored = {x = 210, y = 80, img = items.life_restored, item = 'life_restored'}
        table.insert(items.draw, life_restored)
        items.wave2 = false
    elseif ws.current == 3 and items.wave3 then
        life_restored = {x = 210, y = 80, img = items.life_restored, item = 'life_restored'}
        table.insert(items.draw, life_restored)
        fast_shot = {x = 870, y = 80, img = items.fast_shot, item = 'fast_shot'}
        table.insert(items.draw, fast_shot)
        items.wave3 = false
    end
end

-- *** love.draw() Functions ***

-- Items Spawn (Draw)
function items_draw()
    for i, v in ipairs(items.draw) do
        love.graphics.draw(v.img, v.x, v.y)
    end
end