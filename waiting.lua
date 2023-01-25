-- WAITING

-- Waiting Time for Restart
function wait_restart(dt, seconds)
    if time.restart < seconds then 
        time.restart = time.restart + (1 * dt)
        return false
    else
        time.restart = 0
        return true
    end
end

-- Waiting Time for Big Enemies Bullets (Wave 3)
function wait_big_bullet_w3(dt, seconds)
    if time.wave3_shot < seconds then 
        time.wave3_shot = time.wave3_shot + (1 * dt)
        return false
    else
        time.wave3_shot = 0
        return true
    end
end