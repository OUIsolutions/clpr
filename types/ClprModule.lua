---@meta

--- Props passed to ClprModule.newOrchestrator
---@class NewOrchestratorProps
---@field args table                                        Required. Raw CLI arg table (arg).
---@field database_path string                             Required. Path to the directory used as the action database.
---@field write_file fun(path: string, content: string)    Required. Writes content to a file at path.
---@field load_file fun(path: string): string|nil          Required. Reads and returns file content, or nil if missing.
---@field remove_dir fun(path: string)                     Required. Removes a directory recursively.
---@field dumper fun(data: any): string                    Required. Serializes a Lua value to a string.
---@field loader fun(content: string): any                 Required. Deserializes a string back to a Lua value.
---@field get_pid fun(path?: string): integer              Required. Returns the current process PID (optionally writing it to path).
---@field is_pid_alive fun(pid: integer): boolean          Required. Returns true if the process with the given PID is running.
---@field kill_process_by_pid fun(pid: integer): boolean   Required. Kills the process with the given PID.
---@field pairs? fun(t: table): function                   Optional. Replacement for the global pairs().
---@field setmetatable? fun(t: table, mt: table): table    Optional. Replacement for the global setmetatable().
---@field type? fun(v: any): string                        Optional. Replacement for the global type().
---@field string? table                                    Optional. Replacement for the global string module.
---@field to_number? fun(s: string): number|nil            Optional. Replacement for the global tonumber().
---@field execute_command? fun(cmd: string): any           Optional. Replacement for os.execute().
---@field max_started_checks? number                       Optional. Max polling iterations when waiting for an action to start (default: 500000).

--- Entry point module. Constructed once per program.
---@class ClprModule
local ClprModule = {}

--- Creates and returns a new OrchestratorModule.
---@param props NewOrchestratorProps
---@return OrchestratorModule
function ClprModule.newOrchestrator(props) end
