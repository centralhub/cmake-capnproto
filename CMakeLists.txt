cmake_minimum_required(VERSION 3.16)
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    set(CCACHE_ARGS "-DCMAKE_CXX_COMPILER_LAUNCHER:STRING=${CCACHE_PROGRAM}" "-DCMAKE_C_COMPILER_LAUNCHER:STRING=${CCACHE_PROGRAM}")
endif()
project("CMake-Capnproto-Wrapper")
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)

set(capnproto-root ${CMAKE_CURRENT_BINARY_DIR}/capnproto-root)
set(capnproto-root ${capnproto-root} PARENT_SCOPE)

include(ExternalProject)
ExternalProject_Add(capnp-proj
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps/capnproto
    CMAKE_CACHE_ARGS "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}" "-DBUILD_TESTING:STRING=OFF" "-DCMAKE_INSTALL_PREFIX:STRING=${capnproto-root}" ${CCACHE_ARGS}
)

add_custom_command(OUTPUT capnp-ninja-hack.txt
    COMMAND echo hack > capnp-ninja-hack.txt 
    DEPENDS capnp-proj
    BYPRODUCTS ${capnproto-root}/bin/capnp
)

add_custom_target(capnp-proj-ninja-hack
    DEPENDS capnp-ninja-hack.txt
)
add_dependencies(capnp-proj-ninja-hack capnp-proj)

add_executable(capnp IMPORTED GLOBAL)
set_target_properties(capnp PROPERTIES
    IMPORTED_LOCATION ${capnproto-root}/bin/capnp
)
add_dependencies(capnp capnp-proj-ninja-hack)

ExternalProject_Add(c-capnp-proj
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps/c-capnproto
    CMAKE_CACHE_ARGS "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}" "-DCMAKE_INSTALL_PREFIX:STRING=${capnproto-root}" ${CCACHE_ARGS}
)

add_custom_command(OUTPUT capnp-c-ninja-hack.txt
    COMMAND echo hack > capnp-c-ninja-hack.txt
    DEPENDS c-capnp-proj
    BYPRODUCTS ${capnproto-root}/bin/capnp-c ${capnproto-root}/lib/libcapnp_c.a
)

add_custom_target(capnp-c-ninja-hack
    DEPENDS capnp-c-ninja-hack.txt
)
add_library(capnp_c STATIC IMPORTED GLOBAL)
set_target_properties(capnp_c PROPERTIES
    IMPORTED_LOCATION ${capnproto-root}/lib/libcapnp_c.a
)
add_dependencies(capnp_c c-capnp-ninja-hack)

add_executable(capnp-c IMPORTED GLOBAL)

set_target_properties(capnp-c PROPERTIES 
    IMPORTED_LOCATION ${capnproto-root}/bin/capnp-c
    capnp_include_path ${capnproto-root}/include
)
add_dependencies(capnp-c capnp-c-ninja-hack)