local mt = ac.skill['耐力光环']
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
    tip = [[|cff11ccff%skill_type%:|r 增加部队移动力%value% %
    ]],
	--技能图标
	art = [[jineng\jineng007.blp]],
	--特效
	effect = [[Abilities\Spells\Orc\CommandAura\CommandAura.mdl]],
    --光环影响范围
    area = 99999,
    --值
    value = {20,22.5,25,27.5,30},
}
function mt:on_upgrade()
    local skill = self
    local hero = self.owner

    self.buff = hero:add_buff '耐力光环'
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
function mt:on_remove()
    local hero = self.owner
    if self.buff then
        self.buff:remove()
        self.buff = nil
    end
end

local mt = ac.aura_buff['耐力光环']
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
    target:add('移动速度%',self.data.value)

end

function mt:on_remove()
    local target = self.target
    if self.source_eff then self.source_eff:remove() end
    if self.target_eff then self.target_eff:remove() end
    
    target:add('移动速度%',-self.data.value)
end
