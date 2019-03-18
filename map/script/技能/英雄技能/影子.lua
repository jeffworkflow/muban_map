local mt = ac.skill['影子']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "主动",
	--耗蓝
	cost = 60,
	--冷却时间40
	cool = 40,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[召唤1只影子助战（属性与智力相关）；持续时间30S],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNMirrorImage.blp]],
	--召唤物
    unit_name = function(self,hero)
		if self and self.owner then 
         return self.owner:get_name()
        end 
    end,
	--召唤物属性倍数
	attr_mul = 0.5,
	--持续时间
	time = 30,
	--数量
	cnt = 1,
}
	
function mt:on_add()
	local hero = self.owner 

end	
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	
	local cnt = (self.cnt + hero:get('召唤物')) or 1
	--多个召唤物
	for i=1,cnt do 

		local point = hero:get_point()-{hero:get_facing(),100}--在英雄附近 100 到 400 码 随机点
		local unit = hero:get_owner():create_unit(self.unit_name,point)	
        unit.unit_type = 'unit'
        local data = {}
        data.attribute ={
            ['攻击'] = hero:get('攻击'),
            ['护甲'] = hero:get('护甲'),
            ['生命上限'] = hero:get('生命上限'),
            ['魔法上限'] = hero:get('魔法上限'),
            ['生命恢复'] = hero:get('生命恢复'),
            ['魔法恢复'] = hero:get('魔法恢复'),
            ['移动速度'] = hero:get('移动速度'),
        }

		self.buff = unit:add_buff '召唤物' {
			time = self.time,
			attribute = data.attribute,
			attr_mul = self.attr_mul - 1,
			skill = self,
			follow = true
		}
	end	


end

function mt:on_remove()

    local hero = self.owner 
	--移除时将召唤物移除
    -- if self.buff then
    --     self.buff:remove()
    --     self.buff = nil
	-- end  
	
end