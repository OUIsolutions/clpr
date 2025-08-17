
function ActionConstructor.construct(public_orchestrator,action_name)
    local selfobject = heregitage.newMetaObject()
    selfobject.public_props_extends(public_orchestrator)
    local action_dir = public_orchestrator.database_path.."/"..public_orchestrator.get_pid() .."_"..public_orchestrator.total_runned_actions
    local sanitized_args = Args.sanitize_args(public_orchestrator.string, public_orchestrator.args)
    sanitized_args[#sanitized_args+1] = "clpraction="..action_name
    sanitized_args[#sanitized_args+1] = "clprdir="..action_dir
    sanitized_args[#sanitized_args+1] = "&" 
    local formmated_args = Args.format_args(public_orchestrator.string, sanitized_args)
    print("Executing: clpr("..formmated_args..")")
    return selfobject.public
end 