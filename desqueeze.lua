local LrApplication = import 'LrApplication'
local LrTasks       = import 'LrTasks'
local LrDialogs     = import 'LrDialogs'
local logger = import 'LrLogger'('desqueeze')

local plugin_path   = string.gsub(_PLUGIN.path, '\\', '/')
local exiftool_path = plugin_path .. '/exiftool-13.19_64/exiftool-13.19_64/exiftool.exe'

function desqueeze_one(photo)
    local path = photo:getRawMetadata('path')
    path = string.gsub(path, '\\', '/')

    local cmd  =  'cmd.exe /C ' .. exiftool_path .. ' -DefaultScale="1.33 1.0" -m -overwrite_original ' .. '"' .. path .. '"'
    logger:info("running command: " .. cmd)

    local result = LrTasks.execute(cmd)
    logger:info("returned: " .. result)
end

LrTasks.startAsyncTask(function ()

    local catalog = LrApplication.activeCatalog()
    local targets = catalog:getTargetPhotos();
    
    for i, photo in ipairs(targets) do
        desqueeze_one(photo)
    end

end)
