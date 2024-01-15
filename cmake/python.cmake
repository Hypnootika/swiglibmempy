cmake_minimum_required(VERSION 3.18)
set(CMAKE_SWIG_FLAGS)
find_package(SWIG REQUIRED)
include(UseSWIG)
if(WIN32)
set(CMAKE_SWIG_FLAGS "-DLM_COMPATIBLE;-DLM_FORCE_BITS_64;-DLM_FORCE_LANG_CPP;-DLM_FORCE_ARCH_X86;-DLM_FORCE_OS_WIN;-DWIN32;-DLM_FORCE_COMPILER_MSVC;-DLM_FORCE_CHARSET_MB") 
elseif(UNIX)
set(CMAKE_SWIG_FLAGS "-DLM_FORCE_BITS_64;-DLM_FORCE_LANG_CPP;-LM_FORCE_ARCH_X86;-DLM_FORCE_OS_LINUX;-Dlinux;-DLM_FORCE_COMPILER_CC;-DLM_FORCE_CHARSET_MB")
else()
set(CMAKE_SWIG_FLAGS "-DLM_FORCE_BITS_64;-DLM_FORCE_LANG_CPP;-LM_FORCE_ARCH_X86;-DLM_FORCE_OS_LINUX;-Dlinux;-DLM_FORCE_COMPILER_CC;-DLM_FORCE_CHARSET_MB")
endif()

if(UNIX AND NOT APPLE)
  list(APPEND CMAKE_SWIG_FLAGS "-DSWIGWORDSIZE64")
endif()
find_package(Python REQUIRED COMPONENTS Interpreter Development.Module)
function(search_python_module)
    set(options NO_VERSION)
    set(oneValueArgs NAME PACKAGE)
    set(multiValueArgs "")
    cmake_parse_arguments(MODULE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    message(STATUS "Searching python module: \"${MODULE_NAME}\"")
    if(${MODULE_NO_VERSION})
        execute_process(COMMAND ${Python_EXECUTABLE} -c "import ${MODULE_NAME}" RESULT_VARIABLE _RESULT ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
        set(MODULE_VERSION "unknown")
    else()
        execute_process(COMMAND ${Python_EXECUTABLE} -c "import ${MODULE_NAME}; print(${MODULE_NAME}.__version__)" RESULT_VARIABLE _RESULT OUTPUT_VARIABLE MODULE_VERSION ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    endif()
    if(${_RESULT} STREQUAL "0")
        message(STATUS "Found python module: \"${MODULE_NAME}\" (found version \"${MODULE_VERSION}\")")
    else()
        if(FETCH_PYTHON_DEPS)
            message(WARNING "Can't find python module: \"${MODULE_NAME}\", install it using pip...")
            execute_process(
                    COMMAND ${Python_EXECUTABLE} -m pip install --user ${MODULE_PACKAGE}
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
        else()
            message(FATAL_ERROR "Can't find python module: \"${MODULE_NAME}\", please install it using your system package manager.")
        endif()
    endif()
endfunction()
function(search_python_internal_module)
  set(options "")
  set(oneValueArgs NAME)
  set(multiValueArgs "")
  cmake_parse_arguments(MODULE
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )
  message(STATUS "Searching python module: \"${MODULE_NAME}\"")
  execute_process(
    COMMAND ${Python3_EXECUTABLE} -c "import ${MODULE_NAME}"
    RESULT_VARIABLE _RESULT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  if(${_RESULT} STREQUAL "0")
    message(STATUS "Found python internal module: \"${MODULE_NAME}\"")
  else()
    message(FATAL_ERROR "Can't find python internal module \"${MODULE_NAME}\", please install it using your system package manager.")
  endif()
endfunction()


list(APPEND CMAKE_SWIG_FLAGS "-I${PROJECT_SOURCE_DIR}")
set(PYTHON_PROJECT "py${PROJECT_NAME}")
message(STATUS "Python project: ${PYTHON_PROJECT}")
set(PYTHON_PROJECT_DIR ${PROJECT_BINARY_DIR}/python/${PYTHON_PROJECT})
message(STATUS "Python project build path: ${PYTHON_PROJECT_DIR}")
foreach(P IN ITEMS Libmem)
    add_subdirectory(${P}/python)
endforeach()

file(GENERATE OUTPUT ${PYTHON_PROJECT_DIR}/__init__.py CONTENT "__version__ = \"${PROJECT_VERSION}\"\n")
file(GENERATE OUTPUT ${PYTHON_PROJECT_DIR}/libmem/__init__.py CONTENT "")

configure_file(${PROJECT_SOURCE_DIR}/python/setup.py.in ${PROJECT_BINARY_DIR}/python/setup.py.in @ONLY)
file(GENERATE OUTPUT ${PROJECT_BINARY_DIR}/python/setup.py INPUT ${PROJECT_BINARY_DIR}/python/setup.py.in)
search_python_module(NAME setuptools PACKAGE setuptools)
search_python_module(NAME wheel PACKAGE wheel)
add_custom_command(
        OUTPUT python/dist/timestamp
        COMMAND ${CMAKE_COMMAND} -E remove_directory dist
        COMMAND ${CMAKE_COMMAND} -E make_directory ${PYTHON_PROJECT}/.libs
        # Don't need to copy static lib on Windows.
        COMMAND ${CMAKE_COMMAND} -E $<IF:$<STREQUAL:$<TARGET_PROPERTY:Libmem,TYPE>,SHARED_LIBRARY>,copy,true>
        $<$<STREQUAL:$<TARGET_PROPERTY:Libmem,TYPE>,SHARED_LIBRARY>:$<TARGET_SONAME_FILE:Libmem>>
        ${PYTHON_PROJECT}/.libs
        COMMAND ${CMAKE_COMMAND} -E $<IF:$<STREQUAL:$<TARGET_PROPERTY:Libmem,TYPE>,SHARED_LIBRARY>,copy,true>
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:pyLibmem> ${PYTHON_PROJECT}/libmem
        COMMAND ${Python_EXECUTABLE} setup.py bdist_wheel
        COMMAND ${CMAKE_COMMAND} -E touch ${PROJECT_BINARY_DIR}/python/dist/timestamp
        MAIN_DEPENDENCY
            python/setup.py.in
        DEPENDS
            python/setup.py
        ${PROJECT_NAMESPACE}::Libmem
        ${PROJECT_NAMESPACE}::pyLibmem
        BYPRODUCTS
            python/${PYTHON_PROJECT}
            python/${PYTHON_PROJECT}.egg-info
            python/build
            python/dist
        WORKING_DIRECTORY python
        COMMAND_EXPAND_LISTS)

# Main Target
add_custom_target(python_package ALL
        DEPENDS
        python/dist/timestamp
        WORKING_DIRECTORY python)