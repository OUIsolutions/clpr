# CLPR Library Usage Documentation

## Overview

CLPR (Command Line Process Runner) is a Lua library for orchestrating and managing parallel processes. It allows you to define actions that can be executed asynchronously, wait for their completion, and retrieve their results.

## Basic Setup

### Creating an Orchestrator

The orchestrator is the main component that manages actions and processes. It requires several dependencies to be provided:

```lua
local clpr = require("clpr")

local orchestrator = clpr.newOrchestrator({
    args = arg,                              -- Command line arguments
    database_path = ".clpr",                 -- Directory for process communication
    write_file = dtw.write_file,            -- Function to write files
    remove_dir = dtw.remove_any,            -- Function to remove directories
    load_file = dtw.load_file,              -- Function to load file contents
    dumper = dtw.serialize_var,             -- Function to serialize variables
    loader = dtw.interpret_serialized_var,  -- Function to deserialize variables
    get_pid = dtw.get_pid,                  -- Function to get process ID
    is_pid_alive = dtw.is_pid_alive,        -- Function to check if PID is alive
    kill_process_by_pid = dtw.kill_process, -- Function to kill process by PID
})
```

### Required Dependencies

The orchestrator requires the following functions to be provided:

- `args`: Table containing command line arguments
- `database_path`: String path where temporary files will be stored
- `write_file(path, content)`: Write content to a file
- `remove_dir(path)`: Remove a directory and its contents
- `load_file(path)`: Load and return file contents
- `dumper(data)`: Serialize data to string
- `loader(string)`: Deserialize string to data
- `get_pid()`: Get current process ID
- `is_pid_alive(pid)`: Check if a process ID is alive
- `kill_process_by_pid(pid)`: Kill a process by its ID

### Optional Dependencies

You can also provide optional functions to override defaults:

- `pairs`: Custom pairs function (defaults to built-in pairs)
- `setmetatable`: Custom setmetatable function (defaults to built-in)
- `type`: Custom type function (defaults to built-in)
- `string`: Custom string module (defaults to built-in string)
- `to_number`: Custom number conversion (defaults to tonumber)
- `execute_command`: Custom command execution (defaults to os.execute)
- `max_started_checks`: Maximum checks for process startup (defaults to 500000)

## Defining Actions

Actions are functions that can be executed asynchronously. Each action must have a unique name and a callback function.

### Basic Action Definition

```lua
local action_name = orchestrator.add_action({
    name = "action_name",
    callback = function(args)
        -- Your action logic here
        local result = args.x + args.y
        return result
    end
})
```

### Action Callback Function

The callback function receives the arguments passed when starting the action:

```lua
orchestrator.add_action({
    name = "calc",
    callback = function(args)
        -- Access arguments passed to the action
        local x = args.x
        local y = args.y
        
        -- Perform some work (can be time-consuming)
        os.execute("sleep 10")
        
        -- Calculate and return result
        local result = x + y
        print("Calculation completed: " .. result)
        return result
    end
})
```

## Main Function

The main function is executed when the script runs without any action parameters. It's where you orchestrate your actions.

```lua
orchestrator.add_main(function()
    -- Start actions
    local action1 = orchestrator.start_action("calc", {x=50, y=50})
    local action2 = orchestrator.start_action("calc", {x=100, y=200})
    
    -- Wait for completion and get results
    action1.wait(20, function() os.execute("sleep 1") end)
    action2.wait(20, function() os.execute("sleep 1") end)
    
    print("Action 1 result: " .. action1.get_result())
    print("Action 2 result: " .. action2.get_result())
end)
```

## Starting Actions

Use `orchestrator.start_action()` to execute an action asynchronously:

```lua
local action_instance = orchestrator.start_action(action_name, arguments)
```

Parameters:
- `action_name`: String name of the action to execute
- `arguments`: Table of arguments to pass to the action callback

Returns an action instance object with methods to control and monitor the action.

## Action Instance Methods

### Checking if Action is Alive

```lua
local is_running = action_instance.is_alive()
```

Returns `true` if the action process is still running, `false` otherwise.

### Killing an Action

```lua
local success = action_instance.kill()
```

Terminates the action process. Returns `true` if successful, `false` if the action wasn't running.

### Waiting for Completion

```lua
action_instance.wait(max_sleep_cycles, sleep_callback)
```

Parameters:
- `max_sleep_cycles`: Maximum number of sleep cycles to wait
- `sleep_callback`: Function to call during each sleep cycle

The function will wait for the action to complete, calling the sleep callback between checks. If the action doesn't complete within the specified cycles, it throws an error.

Example:
```lua
-- Wait up to 20 cycles, sleeping 1 second between checks
action_instance.wait(20, function()
    os.execute("sleep 1")
end)
```

### Getting Results

```lua
local result = action_instance.get_result()
```

Retrieves the return value from the action's callback function. Returns `nil` if no result is available.

## Process Management

### Automatic Cleanup

Actions have automatic cleanup enabled by default. When an action instance is garbage collected, it will:
- Remove the temporary directory used for communication
- Kill the process if `kill_process_on_end` is true (default)

### Manual Process Control

You can control the cleanup behavior:

```lua
-- Disable automatic process killing (not recommended)
action_instance.kill_process_on_end = false

-- Manually kill if needed
if action_instance.is_alive() then
    action_instance.kill()
end
```

## Error Handling

### Action Definition Errors

- Duplicate action names will throw an error
- Missing required properties (name, callback) will throw an error

```lua
-- This will throw an error if "calc" already exists
orchestrator.add_action({
    name = "calc",  -- Duplicate name
    callback = function(args) return args.x + args.y end
})
```

### Runtime Errors

- Starting non-existent actions will throw an error
- Timeout in waiting will throw an error

```lua
-- This will throw an error
orchestrator.start_action("non_existent_action", {})

-- This will throw a timeout error if action doesn't complete
action_instance.wait(5, function() os.execute("sleep 2") end)
```

## Complete Example

```lua
local dtw = require("luaDoTheWorld/luaDoTheWorld")
local clpr = require("clpr")

-- Create orchestrator
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

-- Define actions
orchestrator.add_action({
    name = "heavy_calculation",
    callback = function(args)
        -- Simulate heavy work
        os.execute("sleep " .. args.duration)
        return args.base * args.multiplier
    end
})

orchestrator.add_action({
    name = "file_processing",
    callback = function(args)
        -- Process file (example)
        local content = "Processing: " .. args.filename
        return #content
    end
})

-- Main orchestration logic
orchestrator.add_main(function()
    -- Start multiple actions in parallel
    local calc1 = orchestrator.start_action("heavy_calculation", {
        base = 100, 
        multiplier = 5, 
        duration = 3
    })
    
    local calc2 = orchestrator.start_action("heavy_calculation", {
        base = 200, 
        multiplier = 3, 
        duration = 2
    })
    
    local file_proc = orchestrator.start_action("file_processing", {
        filename = "data.txt"
    })
    
    -- Wait for all to complete
    calc1.wait(10, function() os.execute("sleep 1") end)
    calc2.wait(10, function() os.execute("sleep 1") end)
    file_proc.wait(10, function() os.execute("sleep 1") end)
    
    -- Collect and display results
    print("Calculation 1: " .. calc1.get_result())
    print("Calculation 2: " .. calc2.get_result())
    print("File processing: " .. file_proc.get_result())
end)
```

## Best Practices

### Resource Management

- Always wait for actions to complete or explicitly kill them
- Use appropriate timeout values in wait calls
- Consider the cleanup behavior when setting `kill_process_on_end`

### Error Handling

- Wrap action execution in pcall for error handling
- Validate arguments before passing to actions
- Check if actions are alive before waiting

### Performance

- Use meaningful sleep intervals in wait callbacks
- Don't create too many concurrent actions at once
- Clean up temporary directories periodically

### Debugging

- Use the `is_alive()` method to check action status
- Add logging to action callbacks for debugging
- Monitor the database_path directory for process communication files
