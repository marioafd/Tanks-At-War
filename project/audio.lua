-- AUDIO

-- ** MUSIC **

-- Main Menu and Game Music
function music()
    if play.main_music then
        if menu.main_menu or menu.controls then
            -- Stopping Another Music
            if audio.game:isPlaying() then
                audio.game:stop()
            end

            if audio.win_game:isPlaying() then
                audio.win_game:stop()
            end
            
            -- Playing the Main Menu
            if not audio.menu:isPlaying() then
                audio.menu:play()
            end       

        elseif game.starts then
            if not player.defeated then
                -- Stopping Another Music
                if audio.menu:isPlaying() then
                    audio.menu:stop()
                end

                if audio.win_game:isPlaying() then
                    audio.win_game:stop()
                end

                -- Playing The Game Music
                if not audio.game:isPlaying() then
                    audio.game:play()
                end
            else
                -- Stop All Music
                if audio.game:isPlaying() then
                    audio.game:stop()
                end
                
                if audio.menu:isPlaying() then
                    audio.menu:stop()
                end

                if audio.win_game:isPlaying() then
                    audio.win_game:stop()
                end
            end
        end
    else
        -- Stop Main Music
        if audio.game:isPlaying() then
            audio.game:stop()
        end
        
        if audio.menu:isPlaying() then
            audio.menu:stop()
        end
    end
end

-- Winner Music
function win_game_music()
    if play.win_game then
        play.main_music = false
        audio.win_game:play()
        audio.win_game:setLooping(false)
        play.win_game = false 
    end    
end

-- *** SOUND EFFECTS ***

-- Big Enemy Bullet
function big_ebullet_sound()
    audio.big_enemy_bullets:stop() 
    audio.big_enemy_bullets:play()
    audio.big_enemy_bullets:setLooping(false)    
end

-- Player Defeated
function player_defeated_sound()
    if play.player_defeated then
        audio.player_defeated:play()
        audio.player_defeated:setLooping(false)
        play.player_defeated = false 
    end    
end

-- Player Bullet
function pbullet_sound()
    audio.pbullets:stop()
    audio.pbullets:setPitch(8)
    if pbullet.shot_speed ~= 400 then
        audio.pbullets:setVolume(0.2)
    end    
    audio.pbullets:play()
    audio.pbullets:setLooping(false)    
end

-- Enemy Defeated
function enemy_defeated_sound()
    audio.enemy_defeated:stop()
    audio.enemy_defeated:play()
    audio.enemy_defeated:setLooping(false)    
end