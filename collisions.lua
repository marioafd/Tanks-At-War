-- COLLISIONS

-- Enemy Defeated Table
defeated = {}
defeated.enemy_sprite = love.graphics.newImage('sprites/enemies/enemy-defeated.png')
defeated.big_enemy_sprite = love.graphics.newImage('sprites/enemies/big-enemy-defeated.png')
defeated.enemies = {}

--[[
    CONDITIONS:
    1- X1 < X2 + W2
    2- X2 < X1 + W1
    3- Y1 < Y2 + H2
    4- Y2 < Y1 + H1
]]

-- Collisions (Main Function)
function collisions(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

-- Big Enemies Collision
function big_enemy_to_tank()
    for i, enemy in ipairs(big_enemies) do
        if collisions(enemy.x, enemy.y, enemy.sprite:getWidth(), enemy.sprite:getHeight(), player.x, player.y, current_psprite():getWidth(), current_psprite():getHeight()) then
            player.life = 0
        end
    end 
end

-- Bullet to Bullet Collision (pb = player's bullet, eb = enemy bullet)
function bullet_to_bullet()
    for i, pb in ipairs(pbullet.bullets) do
        for j, eb in ipairs(ebullet.bullets) do
            if collisions(pb.x, pb.y, pb.img:getWidth(), pb.img:getHeight(), eb.x, eb.y, eb.img:getWidth(), eb.img:getHeight()) then
                table.remove(pbullet.bullets, i)
                table.remove(ebullet.bullets, j)
            end
        end
    end
end

-- PLayer Bullet vs Big Bullet Collision
function pbullet_to_big_bullet()
    for i, pb in ipairs(pbullet.bullets) do
        for j, eb in ipairs(big_ebullet.bullets) do
            if collisions(pb.x, pb.y, pb.img:getWidth(), pb.img:getHeight(), eb.x, eb.y, eb.img:getWidth(), eb.img:getHeight()) then
                table.remove(pbullet.bullets, i)
            end
        end
    end
end

-- Collected Item
function collected_item()
    for i, v in ipairs(items.draw) do
        if collisions(v.x, v.y, v.img:getWidth(), v.img:getHeight(), player.x, player.y, current_psprite():getWidth(), current_psprite():getHeight()) then
            if v.item == 'life_restored' then
                player.life = 4
                table.remove(items.draw, i)
            elseif v.item == 'fast_shot' then
                pbullet.shot_delay = 0.01
                pbullet.shot_speed = 1000
                table.remove(items.draw, i)
            end
        end
    end
end

-- Current Player's Sprite
function current_psprite()
    if player.direction == 'up' then
        return player.tank_up
    elseif player.direction == 'down' then
        return player.tank_down
    elseif player.direction == 'left' then
        return player.tank_left
    elseif player.direction == 'right' then
        return player.tank_right
    end
end

-- Player Defeated
function player_defeated()
    if player.defeated or game.win then
        -- Enemies Sprites (enemies.lua)               
        for i = 1, #enemies do
            table.remove(enemies)  
        end

        -- Big Enemies
        for i = 1, #big_enemies do
            table.remove(big_enemies)
        end

        -- Current Wave
        ws.current = 0

        -- *** WAVE 1 !!! ***
        wave1.counter = 0
        wave1.spawn = wave1.delay
        wave1.x = wave1.x_default
        wave1.starts = true

        -- *** WAVE 2 !!! ***
        wave2.counter = 0
        wave2.spawn = wave2.delay
        wave2.starts = false

        -- *** WAVE 3 !!! ***
        wave3.counter = 0
        wave2.spawn = wave2.delay
        wave3.starts = false
        wave3.enemies = false
        big_ebullet.counter = 0

        -- *** GENERAL ***

        -- Enemies Bullets
        for i = 1, #ebullet.bullets do
            table.remove(ebullet.bullets)
        end

        -- Big Enemies Bullets
        for i = 1, #big_ebullet.bullets do
            table.remove(big_ebullet.bullets)
        end

        -- Enemies Defeated
        for i = 1, #defeated.enemies do
            table.remove(defeated.enemies)
        end

        -- Player's Bullets (pbullets.lua)
        for i = 1, #pbullet.bullets do
            table.remove(pbullet.bullets)
        end
        pbullet.shot_delay = pbullet.shot_delay_default                              
        pbullet.shot_time = pbullet.shot_delay
        pbullet.shot_speed = pbullet.shot_speed_default
        
        -- Items
        for i, v in ipairs(items.draw) do
            table.remove(items.draw)
        end

        -- Reset Waiting Time (main.lua)
        time.restart = 0
        time.wave3_shot = 0

        -- Reset Items
        items.wave2 = true
        items.wave3 = true
    end
end

-- Enemy Bullets Shot to The Player
function ebullet_to_player()
    for i, bullet in ipairs(ebullet.bullets) do
        if collisions(bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight(), player.x, player.y, current_psprite():getWidth(), current_psprite():getHeight()) then
            table.remove(ebullet.bullets, i)
            player.life = player.life - 1
        end
    end
end

-- Big Enemy Bullets Shot to The Player
function big_ebullet_to_player()
    for i, bullet in ipairs(big_ebullet.bullets) do
        if collisions(bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight(), player.x, player.y, current_psprite():getWidth(), current_psprite():getHeight()) then
            table.remove(big_ebullet.bullets, i)
            player.life = player.life - 3
        end
    end
end

function edefeated_disappear(dt)
    for i, v in ipairs(defeated.enemies) do
        v.count = v.count + (1 * dt)
        if v.count >= 2 then
            table.remove(defeated.enemies, i)
        end
    end
end

-- Player's bullets shot to The Enemies
function pbullet_to_enemy()
    for i, bullet in ipairs(pbullet.bullets) do
        for j, enemy in ipairs(enemies) do
            if collisions(bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight(), enemy.x, enemy.y, enemy.sprite:getWidth(), enemy.sprite:getHeight()) then
                -- Sound Effect
                enemy_defeated_sound()

                -- Enemy Defeated
                enemy_defeated = {x = enemy.x, y = enemy.y, img = defeated.enemy_sprite, count = 0}
                table.insert(defeated.enemies, enemy_defeated)
                table.remove(pbullet.bullets, i)
                table.remove(enemies, j)
            end
        end
    end    
end

-- Player's bullets shot to The Big Enemies
function pbullet_to_big_enemy()
    for i, bullet in ipairs(pbullet.bullets) do
        for j, enemy in ipairs(big_enemies) do
            if collisions(bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight(), enemy.x, enemy.y, enemy.sprite:getWidth(), enemy.sprite:getHeight()) then
                
                enemy.life = enemy.life - 1                
                table.remove(pbullet.bullets, i)

                if enemy.life <= 0 then
                    -- Sound Effect
                    enemy_defeated_sound()

                    -- Big Enemy Defeated
                    enemy_defeated = {x = enemy.x, y = enemy.y, img = defeated.big_enemy_sprite, count = 0}
                    table.insert(defeated.enemies, enemy_defeated)
                    table.remove(pbullet.bullets, i)
                    table.remove(big_enemies, j)
                end
            end
        end
    end    
end

-- Tank to Tank Collision
function tank_to_tank()
    for i, enemy in ipairs(enemies) do
        if collisions(enemy.x, enemy.y, enemy.sprite:getWidth(), enemy.sprite:getHeight(), player.x, player.y, current_psprite():getWidth(), current_psprite():getHeight()) then
            player.life = 0
        end
    end 
end

-- *** love.draw() Functions ***

-- Disappear Defeated Enemies
function edefeated_disappear_draw()
    for i, v in ipairs(defeated.enemies) do
        love.graphics.draw(v.img, v.x, v.y)
    end
end

-- Draw "You Lost" Screen (Player Defeated)
function player_defeated_draw()
    love.graphics.draw(bg.defeated, 0, 0, 0, 0.67, 0.67)
    if math.floor(love.timer.getTime()) % 2 == 0 then
        love.graphics.draw(bg.restart, 0, 0, 0, 0.67, 0.67)
    end
end