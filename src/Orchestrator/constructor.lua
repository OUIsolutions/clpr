


MainModule.newOrchestrator  = function (props)

    if not props.args then 
        error("args is required")
    end 
    heregitage.pairs = props.pairs or pairs
    heregitage.type = props.type or type
    heregitage.setmetatable = props.setmetatable or setmetatable

    local selfobject = heregitage.newMetaObject()
    selfobject.public_props_extends(props)
    selfobject.public.string = props.string or string 
    if not props.execute_command then 
        selfobject.public.execute_command = os.execute
    end

    return selfobject.public
end