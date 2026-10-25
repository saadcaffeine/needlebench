# Wraps the portable C99 engine in ../../../../engine as an ESP-IDF component.
# (Reconstructed: the upstream file was dropped by the repo's `needle/` .gitignore rule.)
set(ENGINE_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../../engine")
file(GLOB ENGINE_SRC "${ENGINE_DIR}/src/*.c")

idf_component_register(SRCS ${ENGINE_SRC}
                       INCLUDE_DIRS "${ENGINE_DIR}/include"
                       REQUIRES heap esp_timer esp_hw_support)

target_compile_options(${COMPONENT_LIB} PRIVATE -O2 -Wno-unused-parameter)
# Uncomment for per-phase timing at boot (costs a little speed):
if(ND_PROFILE)
  target_compile_definitions(${COMPONENT_LIB} PRIVATE ND_PROFILE)
endif()
