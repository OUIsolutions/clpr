

function MetaAction.__gc(public,private)
   public.remove_dir(public.action_dir)
   if public.kill_process_on_end then
       if public.is_alive() then
            if public.use_screen and public.screen_session_name then
                -- Kill the screen session
                public.execute_command("screen -S " .. public.screen_session_name .. " -X quit")
            else
                public.kill_process_by_pid(public.action_pid)
            end
       end
   end
end

PublicAction.is_alive = function(public,private)
    if not public.action_pid then
        return false
    end
    
    -- Check if the process is alive
    local pid_alive = public.is_pid_alive(public.action_pid)
    
    -- If using screen, also verify the screen session exists
    if public.use_screen and public.screen_session_name and pid_alive then
        local check_command = "screen -list | grep -q " .. public.screen_session_name
        local result = os.execute(check_command)
        -- os.execute returns 0 for success (session found)
        return result == 0 or result == true
    end
    
    return pid_alive
end
PublicAction.kill = function(public,private)
    if not public.action_pid then
        return false
    end
    if public.use_screen and public.screen_session_name then
        -- Kill the screen session
        public.execute_command("screen -S " .. public.screen_session_name .. " -X quit")
        return true
    else
        return public.kill_process_by_pid(public.action_pid)
    end
end
PublicAction.wait = function(public,private,max_sleep_cicles,sleep_callback)
    if not public.action_pid then
        return false
    end
    for i =1,max_sleep_cicles do
        if not public.is_alive() then 
            return
        end
        sleep_callback()
    end
    error("Timeout waiting for action to finish")
end

PublicAction.get_result = function(public,private)
    local result_path = public.action_dir.."/result.lua"
    local result_content = public.load_file(result_path)
    if not result_content then
        return nil
    end 
    return public.loader(result_content)
end

PublicAction.attach_screen = function(public,private)
    if not public.use_screen then
        error("Screen mode is not enabled for this action")
    end
    if not public.screen_session_name then
        error("No screen session name available")
    end
    -- Return the command to attach to the screen session
    -- User can run this manually: screen -r <session_name>
    return "screen -r " .. public.screen_session_name
end

PublicAction.get_screen_session_name = function(public,private)
    if not public.use_screen then
        return nil
    end
    return public.screen_session_name
end

function ActionConstructor.construct(public_orchestrator,action_name,args)
    local selfobject = heregitage.newMetaObject()
    selfobject.public_props_extends(public_orchestrator)
    selfobject.public_method_extends(PublicAction)
    selfobject.meta_method_extends(MetaAction)
    -- the safest aproach its the default 
    selfobject.public.kill_process_on_end = true 
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
    
    if selfobject.public.use_screen then
        -- Generate unique screen session name
        local screen_name = "clpr_"..action_name.."_"..public_orchestrator.get_pid().."_"..public_orchestrator.total_runned_actions
        selfobject.public.screen_session_name = screen_name
        
        -- Create detached screen session with the command
        -- -dmS: detached mode with session name
        formmated_command = "screen -dmS " .. screen_name .. " " .. formmated_command
    else
        formmated_command = formmated_command .." &"
    end

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