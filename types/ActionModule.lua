---@meta

--- Handle to a spawned action subprocess, returned by OrchestratorModule:start_action.
---@class ActionModule
local ActionModule = {}

--- Returns true if the action subprocess is still running.
---@return boolean
function ActionModule.is_alive() end

--- Kills the action subprocess.
--- When screen mode is active the screen session is terminated instead.
---@return boolean  true if the kill was performed, false if there is no PID.
function ActionModule.kill() end

--- Blocks until the action subprocess finishes, polling via sleep_callback.
--- Raises an error if the process has not finished after max_sleep_cicles polls.
---@param max_sleep_cicles integer   Maximum number of polling iterations.
---@param sleep_callback fun()       Called between each polling check (e.g. a sleep function).
function ActionModule.wait(max_sleep_cicles, sleep_callback) end

--- Reads and deserializes the value returned by the action callback.
--- Returns nil if the action has not produced a result yet.
---@return any
function ActionModule.get_result() end

--- Returns the shell command needed to attach to the action's screen session.
--- Raises an error if screen mode is not enabled for this action.
---@return string  e.g. "screen -r clpr_myaction_1234_1"
function ActionModule.attach_screen() end

--- Returns the name of the screen session for this action, or nil if screen
--- mode is not enabled.
---@return string|nil
function ActionModule.get_screen_session_name() end
