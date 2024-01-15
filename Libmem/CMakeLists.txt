add_library(Libmem)
target_sources(Libmem 
        PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/libmem/libmem.h>
        PRIVATE src/libmem.cpp
)
target_include_directories(Libmem
        PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)
target_compile_features(Libmem PUBLIC cxx_std_17)
set_target_properties(Libmem PROPERTIES VERSION ${PROJECT_VERSION} PUBLIC_HEADER $<TARGET_PROPERTY:Libmem,INTERFACE_SOURCES>)
add_library(${PROJECT_NAMESPACE}::Libmem ALIAS Libmem)

install(TARGETS Libmem
        EXPORT ${PROJECT_NAME}Targets
        PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/libmem)