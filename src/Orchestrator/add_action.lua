
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
        local entries_dir = public.dir.."/entries.lua"
        
    end

    return props.name
end
