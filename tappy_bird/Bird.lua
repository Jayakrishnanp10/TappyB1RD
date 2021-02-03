require "class"
Bird=class()
function Bird:init()
    self.image=love.graphics.newImage('bird.png')
    self.width=self.image:getWidth()
    self.height=self.image:getHeight()

    self.x=virtual_width/2-(self.width/2)
    self.y=virtual_height/2-(self.height/2)
    self.dy=0
end

function Bird:down(dt)
    self.y=math.min(virtual_height-30,self.y+100*dt)
end

function Bird:up(dt)
    self.y=math.max(0,self.y-300*dt)
end

function Bird:render()
    love.graphics.draw(self.image,self.x,self.y)
end

function Bird:collision(pipe)
    if self.x>pipe.x+pipe.width or self.x+self.width<pipe.x then
        return false
    end
    if self.y>pipe.y+pipe.height or self.y+self.height<pipe.y then
        return false
    end
    return true
end

