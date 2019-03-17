
local player = require 'ac.player'
local fogmodifier = require 'types.fogmodifier'
local sync = require 'types.sync'
local jass = require 'jass.common'
local hero = require 'types.hero'
local item = require 'types.item'
local affix = require 'types.affix'
local japi = require 'jass.japi'
local japi = require 'jass.japi'
local rect = require 'types.rect'

--创建全图视野
local function icu()
	fogmodifier.create(ac.player(1), ac.map_area)
end

icu()

--输入 over 游戏结束
ac.game:event '玩家-聊天' (function(self, player, str)
    local hero = player.hero
	local p = player
	
    if str == 'over' then
		ac.game:event_notify('游戏-结束')
	end    

    if str == 'qlwp' then
		--开始清理物品
		for _,v in pairs(ac.item.item_map) do 
			--没有所有者 ，视为在地图上
			-- print(v.name,v.owner)
			if not v.owner  then 
				v:item_remove()
			end	
		end
	end   
end)	
