
function PublicOrchestrator.start_action(public,private,action_name)
    public.total_runned_actions = public.total_runned_actions + 1

    local action_dir = public.database_path.."/"..public.get_pid() .."_"..public.total_runned_actions

    local sanitized_args = Args.sanitize_args(public.string, public.args)
    sanitized_args[#sanitized_args+1] = "clpraction="..action_name
    sanitized_args[#sanitized_args+1] = "clprdir="..action_dir
    sanitized_args[#sanitized_args+1] = "&" 
    local formmated_args = Args.format_args(public.string, sanitized_args)
    print("Executing: clpr "..formmated_args)
end 