# CLPR Installation Guide

## Overview

CLPR (Command Line Process Runner) requires specific dependencies to function properly. This guide covers the recommended installation method using pre-built releases and the required dependencies.

## Prerequisites

- Lua interpreter (5.1 or later)
- Command line access (bash recommended)
- Internet connection for downloading components

## Installation Steps

### Step 1: Install LuaDoTheWorld

CLPR requires several system functions to operate, including file operations, process management, and serialization. The recommended approach is to use LuaDoTheWorld, which provides all the necessary functions that CLPR depends on.

#### Why LuaDoTheWorld?

LuaDoTheWorld provides the following functions required by CLPR:
- File system operations (`write_file`, `load_file`, `remove_any`)
- Process management (`get_pid`, `is_pid_alive`, `kill_process`)
- Data serialization (`serialize_var`, `interpret_serialized_var`)

#### Download and Install

```bash
curl -L -o luaDoTheWorld.zip https://github.com/OUIsolutions/LuaDoTheWorld/releases/download/0.10.0/luaDoTheWorld.zip && unzip luaDoTheWorld.zip && rm luaDoTheWorld.zip
```

This command will:
- Download the latest LuaDoTheWorld release
- Extract the files to a `luaDoTheWorld/` directory
- Clean up the temporary zip file

#### Verify Installation

Check that LuaDoTheWorld is properly installed:

```lua
local dtw = require("luaDoTheWorld/luaDoTheWorld")
print("LuaDoTheWorld loaded successfully")
```

### Step 2: Install CLPR Library

Download the pre-built CLPR library file:

```bash
curl -L https://github.com/OUIsolutions/clpr/releases/download/0.1.0/lib.lua -o clpr.lua
```

This downloads the main CLPR library file and saves it as `clpr.lua` in your current directory.

#### Alternative Installation Locations

You can place the library file in different locations:

```bash
# Install in a lib directory
mkdir -p lib && curl -L https://github.com/OUIsolutions/clpr/releases/download/0.1.0/lib.lua -o lib/clpr.lua

# Install globally (requires permissions)
sudo curl -L https://github.com/OUIsolutions/clpr/releases/download/0.1.0/lib.lua -o /usr/local/share/lua/5.1/clpr.lua
```

### Step 3: Create Your First CLPR Script

Create a test file to verify the installation works correctly.

#### Basic Test Script

Create a file called `test.lua` with the following content:

```lua
local dtw = require("luaDoTheWorld/luaDoTheWorld")
local clpr = require("clpr")

-- Create orchestrator with required dependencies
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

-- Define a calculation action
local calc = orchestrator.add_action({
    name = "calc",
    callback = function(args)
        -- Simulate some processing time
        os.execute("sleep 3")
        local result = args.x + args.y
        print("Calculation completed: " .. args.x .. " + " .. args.y .. " = " .. result)
        return result
    end
})

-- Main orchestration logic
orchestrator.add_main(function()
    print("Starting parallel calculations...")
    
    -- Start two calculations in parallel
    local action1 = orchestrator.start_action(calc, {x = 50, y = 50})
    local action2 = orchestrator.start_action(calc, {x = 100, y = 200})
    
    print("Waiting for calculations to complete...")
    
    -- Wait for both actions to complete
    action1.wait(20, function() os.execute("sleep 1") end)
    action2.wait(20, function() os.execute("sleep 1") end)
    
    -- Display results
    print("Final Results:")
    print("Action 1 result: " .. action1.get_result())
    print("Action 2 result: " .. action2.get_result())
end)
```

#### Run the Test

Execute the test script:

```bash
lua test.lua
```

Expected output:
```
Starting parallel calculations...
Waiting for calculations to complete...
Calculation completed: 50 + 50 = 100
Calculation completed: 100 + 200 = 300
Final Results:
Action 1 result: 100
Action 2 result: 300
```

## Verification

### Check Installation

Verify that both components are properly installed:

```lua
-- Test LuaDoTheWorld
local dtw = require("luaDoTheWorld/luaDoTheWorld")
assert(dtw.write_file, "LuaDoTheWorld not properly installed")

-- Test CLPR
local clpr = require("clpr")
assert(clpr.newOrchestrator, "CLPR not properly installed")

print("Installation verified successfully!")
```

### Directory Structure

After installation, your project structure should look like:

```
your-project/
├── luaDoTheWorld/
│   ├── luaDoTheWorld.lua
│   └── luaDoTheWorld.so
├── clpr.lua
└── test.lua
```

## Troubleshooting

### Common Issues

#### Module Not Found Errors

If you encounter "module not found" errors:

1. Verify the file paths are correct
2. Check that files were downloaded completely
3. Ensure Lua can access the modules in your current directory

#### Permission Errors

If you get permission errors during installation:

```bash
# Use current directory instead of system directories
curl -L https://github.com/OUIsolutions/clpr/releases/download/0.1.0/lib.lua -o clpr.lua
```

#### LuaDoTheWorld Issues

If LuaDoTheWorld fails to load:

1. Verify the `.so` file has correct permissions
2. Check that your system supports the binary
3. Ensure you have the correct version for your platform

### Getting Help

If you encounter issues not covered here:

1. Check the [CLPR repository issues](https://github.com/OUIsolutions/clpr/issues)
2. Review the [LuaDoTheWorld documentation](https://github.com/OUIsolutions/LuaDoTheWorld)
3. Verify your Lua version compatibility

## Next Steps

Once installation is complete, refer to the [Library Usage Documentation](../lib_usage.md) for detailed information on using CLPR in your projects.
