local mt = ac.skill['切换背包']
mt{
    --必填
    is_skill = true,

    --等级
    level = 1,

    --冷却
    cool = 1,

	--技能图标
    art = [[ReplaceableTextures\CommandButtons\BTNPackBeast.blp]],
    
	--技能说明
	title = '切换背包',

	tip = [[这只是一个测试技能
	第二行
    ]],
    --最大页数
    page = 3,
}

function mt:on_add()
    local hero = self.owner

    --创建一个背包表
    hero.item_list = {}

    --记录当前页面
    hero.currentpage = 1
end

function mt:on_cast_start()
    local hero = self.owner
    --记录一下当前页面
    local page = hero.currentpage


    --先移出当前页的物品
    local a = (page - 1) * 6 + 1
    local b = a + 5
    for i=a,b do
        local item = hero.item_list[i]
        if item then
            --不响应丢弃物品事件
            item.is_discard_event = true
            local handle = item.handle
            jass.SetItemPosition(handle,0,0)
            --隐藏起来
            jass.SetItemVisible(handle,false)
            --响应事件
            item.is_discard_event = false
        end
    end

    --页面增长
    hero.currentpage = hero.currentpage + 1
    if hero.currentpage > self.page then
        hero.currentpage = 1
    end

    local page = hero.currentpage
    local a = (page - 1) * 6 + 1
    local b = a + 5
    for i=a,b do
        local item = hero.item_list[i]
        if item then
            --不响应获得物品 移动物品 事件
            item.is_pickup_event = true
            local handle = item.handle
            --显示物品
            jass.SetItemVisible(handle,true)
            --添加给单位
            jass.UnitAddItem(hero.handle,item.handle)

            local slotid = (item.slot_id - 1) - (page - 1) * 6

            --修正位置
            jass.UnitDropItemSlot(hero.handle,item.handle,slotid)
            --响应
            item.is_pickup_event = false
        end
    end


end