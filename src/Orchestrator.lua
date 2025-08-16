


Orchestrator.newOrchestrator  = function (props)
    local selfobject = heregitage.newMetaObject()
    selfobject.public_props_extend(props)
    return selfobject.public
end