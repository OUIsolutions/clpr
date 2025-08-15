function build_no_return()
local all = {[[(function()]]}
    all[#all + 1] = "local PublicApi = {}"
    all[#all + 1] = "local PrivateApi = {}"
  local files = darwin.dtw.list_files_recursively("src",true)

  for _, file in ipairs(files) do
    all[#all  +1 ] = darwin.dtw.load_file(file) .."\n"
  end
  all[#all + 1] = [[
    return PublicApi;
end)()]]
return table.concat(all, "\n")    
end
function  build_with_return()
    return "return "..build_no_return()
end


local no_return = build_no_return()
darwin.dtw.write_file("release/embed.lua", no_return)
local with_return = build_with_return()
darwin.dtw.write_file("release/lib.lua", with_return)