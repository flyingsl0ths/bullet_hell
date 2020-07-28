local janim = require 'lib/janim'
local Resource = {Sprite = {}, Image = {}, Sound = {}}

function Resource.load()
    Resource.Sprite.Player = janim.newSpriteSheet('assets/image/player_yellow.png', 12, 1)
    Resource.Image.Handgun = love.graphics.newImage('assets/image/handgun.png')
    Resource.Sprite.Bullet = love.graphics.newImage('assets/image/bullet.png')
    Resource.Image.Cursor = love.graphics.newImage('assets/image/cursor.png')

    -- Audio
    Resource.Sound.laser = love.audio.newSource('assets/sound/421704__bolkmar__sfx-laser-shoot-02.wav', 'static')
    Resource.Sound.laser:setVolume(0.5)
end

return Resource
