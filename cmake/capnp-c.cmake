function(require_targets)
    set(MISSING_TARGETS)
    foreach(target ${ARGN})
        if (NOT TARGET ${target})
            list(APPEND MISSING_TARGETS ${target})
        endif()
    endforeach()
    if(MISSING_TARGETS)    
        message(FATAL_ERROR "Missing required targets: ${MISSING_TARGETS}")
    endif()
endfunction()

require_targets(native-capnp native-capnp-c capnp_c) 

function(add_capnproto schema_file)
    get_filename_component(basename ${schema_file} NAME)
    get_filename_component(actual_source ${schema_file} ABSOLUTE)
    get_filename_component(actual_source_dir ${actual_source} DIRECTORY)
    message(STATUS "Will build ${basename}.c")
    add_custom_command(
        OUTPUT ${basename}.c ${basename}.h
        DEPENDS ${actual_source} native-capnp native-capnp-c
        COMMAND native-capnp compile -o $<TARGET_FILE:native-capnp-c> -I $<TARGET_PROPERTY:native-capnp-c,capnp_include_path> --src-prefix=${actual_source_dir} ${actual_source}
        #COMMAND echo "hello" > ${basename}.c
    )
    get_filename_component(libname ${schema_file} NAME_WE)
    add_library(${libname} STATIC ${CMAKE_CURRENT_BINARY_DIR}/${basename}.c)
    target_include_directories(${libname} PUBLIC ${CMAKE_CURRENT_BINARY_DIR} $<TARGET_PROPERTY:native-capnp-c,capnp_include_path>)
    target_link_libraries(${libname} PUBLIC capnp_c)
endfunction()
