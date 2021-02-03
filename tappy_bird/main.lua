

window_width=1280
window_height=720

virtual_width=450
virtual_height=249

require 'class'
push=require 'push'
require 'Bird'
bird=Bird()
require 'Pipe'
pipes={}
require 'Coin'
coins={}
spawnTimer=0
coinTimer=0

gamestate='start'
background = love.graphics.newImage("background.png")
bgscroll=0
score=0

ground = love.graphics.newImage("ground.png")
groundscroll=0

pause = love.graphics.newImage("pause.png")
resume = love.graphics.newImage("resume.png")
quit = love.graphics.newImage("quit.png")

function love.load()
    love.window.setTitle("TAPPY B1RD")
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(0,.5,0)
    font2=love.graphics.newFont("AbstractGroovy-K7Zdy.ttf",20)
    font1=love.graphics.newFont("BalonkuRegular-la1w.otf",20)
    math.randomseed(os.time())
    sounds={
    ["score"]=love.audio.newSource("sounds/score.wav","static"),
    ["music"]=love.audio.newSource("sounds/music.mp3","stream")
    }
    push:setupScreen(virtual_width,virtual_height,window_width,window_height,{
        fullscreen=false,
        resizable=true,
        vsync=true
    })
    gamestate="start"
    
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    --[[if key=='space' then
        if gamestate=='start' then
            gamestate='play'
        end
        if gamestate=='finished' then
            score=0
            pipes={}
            coins={}
            spawnTimer=0
            coinTimer=0
            bgscroll=0
            groundscroll=0
            gamestate='play'
        end
    end]]--
    
end

function love.touchpressed( id, x, y, dx, dy, pressure )
    if pressure==1 then
        if gamestate=='start' then
            gamestate='play'
        end
        if gamestate=='finished' then
            if x<window_width/2 then
                love.event.quit()
            elseif x<window_width-70 then
                score=0
                pipes={}
                coins={}
                spawnTimer=0
                coinTimer=0
                bgscroll=0
                groundscroll=0
                gamestate='play'
            end
        end
        if gamestate=='play' then
            if x>virtual_width-70 and y<70 then
                gamestate='pause'
            end
        end
        if gamestate=='pause' then
            if x<window_width/2 then
                love.event.quit()
            elseif x<window_width-70 then
                gamestate='play'
            end
        end
    end
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)
    bgscroll=(bgscroll+30*dt)%900
    groundscroll=(groundscroll+60*dt)%450
    spawnTimer=spawnTimer+dt
    coinTimer=coinTimer+dt
    sounds["music"]:play(true)
    if gamestate=='play' then
        if spawnTimer>3 then
            table.insert(pipes,Pipe())
            spawnTimer=0
        end
        if coinTimer>4 then
            table.insert(coins,Coin())
            coinTimer=0
        end
        if next(love.touch.getTouches()) ~= nil then
            bird:up(dt)
        else
            bird:down(dt)
        end
    --if love.keyboard.isDown('down') then
        for k,pipe in pairs(pipes) do
            pipe:update(dt)
            if bird.x+bird.width/2>pipe.x+(pipe.width/2) and bird.x+bird.width/2-1<pipe.x+(pipe.width/2) then
                score=score+1
            end
            if pipe.x<-pipe.width then
                table.remove(pipes,k)
            end
            if bird:collision(pipe) then
                gamestate='finished'
            end
        end
        for g,coin in pairs(coins) do
            coin:update(dt)
            if bird:collision(coin) then
                score=score+10
                sounds["score"]:play()
                table.remove(coins,g)
            elseif coin.x<-coin.width then
                table.remove(coins,g)
            end
        end
    end
end

function love.draw()
    push:start()
    love.graphics.setFont(font1)
    love.graphics.draw(background,-bgscroll,0)
    if gamestate=='start' then
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf("TAPPY B1RD",0,virtual_height/2-100,virtual_width,'center')
        love.graphics.setFont(font2)
        love.graphics.printf("tap anywhere to play",0,virtual_height/2,virtual_width,'center')
    end
    love.graphics.setColor(1,1,1,1)
    bird:render()
    if gamestate=='play' then
        love.graphics.setColor(0,0,0,1)
        love.graphics.setFont(font2)
        love.graphics.printf(score,0,virtual_height/2-100,virtual_width,'center')
        love.graphics.setColor(1,1,1,1)
        for k,pipe in pairs(pipes) do
            pipe:render()
        end
        for g,coin in pairs(coins) do
            coin:render()
        end
        love.graphics.draw(pause,virtual_width-25,5)
    end
    love.graphics.draw(ground,-groundscroll,virtual_height-6)
    if gamestate=='finished' then
        love.graphics.setColor(0,0,0,1)
        love.graphics.setFont(font1)
        love.graphics.printf('score',0,virtual_height/2-110,virtual_width,'center')
        love.graphics.setFont(font2)
        love.graphics.printf(score,0,virtual_height/2-90,virtual_width,'center')
        love.graphics.draw(resume,virtual_width/2+25,virtual_height/2)
        love.graphics.draw(quit,virtual_width/2-25,virtual_height/2)
    end
    if gamestate=='pause' then
        love.graphics.setColor(0,0,0,1)
        
        love.graphics.setFont(font2)
        love.graphics.printf(score,0,virtual_height/2-90,virtual_width,'center')
        love.graphics.draw(resume,virtual_width/2+25,virtual_height/2)
        love.graphics.draw(quit,virtual_width/2-25,virtual_height/2)
    end
    push:finish()
end