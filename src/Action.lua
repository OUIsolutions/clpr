

function MetaAction.__gc(public,private)
   --public.remove_dir(public.action_dir) 
end

function ActionConstructor.construct(public_orchestrator,action_name,args)
    local selfobject = heregitage.newMetaObject()
    selfobject.public_props_extends(public_orchestrator)
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
    sanitized_args[#sanitized_args+1] = "&" 
    local formmated_command = Args.format_args(public_orchestrator.string, sanitized_args)
    public_orchestrator.execute_command(formmated_command)

    local started_check_path = selfobject.public.action_dir.."/started"
    local total_started_checks = 0
    while true do 
        local started_content = public_orchestrator.load_file(started_check_path)
        if started_content then 
            selfobject.public.action_pid = public_orchestrator.load_file(selfobject.public.action_dir.."/pid")
            if not selfobject.public.action_pid then
                error("Action process not started")
            end
            break
        end
        total_started_checks = total_started_checks + 1
    end
    print("action pid " .. selfobject.public.action_pid)
    print("total started checks: " .. total_started_checks)
    return selfobject.public
end 