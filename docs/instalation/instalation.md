### Step 1: Install LuaDoTheWorld
for instalation , you need to provide all functions that the clpr needs to run, a recomend
aproach its to download [luadoTheWorld](https://github.com/OUIsolutions/LuaDoTheWorld), since 
it provides all the functions that clpr needs to run, and you can use it to run clpr.

to install [luadoTheWorld](https://github.com/OUIsolutions/LuaDoTheWorld), run:
```bash
curl -L -o luaDoTheWorld.zip https://github.com/OUIsolutions/LuaDoTheWorld/releases/download/0.10.0/luaDoTheWorld.zip && unzip luaDoTheWorld.zip && rm luaDoTheWorld.zip
```
### Step 2: Install CLPR
to install clpr, you can use the following command:
```bash
curl -L https://github.com/OUIsolutions/clpr/releases/download/0.1.0/lib.lua -o clpr.lua
``` 

### Step 3: Run CLPR
create a file called `test.lua` with the following content:
```lua
local dtw = require("luaDoTheWorld/luaDoTheWorld")
local clpr = require("clpr")

local orchestrator = clpr.newOrchestrator({
    args = arg,
    database_path = ".clpr",
    write_file = dtw.write_file,
    remove_dir = dtw.remove_any,
    load_file = dtw.load_file,
    dumper = dtw.serialize_var,
    loader = dtw.interpret_serialized_var,
    get_pid = dtw.get_pid,
    is_pid_alive = dtw.is_pid_alive,
    kill_process_by_pid = dtw.kill_process,
})

local calc = orchestrator.add_action({
    name = "calc",
    callback = function (args)
        os.execute("sleep 10")
        local result = args.x + args.y
        print("calc action executed")
        print("Result: " .. result)
        return result
    end
})

orchestrator.add_main(function ()  
    local action1 = orchestrator.start_action(calc,{x=50,y=50})

    local action2 = orchestrator.start_action(calc,{x=100,y=200})
    action1.wait(20,function () os.execute("sleep 1 ") end)
    action2.wait(20,function () os.execute("sleep 1 ") end)

    print("Action 1 result: " .. action1.get_result())
    print("Action 2 result: " .. action2.get_result())
end)
```
