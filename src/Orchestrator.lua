


function MainModule.newOrchestrator (props)

    if not props.args then 
        error("args is required")
    end 


    local selfobject = heregitage.newMetaObject()
    selfobject.public_props_extends(props)
    return selfobject.public
end

function MainModule.internal_test()
    local removed = Args.remove_start_str(string, "clpraction=teste", "clpraction=")
    print(removed)
end 