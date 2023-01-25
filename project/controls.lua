-- GAME CONTROLS

-- *** love.update() Functions ***

-- Controls Menu
function controls_menu()
    if love.keyboard.isDown('c') and not game.starts then
        menu.controls = true
        menu.main_menu = false        
    end
end

-- Go to Main Menu (in Controls Menu)
function controls_to_main()
    if love.keyboard.isDown('escape') and not menu.main_menu and not game.starts then
        menu.main_menu = true
        menu.controls = false
    end
end

-- Direction With Arrow Keys (Up, Down, Left, Right)
function directions(dt)
    if love.keyboard.isDown("up") then
        if player.y > 0 then
            player.y = player.y - player.speed * dt
            player.direction = "up"
        end
    end
    if love.keyboard.isDown("down") then
        if player.y < screen_height - player.tank_down:getHeight() then
            player.y = player.y + player.speed * dt
            player.direction = "down"
        end
    end
    if love.keyboard.isDown("left") then
        if player.x > 0 then
            player.x = player.x - player.speed * dt
            player.direction = "left"
        end
    end    
    if love.keyboard.isDown("right") then
        if player.x < screen_width - player.tank_right:getWidth() then
            player.x = player.x + player.speed * dt
            player.direction = "right"
        end
    end    
end

-- Pause The Game With 'Esc' Key
function pause_game(dt)
    pause.time = pause.time - (1 * dt)
    if love.keyboard.isDown("escape") and not player.defeated then
        if pause.time < 0 then
            pause.menu = not pause.menu
            pause.time = pause.delay
        end
    end
end

-- Restart The Game
function restart()
    if love.keyboard.isDown('return') and player.defeated then
        game.win = false
        audio.menu:stop()
        audio.game:stop()
        love.load()
    elseif love.keyboard.isDown('m') and player.defeated then
        game.win = false
        game.starts = false
        menu.main_menu = true
        audio.menu:stop()
        audio.game:stop()
        love.load()
    end
end

-- Restart The Game
function restart_win()
    if love.keyboard.isDown('return') and game.win then
        game.win = false
        love.load()
    elseif love.keyboard.isDown('m') and game.win then
        game.win = false
        game.starts = false
        menu.main_menu = true
        love.load()
    end
end

-- Speed Up The Purple Tank (Player)
function speed_up()
    if love.keyboard.isDown("x") then
        player.speed = 300
    else
        player.speed = 50
    end
end

-- Start The Game
function start_game()
    if love.keyboard.isDown('return') and not menu.controls then
        menu.main_menu = false
        game.starts = true
    end
end

-- *** love.draw() Functions ***

-- Controls Menu Screen
function controls_menu_draw()
    love.graphics.draw(bg.controls, 0, 0, 0, 0.67, 0.67)
    if math.floor(love.timer.getTime()) % 2 == 0 then
        love.graphics.draw(bg.press_esc, 0, 0, 0, 0.67, 0.67)
    end
end

-- Draw Player's Direction (Tank Sprite)
function directions_draw()
    if player.direction == 'up' then
        tank_direction = player.tank_up
        return tank_direction    
    elseif player.direction == 'down' then
        tank_direction = player.tank_down
        return tank_direction
    elseif player.direction == 'left' then
        tank_direction = player.tank_left
        return tank_direction
    elseif player.direction == 'right' then
        tank_direction = player.tank_right
        return tank_direction
    elseif player.direction == 'defeated' then
        tank_direction = player.tank_defeated
        return tank_direction
    end
end

-- Main Menu Screen
function main_menu_draw()
love.graphics.draw(bg.menu, 0, 0, 0, 0.67, 0.67)
    if math.floor(love.timer.getTime()) % 2 == 0 then
        love.graphics.draw(bg.press_enter, 0, 0, 0, 0.67, 0.67)
    end
end

-- Pause Screen
function pause_draw()
    if pause.menu then        
        love.graphics.setColor( 0, 0, 0, 0.5)
        love.graphics.rectangle('fill', 0, 0, screen_width, screen_height) 
        love.graphics.setColor( 255, 255, 255)
        if math.floor(love.timer.getTime()) % 2 == 0 then
            love.graphics.draw(bg.resume, 0, 0, 0, 0.67, 0.67)
        end 
        love.graphics.draw(bg.pause_controls, 0, 0, 0, 0.67, 0.67)    
    end    
end

-- You Won Screen Draw
function you_won_draw()
    love.graphics.draw(bg.you_won, 0, 0, 0, 0.67, 0.67)
end