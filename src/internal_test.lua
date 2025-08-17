

function MainModule.internal_test()
    local entries = Args.collect_entries(string, arg)
    if entries then 
        print("action name ".. entries.action_name)
        print("dir ".. entries.dir)
    end 
end