-- lfs.lua
local init = require("test_setup")()
local ffi = require("ffi")

--[[
        {"attributes", file_info},
        {"chdir", change_dir},
        {"currentdir", get_dir},
        {"dir", dir_iter_factory},
        {"link", make_link},
        {"lock", file_lock},
        {"mkdir", make_dir},
        {"rmdir", remove_dir},
        {"symlinkattributes", link_info},
        {"setmode", lfs_f_setmode},
        {"touch", file_utime},
        {"unlock", file_unlock},
        {"lock_dir", lfs_lock_dir},
--]]

