


MainModule.newOrchestrator  = function (props)

    if not props.args then 
        error("args is required")
    end 

    local selfobject = {}
    selfobject.props = props
    selfobject.actions = {}
    OrchestratorFactory.construct_add_action(selfobject)
    return selfobject
end