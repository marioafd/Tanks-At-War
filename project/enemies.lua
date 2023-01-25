-- ENEMIES

-- Enemies (Main Configuration)

enemy = {}
enemy.tank_up = love.graphics.newImage('sprites/enemies/enemy-up.png')
enemy.tank_down = love.graphics.newImage('sprites/enemies/enemy-down.png')
enemy.tank_left = love.graphics.newImage('sprites/enemies/enemy-left.png')
enemy.tank_right = love.graphics.newImage('sprites/enemies/enemy-right.png')
enemy.bullet = love.graphics.newImage('sprites/enemies/enemy-bullet.png')
enemy.direction = "down"
enemy.big_enemy_down = love.graphics.newImage('sprites/enemies/big-enemy-down.png')
enemy.big_enemy_bullet = love.graphics.newImage('sprites/enemies/big-enemy-bullet.png')

-- Enemies Table
enemies = {}

-- Big Enemies Table
big_enemies = {}

-- Waves
ws = {}
ws.current = 0
-- First Wave
wave1 = {}
wave1.starts = true
wave1.counter = 0
wave1.delay = 0.5
wave1.spawn = wave1.delay
wave1.speed = 50
wave1.x_default = 50
wave1.x = wave1.x_default
wave1.y = 0

-- Second Wave (rx = random x, ry = random y)
wave2 = {}
wave2.starts = false
wave2.counter = 0
wave2.delay = 0.5
wave2.spawn = wave2.delay
wave2.speed = 50
wave2.ramdom_number = 0
wave2.x = 0
wave2.y = 0
wave2.rx = 0
wave2.ry = 0

-- Third Wave
wave3 = {}
wave3.starts = false
wave3.enemies = false
wave3.counter = 0
wave3.speed = 20
wave3.life = 400
wave3.x = 0
wave3.y = 0

-- *** love.update() Functions ***

-- Enemies Spawn (Wave 1)
function enemies_spawn_wave1(dt)
    if wave1.starts then    
        -- Current Wave 
        ws.current = 1
        -- Enemy spawn
        wave1.spawn = wave1.spawn - (1 * dt)
        -- 8 tanks at the top
        if wave1.spawn < 0 and wave1.counter < 8 then
            wave1.spawn = wave1.delay
            wave1.x = wave1.x + (enemy.tank_down:getWidth() * 3.5)
            wave1.y = (enemy.tank_down:getHeight() * -1)
            new_enemy = {x = wave1.x, y = wave1.y, origin_y = wave1.y, sprite = enemy.tank_down, direction = "down", wave = 1, speed = wave1.speed}
            table.insert(enemies, new_enemy)
            wave1.counter = wave1.counter + 1
        -- 2 tanks: 1 left 1 right
        elseif wave1.spawn < 0 and wave1.counter >= 8 and wave1.counter < 10 then
            wave1.spawn = wave1.delay
            -- Left
            if wave1.counter == 8 then
                wave1.x = (enemy.tank_right:getWidth() * -1)
                wave1.y = (screen_height / 2)
                new_enemy = {x = wave1.x, y = wave1.y, origin_x = wave1.x, sprite = enemy.tank_right, direction = "right", wave = 1, speed = wave1.speed}
                table.insert(enemies, new_enemy)
                wave1.counter = wave1.counter + 1
            -- Right
            elseif wave1.counter == 9 then
                wave1.x = screen_width + enemy.tank_left:getWidth()
                wave1.y = (screen_height / 2)
                new_enemy = {x = wave1.x, y = wave1.y, origin_x = wave1.x, sprite = enemy.tank_left, direction = "left", speed = wave1.speed}
                table.insert(enemies, new_enemy)
                wave1.counter = wave1.counter + 1
            end                
        elseif wave1.counter == 10 and #enemies == 0 then
            wave1.starts = false
            wave2.starts = true
        end
    end
end

-- Enemies Spawn (Wave 2)
function enemies_spawn_wave2(dt)
    if wave2.starts then
        -- Current Wave 
        ws.current = 2
        -- Enemy spawn
        wave2.spawn = wave2.spawn - (1 * dt)
        -- Delay and Counter
        if wave2.spawn < 0 and wave2.counter < 20 then
            -- Random Number from 1 to 3
            wave2.ramdom_number = math.random(3)

            -- Random Tanks at the Top
            if wave2.ramdom_number == 1 then
                wave2.spawn = wave2.delay
                -- Random position at x-axis
                wave2.rx = math.random(enemy.tank_down:getWidth(), screen_width - enemy.tank_down:getWidth())
                wave2.y = enemy.tank_down:getHeight() * -1
                -- New Enemy
                new_enemy = {x = wave2.rx, y = wave2.y, origin_y = wave2.y, sprite = enemy.tank_down, direction = "down", speed = wave2.speed}
                table.insert(enemies, new_enemy)
                wave2.counter = wave2.counter + 1

            -- Random Tanks at the left
            elseif wave2.ramdom_number == 2 then
                wave2.spawn = wave2.delay
                -- Random position at y-axis
                wave2.x = enemy.tank_right:getWidth() * -1
                wave2.ry = math.random(enemy.tank_right:getHeight(), screen_height - enemy.tank_right:getHeight())
                -- New Enemy
                new_enemy = {x = wave2.x, y = wave2.ry, origin_x = wave2.x, sprite = enemy.tank_right, direction = "right", speed = wave2.speed}
                table.insert(enemies, new_enemy)
                wave2.counter = wave2.counter + 1

            -- Random Tanks at the Right
            elseif wave2.ramdom_number == 3 then
                wave2.spawn = wave2.delay
                -- Random position at y-axis
                wave2.x = screen_width + enemy.tank_right:getWidth()
                wave2.ry = math.random(enemy.tank_left:getHeight(), screen_height - enemy.tank_left:getHeight())
                new_enemy = {x = wave2.x, y = wave2.ry, origin_x = wave2.x, sprite = enemy.tank_left, direction = "left", speed = wave2.speed}
                table.insert(enemies, new_enemy)
                wave2.counter = wave2.counter + 1
            end
        elseif wave2.counter == 20 and #enemies == 0 then
            wave2.starts = false
            wave3.starts = true
        end
    end
end

-- Big Enemies Spawn (Wave 3)
function enemies_spawn_wave3(dt)
    if wave3.starts and wave3.counter == 0 then
        ws.current = 3
        wave3.y = enemy.big_enemy_down:getHeight() * -1
        big_enemy1 = {x = (enemy.big_enemy_down:getWidth() * 1), y = wave3.y, origin_y = wave3.y, sprite = enemy.big_enemy_down, direction = "down", speed = wave3.speed, forward = true, life = wave3.life}
        table.insert(big_enemies, big_enemy1)
        big_enemy2 = {x = (enemy.big_enemy_down:getWidth() * 3), y = wave3.y, origin_y = wave3.y, sprite = enemy.big_enemy_down, direction = "down", speed = wave3.speed, forward = true, life = wave3.life}
        table.insert(big_enemies, big_enemy2)
        big_enemy3 = {x = (enemy.big_enemy_down:getWidth() * 5), y = wave3.y, origin_y = wave3.y, sprite = enemy.big_enemy_down, direction = "down", speed = wave3.speed, forward = true, life = wave3.life}
        table.insert(big_enemies, big_enemy3)
        -- Wave 3 ends 
        --wave3.starts = false
        wave3.counter = 3
        wave3.enemies = true
    elseif wave3.enemies and #big_enemies == 0 then
        wave3.starts = false
        wave3.enemies = false
        game.win = true
    end
end

-- Big Enemies Movement
function big_enemies_move(dt)
    for i, v in ipairs(big_enemies) do
         -- Big Tanks at the top
         if v.direction == "down" then
            if v.forward then
                v.y = v.y + v.speed * dt
                if v.y >= 0 then
                    v.forward = false
                end
            else
                v.y = v.y - (v.speed * dt)
                if v.y <= v.origin_y then
                    v.forward = true
                end                
            end
        end
    end
end

-- Enemies Move (Normal Tanks)
function enemies_move(dt)
    for i, v in ipairs(enemies) do
        -- Tanks at the top
        if v.direction == "down" then
            if v.y < (screen_height + v.sprite:getHeight()) then
                v.y = v.y + v.speed * dt
            else
                v.y = v.origin_y
            end

        -- Tanks at the left
        elseif v.direction == "right" then
            if v.x < (screen_width + v.sprite:getWidth()) then
                v.x = v.x + v.speed * dt
            else
                v.x = v.origin_x
            end

        -- Tanks at the Right
        elseif v.direction == "left" then
            if v.x > (v.sprite:getWidth() * -1) then
                v.x = v.x - v.speed * dt
            else
                v.x = v.origin_x
            end
        end   
    end
end

-- *** love.draw() Functions ***

-- Enemies Draw (Normal)
function enemies_draw()
    for i, enemy in ipairs(enemies) do
        love.graphics.draw(enemy.sprite, enemy.x, enemy.y)
    end
end

-- Big Enemies Draw
function big_enemies_draw()
    for i, big in ipairs(big_enemies) do
        love.graphics.draw(big.sprite, big.x, big.y)
    end
end

