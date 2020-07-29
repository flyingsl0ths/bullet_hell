local Transform = require 'component/transform'
-- *AABB rect collider

local Collider = Class('Collider')

function Collider:init(entity, width, height, class)
    self.owner = entity
    self.width = width
    self.height = height
    self.class = class or ''
    self.mask = {}
end


function Collider:check_mask(class)
    return self.mask[class]
end

function Collider:get_pos()
    assert(self.owner:has_component(Transform), 'no transform component on collider parent')
    -- transform is the center coordinate
    return self.owner:get_component(Transform).pos
end

function Collider.checkAABB(r1, r2)
    local p1 = r1.get_pos() - Vec2(r1.width / 2, r1.height / 2)
    local p2 = r2.get_pos() - Vec2(r2.width / 2, r2.height / 2)
    return not ((p1.x > p2.x + r2.width) or
        (p1.x + r1.width < p2.x) or
        (p1.y + r1.height < p2.y) or
        (p1.y > p2.y + r2.height))
end

function Collider.AABBdir(a, b)
    local apos = a:get_pos()
    local bpos = b:get_pos()
    local dist = apos - bpos

    if math.abs(dist.x) == math.abs(dist.y) then
        if dist.y > 0 then return 'down' end
        return 'up'
    elseif math.abs(dist.x) > math.abs(dist.y) then
        if (dist.x > 0) then return 'right' end
        return 'left'
    end

    if dist.y > 0 then return 'down' end
    return 'up'
end

function Collider:draw()
    local pos = self:get_pos()
    love.graphics.rectangle('line', pos.x, pos.y, self.width, self.height)
end


function Collider:update(dt)
    -- body
end

function Collider:delete()
    
end

return Collider