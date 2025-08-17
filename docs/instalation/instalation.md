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

