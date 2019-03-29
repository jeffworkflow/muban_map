--物品名称
local mt = ac.skill['攻速光环']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
    max_level = 5,
	--技能类型
	skill_type = "光环",
	--被动
	passive = true,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[所有友军攻击速度增加%value% %]],
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNDrum.blp]],
	--特效
	effect = [[Abilities\Spells\Orc\CommandAura\CommandAura.mdl]],
    --光环影响范围
    area = 99999,
    --值
    value = {15,100,35,50,75},
}
function mt:on_upgrade()
    local skill = self
    local hero = self.owner

    self.buff = hero:add_buff '攻速光环'
    {
        source = hero,
        skill = self,
        selector = ac.selector()
            : in_range(hero, self.area)
            : is_ally(hero)
            ,
        -- buff的数据，会在所有自己的子buff里共享这个数据表
        data = {
            value = self.value,
            target_effect = self.effect,
        },
    }
 
end


local mt = ac.aura_buff['攻速光环']
-- 魔兽中两个不同的专注光环会相互覆盖，但光环模版默认是不同来源的光环不会相互覆盖，所以要将这个buff改为全局buff。
mt.cover_global = 1
mt.cover_type = 1
mt.cover_max = 1
mt.effect = [[]]
mt.keep = true


function mt:on_add()
    local target = self.target
    -- print('打印受光环英雄的单位',self.target:get_name())
    self.target_eff = self.target:add_effect('origin', self.data.target_effect)
    target:add('攻击速度',self.data.value)

end

function mt:on_remove()
    local target = self.target
    if self.source_eff then self.source_eff:remove() end
    if self.target_eff then self.target_eff:remove() end
    
    target:add('攻击速度',-self.data.value)
end

