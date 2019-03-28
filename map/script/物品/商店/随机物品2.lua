--物品名称
local mt = ac.skill['随机物品2']
mt{
--等久
level = 1,

--图标
art = [[other\suiji101.blp]],

--说明
tip = [[
随机物品
]],

--物品类型
item_type = '神符',

--目标类型
target_type = ac.skill.TARGET_TYPE_NONE,

--冷却
cool = 0,

--购买价格
jifen = 1,

--物品技能
is_skill = true,
auto_fresh_tip = true,

}

function mt:on_cast_start()
    print('施法-随机物品',self.name)
    local hero = self.owner
    local player = hero.owner

    local shop_item = ac.item.shop_item_map[self.name]
  
    --给英雄随机添加物品
    local rand_list = ac.unit_reward['商店随机物品']
    local rand_name = ac.get_reward_name(rand_list)
    if not rand_name then 
        return
    end    
    
    local list = ac.quality_item[rand_name] 
    --添加 
    local name = list[math.random(#list)]
    --满时，掉在地上
    local item = hero:add_item(name,true)
    local color = ac.color_code[item.color or '白']
    --系统提示
    ac.player.self:sendMsg('|cff00ffff【系统提示】|r|cffff0000'..player:get_name()..'|r|cff00ffff在物品商店用|r|cffff8000积分|r|cff00ffff兑换了一件 |r|cff'..color..name..'|r',10)



end

function mt:on_remove()
end