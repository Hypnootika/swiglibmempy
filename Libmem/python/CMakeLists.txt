set_property(SOURCE libmem.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE libmem.i PROPERTY SWIG_MODULE_NAME pyLibmem)
swig_add_library(pyLibmem
        TYPE MODULE
        LANGUAGE python
        OUTPUT_DIR ${CMAKE_BINARY_DIR}/python/${PYTHON_PROJECT}/libmem
        SOURCES libmem.i)

add_library(${PROJECT_NAMESPACE}::pyLibmem ALIAS pyLibmem)
target_include_directories(pyLibmem PRIVATE ../include ${Python_INCLUDE_DIRS})
set_property(TARGET pyLibmem PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES ON)

target_compile_features(pyLibmem PRIVATE cxx_std_20)
if(APPLE)
  set_target_properties(pyLibmem PROPERTIES
    SUFFIX ".so"
    INSTALL_RPATH "@loader_path;@loader_path/../../${PYTHON_PROJECT}/.libs"
    )
  set_property(TARGET pyLibmem APPEND PROPERTY
    LINK_FLAGS "-flat_namespace -undefined suppress"
    )
elseif(UNIX)
  set_target_properties(pyLibmem PROPERTIES
    INSTALL_RPATH "$ORIGIN:$ORIGIN/../../${PYTHON_PROJECT}/.libs"
    )
endif()
if(WIN32)
        target_link_libraries(pyLibmem PRIVATE ${PROJECT_NAMESPACE}::Libmem libmem::libmem "shell32.lib" "user32.lib" "psapi.lib" "ntdll.lib")
elseif(UNIX)
        target_link_libraries(pyLibmem PRIVATE ${PROJECT_NAMESPACE}::Libmem libmem::libmem "dl")
else()
        target_link_libraries(pyLibmem PRIVATE ${PROJECT_NAMESPACE}::Libmem libmem::libmem)
endif()


if(MSVC)
    target_link_libraries(pyLibmem PRIVATE ${Python_LIBRARIES})
endif()