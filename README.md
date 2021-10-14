# cmake-capnproto
CMake integration for Cap'n Proto

# Usage
Note that this project uses git submodules.
```bash
git submodule update --init --recursive
```
from the top level usually does the correct thing.



```cmake
add_subdirectory(cmake-capnproto)
include(capnp-c)
add_capnproto(path/to/myschema.capnp)

add_executable(myexecutable ...)
target_link_libraries(myexecutable myschema)
```
