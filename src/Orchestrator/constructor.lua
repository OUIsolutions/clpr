


MainModule.newOrchestrator  = function (props)

    if not props then
        error("props table is required")
    end

    -- Validate required arguments
    if not props.args then 
        error("args is required")
    end

    if not props.database_path then
        error("database_path is required")
    end

    if not props.write_file then
        error("write_file function is required")
    end

    if not props.load_file then
        error("load_file function is required")
    end
    if not props.remove_dir then
        error("remove_dir function is required")
    end

    if not props.dumper then
        error("dumper function is required")
    end

    if not props.loader then
        error("loader function is required")
    end

    if not props.get_pid then
        error("get_pid function is required")
    end

    if not props.is_pid_alive then
        error("is_pid_alive function is required")
    end

    if not props.kill_process_by_pid then
        error("kill_process_by_pid function is required")
    end
    local type = type 
    if props.type  then 
        type = props.type
    end
    -- Validate argument types
    if type(props.args) ~= "table" then
        error("args must be a table")
    end
    if type(props.remove_dir) ~= "function" then
        error("remove_dir must be a function")
    end

    if type(props.database_path) ~= "string" then
        error("database_path must be a string")
    end

    if type(props.write_file) ~= "function" then
        error("write_file must be a function")
    end

    if type(props.load_file) ~= "function" then
        error("load_file must be a function")
    end

    if type(props.dumper) ~= "function" then
        error("dumper must be a function")
    end

    if type(props.loader) ~= "function" then
        error("loader must be a function")
    end

    if type(props.get_pid) ~= "function" then
        error("get_pid must be a function")
    end

    if type(props.is_pid_alive) ~= "function" then
        error("is_pid_alive must be a function")
    end    if type(props.kill_process_by_pid) ~= "function" then
        error("kill_process_by_pid must be a function")
    end

    -- Validate optional arguments if provided
    if props.pairs  then
        if type(props.pairs) ~= "function" then
            error("pairs must be a function if provided")
        end
    end

    if props.setmetatable  then
        if  type(props.setmetatable) ~= "function" then
            error("setmetatable must be a function if provided")
        end 
    end

    if props.string  then
        if type(props.string) ~= "table" then
            error("string must be a table (string module) if provided")
        end
    end
    if props.to_number then
        if type(props.to_number) ~= "function" then
            error("to_number must be a function if provided")
        end
    end

    if props.execute_command then
        if type(props.execute_command) ~= "function" then
            error("execute_command must be a function if provided")
        end
    end

    if props.max_started_checks then
        if type(props.max_started_checks) ~= "number" then
            error("max_started_checks must be a number if provided")
        end
    end

    heregitage.pairs = props.pairs or pairs
    heregitage.type = props.type or type
    heregitage.setmetatable = props.setmetatable or setmetatable

    local selfobject = heregitage.newMetaObject()
    selfobject.public_props_extends(props)
    selfobject.public.total_runned_actions = 0
    selfobject.public.actions  = {}
    selfobject.public.args = {}
    -- native lua args starts in 0 so we need to adjust the index
    for i=-2,#props.args do
        local current = props.args[i]
        if current then
            selfobject.public.args[#selfobject.public.args + 1] = props.args[i]
        end
    end



    selfobject.public_method_extends(PublicOrchestrator)
    if not props.string then
        selfobject.public.string = string 
    end
    if not props.to_number then
        selfobject.public.to_number = tonumber
    end

    if not props.execute_command then 
        selfobject.public.execute_command = os.execute
    end
    if not props.max_started_checks then
        selfobject.public.max_started_checks = 500000
    end

    local entries = Args.collect_entries(selfobject.public.string, props.args)
    
    if  entries then 
       selfobject.public.action_name = entries.action_name
       selfobject.public.dir = entries.dir
    end



    return selfobject.public
end