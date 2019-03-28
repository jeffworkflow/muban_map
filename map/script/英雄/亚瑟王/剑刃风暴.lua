local mt = ac.skill['剑刃风暴']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	
	max_level = 5,
	
	tip = [[
		主动：对周围%area%码的敌人每 %pulse% 秒造成物理伤害，持续时间 %time% 秒
		被动：提升自己的生命上限%life_rate% %
		|cff00bdec伤害：攻击力*%attack% |cff00bdec+力量*%power% |cff00bdec(%damage%|cff00bdec)|r
	]],
	
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNWhirlwind.blp]],

	--技能目标类型 无目标
	target_type = ac.skill.TARGET_TYPE_NONE,

	--施法范围
	area = 500,
	--施法范围2
	area2 = 1000,

	--持续时间
	time = {4,5,6,7,8},

	--每几秒
	pulse = 0.2,

	--伤害参数1：攻击力
	attack = function(self,hero)
		return 2*self.pulse
	end,

	--伤害参数2：力量
	power =  function(self,hero)
		return 2*self.pulse
	end,
	
	--伤害
	damage = function(self,hero)
		return hero:get('攻击')*self.attack + hero:get('力量')*self.power
	end,	

	--生命上限
	life_rate = {10,20,30,40,50},

	--cd
	cool = {25,23,20,18,15},

	--耗蓝
	cost = {50,200,350,500,750},

	--特效模型
	effect = [[Hero_Juggernaut_N4S_F_Source.mdx]],
	--冲击波
	effect1 = [[Abilities\Spells\Orc\Shockwave\ShockwaveMissile.mdl]],
	--冲击波移动距离
	distance = 500,
	--冲击波速度
	speed = 1600,
	--冲击波碰撞范围
	hit_area = 200,
	
	--伤害类型
	damage_type = '物理',

    -- 跟随物模型
    follow_model = [[Hero_Juggernaut_N4S_F_Source.mdx]],
    folow_model_size = 0.8,
    follow_move_skip = 10,
}
mt.life_rate_now = 0

function mt:on_add()
    local skill = self
	local hero = self.owner 

	--创建一个透明的剑刃风暴 跟随英雄
	local mvr = hero:follow{
		source = hero,
		model = self.follow_model,
		distance = 0,
		skill = self,
		on_move_skip = self.follow_move_skip,
		size = self.folow_model_size,
	}
	mvr.mover:setAlpha(0)
end	
-- 360,396,432,468,504
function mt:on_upgrade()
	local hero = self.owner
	-- print(self.life_rate_now)
	hero:add('生命上限%', -self.life_rate_now)
	self.life_rate_now = self.life_rate
	hero:add('生命上限%', self.life_rate)
end


function mt:on_cast_shot()
	local hero = self.owner
	-- hero:add_effect('origin',self.effect)
	local area = self.area
	
	if self.is_stronged then 
		area = self.area2
	end	
	self.trg = hero:add_buff '剑刃风暴' 
	{
		source = hero,
		skill = self,
		area = area,
		damage = self.damage,
		effect = self.effect,
		pulse = 0.02, --剑刃风暴 立即受伤害
		real_pulse = self.pulse,  --实际每秒受伤害
		time = self.time,
		is_stronged = self.is_stronged,   --强化标识
		effect1 = self.effect1,
		speed = self.speed,
		damage_type = self.damage_type
	}
end

function mt:on_remove()

    local hero = self.owner 
    -- 提升三维(生命上限，护甲，攻击)
	hero:add('生命上限%', -self.life_rate)
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end    

end


local mt = ac.buff['剑刃风暴']
mt.cover_type = 1
mt.cover_max = 1

function mt:on_add()
    self.eff = self.target:add_effect('origin',self.effect)
end

function mt:on_remove()
	print(self.eff)
    if self.eff then 
        self.eff:remove()
        self.eff = nil
    end    
    
end

function mt:on_pulse()
	-- print('腐烂每秒伤害：',damage*self.pulse)
	self.pulse = self.real_pulse
	local skill = self.skill
	local hero = self.target
	for i, u in ac.selector()
		: in_range(hero,self.area)
		: is_enemy(hero)
		: of_not_building()
		: ipairs()
	do
		u:damage
		{
			source = self.source,
			damage = self.damage,
			skill = self.skill,
			damage_type = self.damage_type
		}
	end	

	--强化冲击波
	if not self.is_stronged then 
		return 
	end	

	for i = 1,3 do 
		local mvr = ac.mover.line
		{
			source = hero,
			skill = skill,
			model = skill.effect1,
			speed = skill.speed,
			angle = math.random(360),
			hit_area = skill.hit_area,
			distance = skill.distance,
			high = 50,
			size = 1,
		}
		if mvr then
			function mvr:on_hit(u)
				u:damage
				{
					source = hero,
					skill = skill,
					damage = skill.damage,
					damage_type = skill.damage_type,
				}
			end
		end
	end	
end

