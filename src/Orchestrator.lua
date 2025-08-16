


Orchestrator.newOrchestrator  = function (props)

    if not props.args then 
        error("args is required")
    end 
    

    local selfobject = heregitage.newMetaObject()
    selfobject.public_props_extend(props)
    return selfobject.public
end