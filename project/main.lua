require 'audio'
require 'collisions'
require 'controls'
require 'ebullets'
require 'enemies'
require 'items'
require 'life'
require 'pbullets'
require 'waiting'

-- GLOBALS VARIABLES

-- Fonts
fonts = {}
fonts.default = love.graphics.newFont(12)

-- Main menu
menu = {}
menu.main_menu = true
menu.controls = false

-- Game
game = {}
game.starts = false
game.win = false

-- Waiting Time
time = {}
time.restart = 0
time.wave3_shot = 0


-- Pause Menu
pause = {}
pause.menu = false
pause.delay = 1
pause.time = 1

-- Screen Resolution
screen_width = love.graphics.getWidth()
screen_height = love.graphics.getHeight()

function love.load()
    
    -- Player Variables (Purple Tank)
    player = {}
    player.defeated = false
    player.x = screen_width/2
    player.y = screen_height - 64
    player.speed = 50
    player.tank_up = love.graphics.newImage('sprites/player/tank-up.png')
    player.tank_down = love.graphics.newImage('sprites/player/tank-down.png')
    player.tank_left = love.graphics.newImage('sprites/player/tank-left.png')
    player.tank_right = love.graphics.newImage('sprites/player/tank-right.png')
    player.tank_defeated = love.graphics.newImage('sprites/player/player-defeated.png')
    player.direction = "up"
    player.bullet = love.graphics.newImage('sprites/player/bullet.png')  
    player.life = 4
    player.life_4 =  love.graphics.newImage('sprites/player/life-4.png')
    player.life_3 =  love.graphics.newImage('sprites/player/life-3.png')   
    player.life_2 =  love.graphics.newImage('sprites/player/life-2.png')   
    player.life_1 =  love.graphics.newImage('sprites/player/life-1.png')      

    -- Background
    bg = {}
    -- Main Menu
    bg.menu = love.graphics.newImage('sprites/background/background_menu.jpg')
    bg.press_enter = love.graphics.newImage('sprites/background/press_enter_to_start.png')
    -- Controls Menu
    bg.controls = love.graphics.newImage('sprites/background/background_controls.jpg')
    bg.press_esc = love.graphics.newImage('sprites/background/press_esc_to_return.png')
    -- Game  
    bg.background = love.graphics.newImage('sprites/background/background_light.jpg')
    -- Pause Menu
    bg.pause_controls = love.graphics.newImage('sprites/background/controls_pause.png')
    bg.resume = love.graphics.newImage('sprites/background/press_esc_to_resume.png')
    -- Defeated Screen
    bg.defeated = love.graphics.newImage('sprites/background/background_defeated.jpg')
    bg.restart = love.graphics.newImage('sprites/background/press_enter_to_restart.png')
    -- You Won Screen
    bg.you_won = love.graphics.newImage('sprites/background/you_won_screen.jpg')

    -- Audio
    audio = {}
    -- Main Menu Theme
    audio.menu = love.audio.newSource('audio/main_menu_music.wav', 'stream')
    -- Game Music
    audio.game = love.audio.newSource('audio/game_music.wav', 'stream')
    -- Win Game Music
    audio.win_game = love.audio.newSource('audio/win_game.wav', 'stream')
    -- Player Bullets Sound
    audio.pbullets = love.audio.newSource('audio/player_bullets_sound.wav', 'static')
    -- Player Defeated
    audio.player_defeated = love.audio.newSource('audio/player_defeated_sound.wav', 'static')
    -- Enemy Defeated
    audio.enemy_defeated = love.audio.newSource('audio/enemy_defeated_sound.wav', 'static')
    -- Big Enemy Bullets
    audio.big_enemy_bullets = love.audio.newSource('audio/big_enemy_bullets_sound.wav', 'static')

    -- Audio Booleans
    play = {}
    play.main_music = true
    play.player_defeated = true
    play.win_game = true
    play.pbullets = false    

    -- General
    -- (to Restart)
    restart_screen = false
end

function love.update(dt)
    -- Audio
    music()    

    if not game.win then
        start_game()
        controls_menu()
        controls_to_main()
    end    
    if not menu.main_menu and not menu.controls and not game.win then
        -- Game Starts
        game.starts = true
        pause_game(dt)        
        if not pause.menu and not player.defeated then
            -- Player            
            directions(dt)
            speed_up()
            player_shot(dt)
            player_life()
            
            -- Enemies
            enemy_shot_config()
            enemy_shot(dt) 
            enemy_shot_movement(dt)
            edefeated_disappear(dt)
            enemies_move(dt)

            -- Items
            items_spawn()
            
            -- Waves
            enemies_spawn_wave1(dt)            
            enemies_spawn_wave2(dt)            
            enemies_spawn_wave3(dt)

            -- Big Enemies
            big_enemies_move(dt)
            big_enemy_shot_wave3(dt)
            big_enemy_shot_movement(dt)           

            -- Collisions
            pbullet_to_enemy()            
            ebullet_to_player()
            bullet_to_bullet()
            tank_to_tank()
            collected_item()
            big_enemy_to_tank()
            pbullet_to_big_enemy()
            pbullet_to_big_bullet()
            big_ebullet_to_player()

        elseif player.defeated then
            -- Player Defeated
            -- Sound Effect
            player_defeated_sound()

            -- Wait 3 seconds for draw the "Lost Screen"            
            if wait_restart(dt, 3) or restart_screen == true then
                restart_screen = true
                player_defeated()
                restart()                                
            end            
        end
    elseif game.win then
        win_game_music()
        player_defeated()
        restart_win()
    end
end

function love.draw()    
    
    -- Game
    if game.starts and not menu.main_menu and not menu.controls and not game.win then
        -- Background
        love.graphics.draw(bg.background, 0, 0, 0, 0.67, 0.67)        
        
        -- Items
        items_draw()

        -- Enemies
        enemies_draw()
        enemy_shot_draw()
        edefeated_disappear_draw() 
        big_enemies_draw()
        big_enemy_shot_draw()
        
        -- Pause Menu
        pause_draw()
        
        -- Player
        love.graphics.draw(directions_draw(), player.x, player.y)
        player_shot_draw()
        player_life_draw()

        -- Player Defeated Screen
        if player.defeated then
            player.direction = 'defeated' 
            -- Defeated Screen
            if restart_screen == true then
                player_defeated_draw()
            end              
        end    
    -- Main Menu
    elseif menu.main_menu then
        main_menu_draw()
    elseif menu.controls then
    -- Controls Menu
        controls_menu_draw()
    -- You Won Screen
    elseif game.win then
        you_won_draw() 
    end
end