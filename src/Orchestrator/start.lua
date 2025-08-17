
function PublicOrchestrator.start_action(public,private,action_name,args)
   
    local found = false
    for i =1 ,#public.actions do
        if public.actions[i].name == action_name then
            found = true
            break
        end
    end
    if not found then 
        error("Action '"..action_name.."' not found in orchestrator actions")
    end
   
    public.total_runned_actions = public.total_runned_actions + 1
    return ActionConstructor.construct(public, action_name,args)

end 