function Args.starts_with(string_module, str, target_str)
    return string_module.sub( str,1, #target_str) == target_str
end

function Args.remove_start_str(string_module, str, target_str)
    return string_module.sub( str, #target_str + 1)
end
function Args.sanitize_args(string_module,args)
    local sanitized = {}
    for i=1,#args do
        local arg = args[i]
        if not Args.starts_with(string_module, arg, "clpraction") and not Args.starts_with(string_module, arg, "clprdir") then
            sanitized[#sanitized + 1] = arg
        end
    end
    return sanitized
end

function Args.collect_entries(string_module, args)
   local entries ={}
   for i=1,#args do
       local arg = args[i]
       if Args.starts_with(string_module, arg, "clpraction") then
           entries.action_name = Args.remove_start_str(string_module, arg, "clpraction=")
       end
        if Args.starts_with(string_module, arg, "clprdir") then
        entries.dir = Args.remove_start_str(string_module, arg, "clprdir=")
        end 
   end
   if entries.action_name and entries.dir then
       return entries
   end
   return nil
end