require "class"
Pipe=class()
Pipes=love.graphics.newImage('pipes.png')
pipescroll=-60
function Pipe:init()
    self.width=Pipes:getWidth()
    self.height=Pipes:getHeight()
    self.x=virtual_width
    self.y=math.random(virtual_height/3+10,virtual_height-10)
end

function Pipe:render()
    love.graphics.draw(Pipes,self.x,self.y)
end
function Pipe:update(dt)
    self.x=self.x+pipescroll*dt
end