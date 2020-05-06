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

add_executable(capnp IMPORTED GLOBAL)
set_target_properties(capnp PROPERTIES
    IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/bin/capnp
)
add_dependencies(capnp capnproto-root)

ExternalProject_Add(c-capnp-proj
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps/c-capnproto
    CMAKE_CACHE_ARGS "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}" "-DCMAKE_INSTALL_PREFIX:STRING=${capnproto-root}" ${CCACHE_ARGS}
)
