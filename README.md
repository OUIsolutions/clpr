<div align="center">

# CLPR - Command Line Process Runner
![Lua Logo](https://img.shields.io/badge/CLPR-0.1.0-blue?style=for-the-badge&logo=lua)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://github.com/OUIsolutions/clpr/blob/main/LICENSE)
![Status](https://img.shields.io/badge/Status-Production-green?style=for-the-badge)
![ouiVibe](https://img.shields.io/badge/ouivibe-Library-lightgrey?style=for-the-badge)

</div>

---

## 📄 Open Source Software

> **This is open source software released under the MIT License!** This software is free to use, modify, and distribute. You can use it in both personal and commercial projects. See the license section below for full details. 🔓

---

### Overview

CLPR (Command Line Process Runner) is an advanced Lua library designed for orchestrating and managing parallel processes. It provides a powerful framework for executing asynchronous operations, managing their lifecycle, and retrieving results in a controlled manner:

1. **Define reusable actions**
2. **Execute actions in parallel**
3. **Monitor process status**
4. **Wait for completion with timeouts**
5. **Retrieve and manage results**

This library is designed for developers who need to:
- Execute long-running tasks in parallel
- Orchestrate complex multi-step workflows
- Manage process lifecycles automatically
- Handle asynchronous operations with ease
- Build robust command-line tools and automation scripts

---

### System Architecture

The CLPR library uses a process-based architecture where:
- **Orchestrator**: Manages the overall workflow and process coordination
- **Actions**: Reusable functions that can be executed asynchronously
- **Action Instances**: Running processes that can be monitored and controlled
- **Communication**: File-based inter-process communication for results

---

### Key Features

- **Parallel Process Execution** - Run multiple actions simultaneously
- **Action Management** - Define reusable actions with callbacks
- **Process Monitoring** - Check if processes are alive and healthy
- **Result Retrieval** - Get return values from completed actions
- **Timeout Handling** - Wait for completion with configurable timeouts
- **Automatic Cleanup** - Built-in resource management and process cleanup
- **Flexible Dependencies** - Pluggable functions for file operations and process management

### Supported Operations

- **Action Definition** - Create reusable action templates
- **Parallel Execution** - Start multiple actions simultaneously
- **Process Control** - Kill, monitor, and manage running processes
- **Result Management** - Retrieve and handle action results
- **Error Handling** - Robust error handling with timeouts
- **Resource Cleanup** - Automatic cleanup of temporary resources

### AI/LLM Integration

Want to learn how to use CLPR with AI assistance? Download the [lib_usage.md](docs/lib_usage.md) file and paste its contents to your preferred AI assistant (ChatGPT, Claude, Copilot, etc.) for interactive learning and code examples.

---

## Releases

|  **File**                                                                                                           | **What is**                              |
|---------------------------------------------------------------------------------------------------------------------|------------------------------------------|
|[lib.lua](https://github.com/OUIsolutions/clpr/releases/download/0.1.0/lib.lua)     | Main CLPR Library for Process Orchestration |
|[embed.lua](https://github.com/OUIsolutions/clpr/releases/download/0.1.0/embed.lua) | Embedded version with all dependencies |

## Installation Tutorials
| **Tutorial**                                                  | **Description**                                       |
|---------------------------------------------------------------|------------------------------------------------------ |
| [Library Installation](docs/instalation/instalation.md)      | Standard Library Installation Guide                   |
| [Build from Scratch](docs/instalation/build_from_scratch.md) | Building CLPR from Source Code | 

## [Public API](docs/lib_usage.md)
Click here [Public API](docs/lib_usage.md) to see the full list of public API functions.

## Usage Tutorials 

| **Tutorial**                                                    | **Description**                                         |
|-----------------------------------------------------------------|---------------------------------------------------------|
| [Getting Started](docs/lib_usage.md#basic-setup)               | Quick start guide for new users                        |
| [Action Definition](docs/lib_usage.md#defining-actions)        | Creating reusable actions and callbacks                |
| [Process Management](docs/lib_usage.md#process-management)     | Managing parallel processes and lifecycles             |
| [Result Handling](docs/lib_usage.md#getting-results)           | Retrieving and managing action results                 |
| [Error Handling](docs/lib_usage.md#error-handling)             | Robust error handling patterns                         |
| [Best Practices](docs/lib_usage.md#best-practices)             | Recommended patterns and performance tips              |

## Quick Example

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

-- Define an action
orchestrator.add_action({
    name = "heavy_task",
    callback = function(args)
        os.execute("sleep " .. args.duration)
        return args.value * 2
    end
})

-- Main execution
orchestrator.add_main(function()
    -- Start parallel actions
    local task1 = orchestrator.start_action("heavy_task", {value = 10, duration = 2})
    local task2 = orchestrator.start_action("heavy_task", {value = 20, duration = 3})
    
    -- Wait for completion
    task1.wait(10, function() os.execute("sleep 1") end)
    task2.wait(10, function() os.execute("sleep 1") end)
    
    -- Get results
    print("Task 1 result: " .. task1.get_result()) -- 20
    print("Task 2 result: " .. task2.get_result()) -- 40
end)
```

## 📄 License

This project is licensed under the **MIT License** - see the license details below.

---

## 🔓 MIT License

MIT License

Copyright (c) 2024 OUI Solutions

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---