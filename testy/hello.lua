local utils = require("test_utils")

print("LibPath: ",utils.LibPath)

package.path = package.path..";"..utils.LibPath.."/?.lua"

print("Package: ", package.path)

require("init")
