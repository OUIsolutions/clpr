---@meta

--- Props passed to OrchestratorModule:add_action
---@class AddActionProps
---@field name string                       Required. Unique name that identifies this action.
---@field callback fun(args?: any): any     Required. Function executed when this action is dispatched.

--- Orchestrator object returned by ClprModule.newOrchestrator.
--- Manages action registration and spawning.
---@class OrchestratorModule
local OrchestratorModule = {}

--- Registers an action callback under a name.
--- If the current process was spawned to run this action, the callback is
--- executed immediately and its return value is persisted as the result.
---@param props AddActionProps
---@return string  The registered action name.
function OrchestratorModule.add_action(props) end

--- Calls callback() when the current process is NOT a dispatched action worker
--- (i.e. when running as the main/orchestrating process).
---@param callback fun()
function OrchestratorModule.add_main(callback) end

--- Spawns a subprocess to run the named action and returns a handle to it.
---@param action_name string   Name of a previously registered action.
---@param args? any            Optional arguments serialized and forwarded to the action callback.
---@return ActionModule
function OrchestratorModule.start_action(action_name, args) end
