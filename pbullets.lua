-- PLAYER'S BULLETS

-- Player's Bullets (Main Configuration)
pbullet = {}
pbullet.shot = false
pbullet.shot_delay_default = 0.2
pbullet.shot_delay = pbullet.shot_delay_default
pbullet.shot_time = pbullet.shot_delay
pbullet.shot_direction = ''
pbullet.shot_speed_default = 400
pbullet.shot_speed = pbullet.shot_speed_default
pbullet.bullets = {}

-- *** love.update() Function ***

function player_shot(dt)
    -- Shot delay
    pbullet.shot_time = pbullet.shot_time - (1 * dt)
    if pbullet.shot_time < 0 then
        pbullet.shot = true
    end
    -- Shot within the time allowed
    if love.keyboard.isDown("s") and pbullet.shot then
        -- Sound Effect
        pbullet_sound()
        
        -- Bullet Elements
        bullet = {img = player.bullet, shot_direction = player.direction}
        -- Initial location of the bullet
        if bullet.shot_direction == 'up' then
            bullet.x = player.x + (player.tank_up:getWidth() / 2)
            bullet.y = player.y
        elseif bullet.shot_direction == 'down' then
            bullet.x = player.x + (player.tank_down:getWidth() / 2)
            bullet.y = player.y + player.tank_down:getHeight()
        elseif bullet.shot_direction == 'left' then
            bullet.x = player.x
            bullet.y = player.y + (player.tank_left:getHeight() / 2)
        elseif bullet.shot_direction == 'right' then
            bullet.x = player.x + player.tank_right:getWidth()
            bullet.y = player.y + (player.tank_right:getHeight() / 2)
        end
        table.insert(pbullet.bullets, bullet)
        pbullet.shot = false
        pbullet.shot_time = pbullet.shot_delay
    end
    for i, bullet in ipairs(pbullet.bullets) do
        -- Shot direction: UP
        if bullet.shot_direction == 'up' then
            bullet.y = bullet.y - (pbullet.shot_speed * dt)
            if bullet.y < 0 then
                table.remove(pbullet.bullets, i)
            end
        -- Shot direction: DOWN
        elseif bullet.shot_direction == 'down' then
            bullet.y = bullet.y + (pbullet.shot_speed * dt)
            if bullet.y > screen_height then
                table.remove(pbullet.bullets, i)
            end
        -- Shot direction: LEFT
        elseif bullet.shot_direction == 'left' then
            bullet.x = bullet.x - (pbullet.shot_speed * dt)
            if bullet.x < 0 then
                table.remove(pbullet.bullets, i)
            end
        -- Shot direction: RIGHT
        elseif bullet.shot_direction == 'right' then
            bullet.x = bullet.x + (pbullet.shot_speed * dt)
            if bullet.x > screen_width then
                table.remove(pbullet.bullets, i)
            end
        end
    end
end

-- *** love.draw() Function ***

function player_shot_draw()
    for k, bullet in pairs(pbullet.bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y, 0, 1, 1, bullet.img:getWidth() / 2, bullet.img:getHeight() / 2) 
    end    
end

