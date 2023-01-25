-- ENEMY'S BULLETS

-- Normal Enemies
ebullet = {}
ebullet.shot = false
ebullet.shot_delay = 0.3
ebullet.shot_time = ebullet.shot_delay
ebullet.shot_speed = 400
ebullet.bullets = {}

-- Big Enemies
big_ebullet = {}
big_ebullet.shot = false
big_ebullet.shot_delay = 0.1
big_ebullet.shot_time = ebullet.shot_delay
big_ebullet.shot_speed = 1500
big_ebullet.counter = 0
big_ebullet.bullets = {}

-- *** love.update() Function ***

-- Big Enemies Bullets

function big_enemy_shot(dt)
    -- Reset big_ebullet.counter if == 20
    if big_ebullet.counter >= 20 then
        big_ebullet.counter = 0
    end

    -- Waiting Time
    if big_ebullet.counter == 0 then
        if wait_big_bullet_w3(dt, 5) then
            big_ebullet.counter = 1
        end
    else
        -- Shot delay
        big_ebullet.shot_time = big_ebullet.shot_time - (1 * dt)
        if big_ebullet.shot_time < 0 then
            big_ebullet.shot = true
        end
        -- Shot within the time allowed
        if big_ebullet.shot then
            -- Sound Effect
            if big_ebullet.counter == 1 then
                big_ebullet_sound()
            end

            -- Big Enemy Bullet
            for i, enemy_table in ipairs(big_enemies) do
                new_ebullet = {img = enemy.big_enemy_bullet, shot_direction = enemy_table.direction}
                -- Initial location of the bullet
                if new_ebullet.shot_direction == 'down' then
                    new_ebullet.x = enemy_table.x + (enemy.big_enemy_down:getWidth() / 2)
                    new_ebullet.y = enemy_table.y + enemy.big_enemy_down:getHeight()
                end
                table.insert(big_ebullet.bullets, new_ebullet)
                big_ebullet.shot = false
                big_ebullet.shot_time = big_ebullet.shot_delay
            end
            -- Updating the Bullet Counter
            big_ebullet.counter = big_ebullet.counter + 1
        end
    end
end

-- Wave 3 Big Enemies Bullets
function big_enemy_shot_wave3(dt)
    if ws.current == 3 then
        big_enemy_shot(dt)
    end
end

-- Big Enemy Bullets Movement
function big_enemy_shot_movement(dt)
    -- Bullet shot (bs)
    for i, bs in ipairs(big_ebullet.bullets) do
        -- Shot direction: UP
        if bs.shot_direction == 'up' then
            bs.y = bs.y - (big_ebullet.shot_speed * dt)
            if bs.y < 0 then
                table.remove(big_ebullet.bullets, i)
            end
        -- Shot direction: DOWN
        elseif bs.shot_direction == 'down' then
            bs.y = bs.y + (big_ebullet.shot_speed * dt)
            if bs.y > screen_height then
                table.remove(big_ebullet.bullets, i)
            end
        -- Shot direction: LEFT
        elseif bs.shot_direction == 'left' then
            bs.x = bs.x - (big_ebullet.shot_speed * dt)
            if bs.x < 0 then
                table.remove(big_ebullet.bullets, i)
            end
        -- Shot direction: RIGHT
        elseif bs.shot_direction == 'right' then
            bs.x = bs.x + (big_ebullet.shot_speed * dt)
            if bs.x > screen_width then
                table.remove(big_ebullet.bullets, i)
            end
        end
    end
end

-- Bullets Speed and Delay According to the Wave
function enemy_shot_config()
    if ws.current == 1 then
        ebullet.shot_delay = 0.9
        ebullet.shot_speed = 200
    elseif ws.current == 2 then
        ebullet.shot_delay = 0.3
        ebullet.shot_speed = 400
    end    
end

-- Enemies Bullets (Normal)
function enemy_shot(dt)
    -- Shot delay
    ebullet.shot_time = ebullet.shot_time - (1 * dt)
    if ebullet.shot_time < 0 then
        ebullet.shot = true
    end
    -- Shot within the time allowed
    if ebullet.shot then
        for i, enemy_table in ipairs(enemies) do
            new_ebullet = {img = enemy.bullet, shot_direction = enemy_table.direction}
            -- Initial location of the bullet
            if new_ebullet.shot_direction == 'up' then
                new_ebullet.x = enemy_table.x + (enemy.tank_up:getWidth() / 2)
                new_ebullet.y = enemy_table.y
            elseif new_ebullet.shot_direction == 'down' then
                new_ebullet.x = enemy_table.x + (enemy.tank_down:getWidth() / 2)
                new_ebullet.y = enemy_table.y + enemy.tank_down:getHeight()
            elseif new_ebullet.shot_direction == 'left' then
                new_ebullet.x = enemy_table.x
                new_ebullet.y = enemy_table.y + (enemy.tank_left:getHeight() / 2)
            elseif new_ebullet.shot_direction == 'right' then
                new_ebullet.x = enemy_table.x + enemy.tank_right:getWidth()
                new_ebullet.y = enemy_table.y + (enemy.tank_right:getHeight() / 2)
            end
            table.insert(ebullet.bullets, new_ebullet)
            ebullet.shot = false
            ebullet.shot_time = ebullet.shot_delay
        end
    end
end

-- Enemies Bullet Movement
function enemy_shot_movement(dt)
    -- Bullet shot (bs)
    for i, bs in ipairs(ebullet.bullets) do
        -- Shot direction: UP
        if bs.shot_direction == 'up' then
            bs.y = bs.y - (ebullet.shot_speed * dt)
            if bs.y < 0 then
                table.remove(ebullet.bullets, i)
            end
        -- Shot direction: DOWN
        elseif bs.shot_direction == 'down' then
            bs.y = bs.y + (ebullet.shot_speed * dt)
            if bs.y > screen_height then
                table.remove(ebullet.bullets, i)
            end
        -- Shot direction: LEFT
        elseif bs.shot_direction == 'left' then
            bs.x = bs.x - (ebullet.shot_speed * dt)
            if bs.x < 0 then
                table.remove(ebullet.bullets, i)
            end
        -- Shot direction: RIGHT
        elseif bs.shot_direction == 'right' then
            bs.x = bs.x + (ebullet.shot_speed * dt)
            if bs.x > screen_width then
                table.remove(ebullet.bullets, i)
            end
        end
    end
end

-- *** love.draw() Function ***

-- Normal Enemies Shot
function enemy_shot_draw()
    for k, bs in pairs(ebullet.bullets) do
        love.graphics.draw(bs.img, bs.x, bs.y, 0, 1, 1, bs.img:getWidth() / 2, bs.img:getHeight() / 2) 
    end    
end

-- Big Enemies Shot
function big_enemy_shot_draw()
    for k, bs in pairs(big_ebullet.bullets) do
        love.graphics.draw(bs.img, bs.x, bs.y, 0, 1, 1, bs.img:getWidth() / 2, bs.img:getHeight() / 2) 
    end    
end