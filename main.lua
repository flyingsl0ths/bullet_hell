local shader = require 'shader'
local Level

_G.keyboard = love.keyboard
_G.mouse = love.mouse
_G.Input = {}

-- always do this !

_G.lg = love.graphics

math.randomseed(os.time())

local current_level
local CURSOR_SCALE = 5
local CURSOR_OFFSET = -4.5 * CURSOR_SCALE
-- replacing the cursor with the crosshair sprite

local crosshair

_G.mouseY = function()
    return love.mouse.getY()
end

_G.mouseX = function()
    return love.mouse.getX()
end

_G.mousePos = function() 
    return Vec2(love.mouse.getX(), love.mouse.getY())
end

local function draw_cursor()
    local x = love.mouse.getX() + CURSOR_OFFSET
    local y = love.mouse.getY() + CURSOR_OFFSET
    lg.setColor(1, 1, 1, 1)
    lg.draw(crosshair, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
end


local scale = 1
local SCREEN_OFFSET_X = 0

function love.load()
   
    -- Record the screen dimensions
    if settings.fullscreen then
        love.window.setMode(0, 0)
    end

    _G.SC_WIDTH = love.graphics.getWidth()
    _G.SC_HEIGHT = love.graphics.getHeight()

    scale =  SC_HEIGHT / NATIVE_HEIGHT
    SCREEN_OFFSET_X = (SC_WIDTH - NATIVE_WIDTH) / 4

    _G.DISPLAY_WIDTH = SC_WIDTH * scale
    _G.DISPLAY_HEIGHT = SC_HEIGHT * scale

    love.window.setMode(SC_WIDTH, SC_HEIGHT, {fullscreen = settings.fullscreen})

    love.graphics.setLineStyle('rough')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(sugar.rgb('000000'))

    Resource.load()
    crosshair = Resource.Image.Cursor
    --bla bla
    Level = require(DEBUG_MODE and 'scene_editor/editor' or 'world/level')
    current_level = Level()
    if not DEBUG_MODE then
    love.mouse.setVisible(false) end

    _G.Input = require 'lib.boipushy.input'()
    
    -- Resource.Sound.Track1:play()
end


local function show_debug_stats()
    lg.setColor(1, 1, 1, 0.5)
    lg.rectangle('fill', 0, 0, 200, 50)
    lg.setColor(0, 0, 0, 1)
    lg.print('FPS: ' .. love.timer.getFPS())
end

-- main canvas for shader effect

local main_canvas = love.graphics.newCanvas()

function love.draw()
    main_canvas:renderTo(function()
        lg.clear()
        current_level:draw()
        if not DEBUG_MODE then
        draw_cursor() end
    end)
    shader:send('time', love.timer.getTime())
    love.graphics.setShader(shader)
    lg.draw(main_canvas, SCREEN_OFFSET_X, 0, 0, scale, scale)
    love.graphics.setShader()
    -- show_debug_stats()
    -- *DEBUG CODE
end

function love.update(dt)
    current_level:update(dt)
    Timer.update(dt)
end


function love.mousepressed(x, y, button)
    current_level:mousepressed(x, y, button)
end

function love.wheelmoved(x, y)
    current_level:wheelmoved(x, y)
end

function love.keypressed(...)
    current_level:keypressed(...)
end