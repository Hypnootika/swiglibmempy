add_library(Libmem STATIC
        include/libmem/libmem.h)
target_sources(Libmem PRIVATE
    include/libmem/libmem.h
    src/libmem.cpp
)
target_include_directories(Libmem
        PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)
target_compile_features(Libmem PUBLIC cxx_std_17)
set_target_properties(Libmem PROPERTIES VERSION ${PROJECT_VERSION} PUBLIC_HEADER include/libmem/libmem.h)
add_library(${PROJECT_NAMESPACE}::Libmem ALIAS Libmem)

set_target_properties(Libmem PROPERTIES OUTPUT_NAME libmem)
install(TARGETS Libmem
        EXPORT ${PROJECT_NAME}Targets
        PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/libmem)