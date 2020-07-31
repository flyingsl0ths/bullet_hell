local GameObject = require 'prefabs/gameobject'
local Timer = require('component/timer')
local cmp = require 'component/common'

local Stinger = Class('Stinger', GameObject)
local DISTANCE_THRESHOLD = 20
local PATROL_DISTANCE = 100

local State = {
    ATTACK = {
        update = function(stinger, dt)
            local target_pos = stinger.target:get_pos()
            stinger:chase(target_pos, stinger.speed * dt)
        end,

        switch_state = function(stinger, state) stinger.state = state end
    },
    PATROL = {
        update = function(stinger, dt)
            stinger.accumulated_time = stinger.accumulated_time + dt
            
            if stinger.accumulated_time >= stinger.patrol_time or stinger:get_pos() == stinger.patrol_pos then
                stinger.patrol_spot = Vec2.random_unit():with_mag(
                                          PATROL_DISTANCE)
                stinger.accumulated_time = 0
            end
            stinger:chase(stinger.patrol_spot, stinger.speed * dt)
        end
    }
}

--[[
    The stinger enemy just roams around until the player is nearby.
    When the player gets close, it rotates to face to player and keeps shooting

    IF player is nearby:
        follow player while attacking every x seconds
    ELSE
        pick a random point k distance away every t seconds and follow it

]]

local function stinger_ai(st)
    local t = st:get_component(cmp.Transform)
    local nearby = st.world:query('circle', t.pos.x, t.pos.y, 30)
    local player_spotted = false
    for i = 1, #nearby do
        local ent = nearby[i]
        if ent.id == 'player' then
            player_spotted = true
            st:set_state(State.ATTACK)
            st.target = ent
        end
    end
    if not player_spotted then st:set_state(State.PATROL) end
end

function Stinger:init(world, x, y)
    GameObject.init(self, world, x, y)
    self:add_component(cmp.Collider, 10, 10)
    self:add_component(cmp.Sprite, Resource.Image.Stinger)
    self:add_component(Timer, 0.2, function() stinger_ai(self) end)

    self.speed = 30
    self.range = 30
    self.angular_vel = 0.174
    self.id = 'enemy'
    self.state = State.PATROL
    self.target = nil
    -- time accumulated since the last time the stinger picked a random point to roam to
    self.accumulated_time = 0
    self.patrol_spot = self:get_pos()
    self.patrol_time = 2
end

function Stinger:chase(target_pos, speed)
    local stinger_pos = self:get_pos()
    local vel = util.steer(stinger_pos, target_pos, Vec2(0, 0), speed)

    if (target_pos - stinger_pos):mag() > DISTANCE_THRESHOLD then
        self:move(vel)
        -- angle difference between PI and 2 * PI (2*PI is the same as 0 degrees, technically)
        self:set_rotation(vel:angle())
    end
end

function Stinger:_physics_process(dt) self.state.update(self, dt) end

function Stinger:set_state(state) self.state = state end

return Stinger
