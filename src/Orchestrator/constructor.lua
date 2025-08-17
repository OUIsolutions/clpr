


MainModule.newOrchestrator  = function (props)

    if not props.args then 
        error("args is required")
    end

    
    heregitage.pairs = props.pairs or pairs
    heregitage.type = props.type or type
    heregitage.setmetatable = props.setmetatable or setmetatable

    local selfobject = heregitage.newMetaObject()
    selfobject.public_props_extends(props)
    selfobject.public_method_extends(PublicOrchestrator)
    selfobject.public.string = props.string or string 
    local entries = Args.collect_entries(selfobject.public.string, props.args)
    
    if  entries then 
       selfobject.public.action_name = entries.action_name
       selfobject.public.dir = entries.dir
    end

    if not props.execute_command then 
        selfobject.public.execute_command = os.execute
    end

    return selfobject.public
end