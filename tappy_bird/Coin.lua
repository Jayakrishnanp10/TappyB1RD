require "class"
Coin=class()
Coins=love.graphics.newImage('coin.png')
coinscroll=-60
function Coin:init()
    self.width=Coins:getWidth()
    self.height=Coins:getHeight()
    self.x=virtual_width
    self.y=math.random(virtual_height/3+10,virtual_height-30)
end

function Coin:render()
    for k,pipe in pairs(pipes) do
        if self:collisionc(pipe) then
            self.x=self.x+(self.x-pipe.x)
            self.y=self.y+(self.y-pipe.y)
        end
    end
    love.graphics.draw(Coins,self.x,self.y)
end

function Coin:update(dt)
    self.x=self.x+coinscroll*dt
end

function Coin:collisionc(pipe)
    if self.x>pipe.x+pipe.width or self.x+self.width<pipe.x then
        return false
    end
    if self.y>pipe.y+pipe.height or self.y+self.height<pipe.y then
        return false
    end
    return true
end