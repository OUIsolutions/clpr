


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
    
    return selfobject.public
end