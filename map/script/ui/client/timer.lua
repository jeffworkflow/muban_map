--[[
    全程异步的计时器 封装异步计时器 以便实现非即时的客户端效果
]]

local timer_class
local timer_count = 100 --计时器数
local jass_timer_list = {}

timer_class = {
    timer_map = {},

    ui_handle_system = handle_system_class.create(),

    create = function (user,interval,is_loop,callback)
        local index = timer_class.ui_handle_system:create_handle()
        if index > timer_count then --如果超过数量 则返回
            timer_class.ui_handle_system:close_handle(index)
            print('客户端计时器超过数量')
            return 
        end 
        local timer = {
            user        = user,
            interval    = interval,
            is_loop     = is_loop,
            callback    = callback,
            handle      = jass_timer_list[index],
            index       = index,
        }
        setmetatable(timer,{__index = timer_class})
        timer_class.timer_map[timer.handle] = timer
        TimerStart(timer.handle,interval,false,timer_class.on_update)
        return timer
    end,

    destroy = function (self)
        if self.handle == nil or handle == 0 then 
            return 
        end 
        local index = self.index 
        timer_class.ui_handle_system:close_handle(index)
        timer_class.timer_map[self.handle] = nil
        self.is_stop = true
        self.handle = nil
    end,

    stop = function (self)
        self.is_stop = true
        self:destroy()
    end,

    on_update = function ()
        local handle = GetExpiredTimer()
        local timer = timer_class.timer_map[handle]
        if timer == nil then 
            --print('不存在')
            return 
        end 
        if timer.is_stop then 
            timer:destroy()
            return 
        end 
        timer.callback(timer,timer.user)
        if timer.is_loop then 
            TimerStart(timer.handle,timer.interval,false,timer_class.on_update)
        else
            timer:destroy()
        end
    end,


}


--在屏幕上 画一条消息
function ui_print (...)
    local paramCount = select('#', ...) 
    local args = {...}
    local s = ''
    for index = 1 , paramCount do 
        s=s..tostring(args[index])..' '
    end
    if last_time then 
        last_time:stop()
        print_text:destroy()

        last_time = nil 
        print_text = nil
    end
    print_text = text_class.create(s,1000,920,500,500,21)
    print_text:set_color(255,255,128,1)
    last_time = timer_class.create(nil, 2, false, function ()
        print_text:destroy()
        last_time = nil 
        print_text = nil
    end)
end


local function initialize()
    for i=0,timer_count do 
        local handlle = CreateTimer()
        TimerStart(handlle,0,false,nil)
        jass_timer_list[i] = handlle
    end

end

initialize()

return timer_class