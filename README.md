# cmake-capnproto
CMake integration for Capnproto

# Usage
```cmake
add_subdirectory(cmake-capnproto)
include(capnp-c)
add_capnproto(path/to/myschema.capnp)

add_executable(myexecutable ...)
target_link_libraries(myexecutable myschema)
```
