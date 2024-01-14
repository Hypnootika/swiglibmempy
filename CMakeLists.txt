cmake_minimum_required(VERSION 3.27)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
option(CMAKE_EXPORT_COMPILE_COMMANDS "Export compile command" TRUE)

project(swiglibmem VERSION 0.1.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(PROJECT_NAMESPACE slm)
set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/lib)
set(SUBPROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Libmem)
set(SUBPROJECT_DIR_INCLUDE ${SUBPROJECT_DIR}/include)
set(SUBPROJECT_DIR_PYTHON ${SUBPROJECT_DIR}/python)
include_directories(${INCLUDE_DIR} ${SUBPROJECT_DIR_INCLUDE} ${SUBPROJECT_DIR_PYTHON})
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
            "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel. (default: Release)"
            FORCE)
endif()

option(BUILD_SHARED_LIBS "Build shared libraries (.dll)." OFF)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
foreach(OutputConfig IN LISTS CMAKE_CONFIGURATION_TYPES)
    string(TOUPPER ${OutputConfig} OUTPUTCONFIG)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/${OutputConfig}/${CMAKE_INSTALL_BINDIR})
endforeach()

include(cpp)

include(libmem)
file(COPY ${LIBMEM_INCLUDE_DIRS}/libmem DESTINATION ${SUBPROJECT_DIR_INCLUDE})
file(COPY ${_LIBMEM_RELEASE_LIBRARY} DESTINATION ${LIB_DIR})

include(swig)
option(FETCH_PYTHON_DEPS "Install python required modules if not available" ON)
message(STATUS "Python fetch dependencies: ${FETCH_PYTHON_DEPS}")

option(VENV_USE_SYSTEM_SITE_PACKAGES "Python venv can use system site packages" OFF)
message(STATUS "Python: Allow venv to use system site packages: ${VENV_USE_SYSTEM_SITE_PACKAGES}")

include(python)











