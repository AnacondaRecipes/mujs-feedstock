cmake_minimum_required(VERSION 3.16)
project(mujs LANGUAGES C)

# ------------------------------------------------------------
# Options
# ------------------------------------------------------------

option(MUJS_USE_READLINE "Enable readline support" OFF)

# ------------------------------------------------------------
# C standard and warnings
# ------------------------------------------------------------
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS True)

if (MSVC)
    add_compile_options(/W4)
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS)
else()
    add_compile_options(
        -Wall -Wextra -Wpedantic -Wno-unused-parameter
    )
endif()

# ------------------------------------------------------------
# Libraries
# ------------------------------------------------------------

set(ONE_C ${PROJECT_SOURCE_DIR}/one.c)
add_library(mujs_shared SHARED ${ONE_C})
set_target_properties(mujs_shared PROPERTIES OUTPUT_NAME mujs)

# ------------------------------------------------------------
# Include directories
# ------------------------------------------------------------

target_include_directories(mujs_shared PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

# ------------------------------------------------------------
# Math library (needed on MinGW/Linux)
# ------------------------------------------------------------

if (NOT MSVC)
    target_link_libraries(mujs_shared m)
endif()

# ------------------------------------------------------------
# Readline (optional)
# ------------------------------------------------------------

if (MUJS_USE_READLINE)
    add_compile_definitions(HAVE_READLINE)
    find_library(READLINE_LIB readline)
endif()

# ------------------------------------------------------------
# Executables
# ------------------------------------------------------------

add_executable(mujs ${CMAKE_CURRENT_SOURCE_DIR}/main.c ${ONE_C})
add_executable(mujs-pp ${CMAKE_CURRENT_SOURCE_DIR}/pp.c ${ONE_C})

# ------------------------------------------------------------
# Installation
# ------------------------------------------------------------

include(GNUInstallDirs)

install(FILES mujs.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/release/mujs.pc DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)
install(TARGETS mujs_shared
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})

install(TARGETS mujs RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(TARGETS mujs-pp RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
