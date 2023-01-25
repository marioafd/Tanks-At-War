-- life

-- *** PLAYER'S LIFE ***

-- Player's Life

function player_life()
    if player.life <= 0 then
        player.defeated = true
    end
end

-- Player's Life Draw

function player_life_draw()
    if player.life == 4 then
        love.graphics.setColor(255, 255, 255, 0.5)
        love.graphics.draw(player.life_4, 0, 0)
        love.graphics.setColor(255, 255, 255, 1)
    elseif player.life == 3 then
        love.graphics.setColor(255, 255, 255, 0.5)
        love.graphics.draw(player.life_3, 0, 0)
        love.graphics.setColor(255, 255, 255, 1)
    elseif player.life == 2 then
        love.graphics.setColor(255, 255, 255, 0.5)
        love.graphics.draw(player.life_2, 0, 0)
        love.graphics.setColor(255, 255, 255, 1)
    elseif player.life == 1 then
        love.graphics.setColor(255, 255, 255, 0.5)
        love.graphics.draw(player.life_1, 0, 0)
        love.graphics.setColor(255, 255, 255, 1)
    end
end