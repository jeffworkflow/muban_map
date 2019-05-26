local japi = require("jass.japi")
local mt = ac.skill['火焰领主']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[智力+50%， 会心几率+10% ， 通关积分+50%]],
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNFlakCannons.blp]],
	--特效
    effect = [[HeroNevermoreIce.mdx]],
    --模型大小
	model_size = 1.1,
	--攻击
	attack_rate = 20,
	--会心几率
	heart_rate = 10
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    if not hero:is_hero() then return end
    if hero.name ~=self.name then return end 
    
    --测试掉线
    -- local unit = hero:get_owner():create_unit('强盗',ac.point(0,0))
    -- unit:set('生命上限',10000000)


    hero:add('智力%',self.attack_rate)
    hero:add('会心几率',self.heart_rate)
    --改变模型
    japi.SetUnitModel(hero.handle,self.effect)
    hero:set_size(self.model_size)
end
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    
    hero:add('智力%',-self.attack_rate)
    hero:add('会心几率',-self.heart_rate)
end
