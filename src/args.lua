function Args.starts_with( str, target_str)
    return str:sub( 1, #target_str) == target_str
end

function Args.remove_start_str( str, target_str)
    return str:sub( #target_str + 1)
end

function Args.collect_entries(string_module, args)
    
end