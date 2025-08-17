
function PublicOrchestrator.add_action(public,private,props)
    if not props.name then
        error("Action name is required")
    end
    if not props.callback then
        error("Action callback is required")
    end

    for i=1,#public.actions do
        if public.actions[i].name == props.name then
            error("Action with name '" .. props.name .. "' already exists")
        end
    end
    
    local action = {
        name = props.name,
        callback = props.callback,
    } 
    public.actions[#public.actions + 1] = action


    if props.name == public.action_name then
        local entries_content_path = public.dir.."/entries.lua"
        local entries_content = public.load_file(entries_content_path)
        local callback_args = nil
        if entries_content then 
            callback_args = public.loader(entries_content)
        end
        os.execute("sleep 1") -- wait for the action directory to be created
        local started_path = public.dir.."/started"
        public.write_file(started_path, "1")
        local pid_path = public.dir.."/pid"
        local pid = public.get_pid(pid_path)
        public.write_file(pid_path, pid)

        local result = props.callback(callback_args)
        local result_serialized = public.dumper(result)
        local result_path = public.dir.."/result.lua"
        public.write_file(result_path, result_serialized)

    end

    return props.name
end
