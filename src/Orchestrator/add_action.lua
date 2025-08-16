
function OrchestratorFactory.construct_add_action(selfobj)
    selfobj.add_action = function (props)
        if not props.name then
            error("Action name is required")
        end
        if not props.callback then
            error("Action callback is required")
        end

        for i=1,#selfobj.actions do
            if selfobj.actions[i].name == props.name then
                error("Action with name '" .. props.name .. "' already exists")
            end
        end
        
        local action = {
            name = props.name,
            callback = props.callback,
        } 
        selfobj.actions[#selfobj.actions + 1] = action
        return props.name        
    end
end
