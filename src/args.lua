function Args.starts_with(string_modlue, str, target_str)
    return string_modlue.sub(str, 1, #target_str) == target_str
end

function Args.remove_start_str(string_module, str, target_str)
    return string_module.sub(str, #target_str + 1)
end

function Args.collect_entries(string_module, args)
    
end