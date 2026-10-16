set(ANYPS5_HOST_TOOLS_DIR "" CACHE PATH
    "Directory holding native build-time tools named glslang and nid_patcher, run instead of the ones this build produces")
set(ANYPS5_HOST_GLSLANG "" CACHE FILEPATH
    "Native glslang executable run instead of the one this build produces")
set(ANYPS5_HOST_NID_PATCHER "" CACHE FILEPATH
    "Native nid_patcher executable run instead of the one this build produces")

function(anyps5_resolve_host_tool override name commandVariable dependsVariable target)
    set(resolved "")
    if(override)
        set(resolved "${override}")
    elseif(ANYPS5_HOST_TOOLS_DIR)
        set(resolved "${ANYPS5_HOST_TOOLS_DIR}/${name}")
    endif()
    if(resolved)
        if(NOT EXISTS "${resolved}")
            message(FATAL_ERROR "Host tool ${name} not found at ${resolved}")
        endif()
        set(${commandVariable} "${resolved}" PARENT_SCOPE)
        set(${dependsVariable} "" PARENT_SCOPE)
        message(STATUS "Host tool ${name}: ${resolved}")
    else()
        set(${commandVariable} "$<TARGET_FILE:${target}>" PARENT_SCOPE)
        set(${dependsVariable} "${target}" PARENT_SCOPE)
    endif()
endfunction()

anyps5_resolve_host_tool("${ANYPS5_HOST_GLSLANG}" glslang
    ANYPS5_GLSLANG_COMMAND ANYPS5_GLSLANG_DEPENDS glslang-standalone)
anyps5_resolve_host_tool("${ANYPS5_HOST_NID_PATCHER}" nid_patcher
    ANYPS5_NID_PATCHER_COMMAND ANYPS5_NID_PATCHER_DEPENDS nid_patcher)
