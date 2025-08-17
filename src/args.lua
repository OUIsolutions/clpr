function Args.starts_with(string_module, str, target_str)
    return string_module.sub( str,1, #target_str) == target_str
end

function Args.remove_start_str(string_module, str, target_str)
    return string_module.sub( str, #target_str + 1)
end

function Args.format_args(string_module,args)
    local content = ""
    for i=0,#args do
        local current = args[i]
        local small_aspas_found = string_module.find(current, "'")
        local big_aspas_found = string_module.find(current, '"')
        if small_aspas_found and not big_aspas_found then
            content = content ..' "'.. current .. '"'

        elseif big_aspas_found and not small_aspas_found then
            content = content.." '".. current .. "'"
        else
            current = string_module.gsub(current, '"', '\\"')
            content = content .. ' "'.. current .. '"'
        end
    end
    return content
end


function Args.sanitize_args(string_module,args)
    local sanitized = {}
    for i=0,#args do
        local arg = args[i]
        if not Args.starts_with(string_module, arg, "clpraction") and not Args.starts_with(string_module, arg, "clprdir") then
            sanitized[#sanitized + 1] = arg
        end
    end
    return sanitized
end

function Args.collect_entries(string_module, args)
   local entries ={}
   for i=0,#args do
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