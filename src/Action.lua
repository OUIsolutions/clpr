

function MetaAction.__gc(public,private)
   --public.remove_dir(public.action_dir) 
end
PublicAction.is_alive = function(public,private)
    if not public.action_pid then
        return false
    end
    return public.is_pid_alive(public.action_pid)
end
PublicAction.kill = function(public,private)
    if not public.action_pid then
        return false
    end
    return public.kill_process_by_pid(public.action_pid)
end

PublicAction.get_result = function(public,private)
    local result_path = public.action_dir.."/result.lua"
    local result_content = public.load_file(result_path)
    if not result_content then
        return nil
    end 
    return public.loader(result_content)
end

function ActionConstructor.construct(public_orchestrator,action_name,args)
    local selfobject = heregitage.newMetaObject()
    selfobject.public_props_extends(public_orchestrator)
    selfobject.public_method_extends(PublicAction)
    selfobject.meta_method_extends(MetaAction)

    selfobject.public.action_dir = public_orchestrator.database_path.."/"..public_orchestrator.get_pid() .."_"..public_orchestrator.total_runned_actions

    if args then
        local serialized =  public_orchestrator.dumper(args)
        local entries_path = selfobject.public.action_dir.."/entries.lua"
        public_orchestrator.write_file(entries_path, serialized)
    end

    local sanitized_args = Args.sanitize_args(public_orchestrator.string, public_orchestrator.args)
    sanitized_args[#sanitized_args+1] = "clpraction="..action_name
    sanitized_args[#sanitized_args+1] = "clprdir="..selfobject.public.action_dir
    local formmated_command = Args.format_args(public_orchestrator.string, sanitized_args)
    formmated_command = formmated_command .." &"
    public_orchestrator.execute_command(formmated_command)

    local started_check_path = selfobject.public.action_dir.."/started"
    for i = 1, public_orchestrator.max_started_checks do
        local started_content = public_orchestrator.load_file(started_check_path)
        if started_content == "1" then 
            selfobject.public.action_pid = public_orchestrator.load_file(selfobject.public.action_dir.."/pid")
            if not selfobject.public.action_pid then
                error("Action process not started")
            end
            selfobject.public.action_pid = public_orchestrator.to_number(selfobject.public.action_pid)
            break
        end
    end
    if not selfobject.public.action_pid then
        error("Action process not started")
    end
    
    return selfobject.public
end 