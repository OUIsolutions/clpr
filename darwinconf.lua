function install_dependencies()
  os.execute("mkdir -p dependencies")
  if not darwin.dtw.isfile("dependencies/herigitage.lua") then 
    os.execute("curl -L https://github.com/OUIsolutions/LuaHeritage/releases/download/1.0.0/heregitage.lua -o dependencies/herigitage.lua")
  end
end

function build_embed_code()
local heregitage = darwin.dtw.load_file("dependencies/herigitage.lua")

  local all = {[[(function()]]}
    all[#all + 1] = darwin.dtw.load_file("objects.lua") .. "\n"
    all[#all + 1] = "local heregitage = (function()  "..heregitage .. " end\n)()\n"

    local files = darwin.dtw.list_files_recursively("src",true)

    for _, file in ipairs(files) do
      all[#all  +1 ] = darwin.dtw.load_file(file) .."\n"
    end
    all[#all + 1] = [[
      return MainModule;
  end)()]]
  return table.concat(all, "\n")
end
function  build_lib_code()
    local embed  = build_embed_code()
    lib = "return "..embed
    return lib
end

function  main()
   install_dependencies()
   local embed_code = build_embed_code()
   darwin.dtw.write_file("release/embed.lua", embed_code)
   local lib_code = build_lib_code()
   darwin.dtw.write_file("release/lib.lua", lib_code)
end
main()