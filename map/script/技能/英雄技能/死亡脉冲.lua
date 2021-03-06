local mt = ac.skill['死亡脉冲']
mt{
    --必填
    is_skill = true,
    --初始等级
	level = 1,
	max_level = 5,
	--技能类型
	skill_type = "主动 智力 治疗",
	--耗蓝
	cost = {15,115,215,315,415},
	--冷却时间10
	cool = 10,

	--技能无目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--施法范围
	area = 800,

	--介绍
	tip = [[|cff11ccff%skill_type%:|r 对范围800码的敌方单位造成法术伤害（%damage%）
	增加范围400码的队友%heal%生命
	伤害计算：|cffd10c44 智力 * %int% + |cffd10c44 %shanghai% |r
	伤害类型：|cff04be12法术伤害|r

	%strong_skill_tip%
	]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNDeathCoil.blp]],
	--特效
	effect = [[Abilities\Spells\Undead\DeathCoil\DeathCoilMissile.mdl]],

	int = {25,30,35,40,50},

	shanghai ={25000,250000,2500000,6250000,10000000},

	--治疗
	heal = 10,

	--伤害
	damage = function(self,hero)
		if self and self.owner and self.owner:is_hero() then 
			return self.owner:get('智力')*self.int+self.shanghai
		end
	end	,
	damage_type = '法术',
	strong_skill_tip ='（可食用|cffffff00恶魔果实|r进行强化）',
	casting_cnt = 1
}
function mt:strong_skill_func()
	local hero = self.owner 
	local player = hero:get_owner()
	-- 增强 卜算子 技能 1个变为多个 --商城 或是 技能进阶可得。
	if (hero.strong_skill and hero.strong_skill[self.name]) then 
		self:set('casting_cnt',5)
		self:set('strong_skill_tip','|cffffff00已强化：|r|cff00ff00额外触发4次死亡脉冲，造成等值伤害|r')
		-- print(2222222222222222222)
	end	
end	
function mt:on_add()
    local skill = self
    local hero = self.owner
	self:strong_skill_func()
end

function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	local target = self.target
	local function start_damage()
		for i, u in ac.selector()
			: in_range(hero,self.area)
			: of_not_building()
			: ipairs()
		do
			local mvr = ac.mover.target
			{
				source = hero,
				target = u,
				model = skill.effect,
				speed = 600,
				height = 110,
				skill = skill,
			}
			if not mvr then
				return
			end
			function mvr:on_finish()
				if u:is_enemy(hero) then 
					u:damage
					{
						source = hero,
						damage = skill.damage ,
						skill = skill,
						damage_type =skill.damage_type
					}	
				else
					u:heal
					{
						source = hero,
						skill = skill,
						size = 10,
						heal = u:get('生命上限') * skill.heal/100,
					}	
				end	
			end
		end
	end

	--先释放一次，再释放4次
	start_damage()
	if self.casting_cnt >1 then 
		hero:timer(0.3*1000,self.casting_cnt-1,function(t)
			start_damage()
		end)
	end	
	
	
end	


function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end
