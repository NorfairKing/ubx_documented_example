CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
PROJECT(example)

set(CMAKE_CXX_FLAGS "-Wall -Werror -fvisibility=hidden")
set(CMAKE_CXX_COMPILER clang++ )
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake") ## temporary resources, for UBX

# Global
set(INSTALL_LIB_TYPES_DIR lib/ubx/types CACHE PATH "Installation directory for types libraries")
set(INSTALL_LIB_BLOCKS_DIR lib/ubx/blocks CACHE PATH "Installation directory for blocks libraries")
set(INSTALL_BIN_APPS_DIR bin CACHE PATH "Installation directory for bin")
set(INSTALL_INCLUDE_DIR include/ubx CACHE PATH "Installation directory for header files (types)")
set(INSTALL_CMAKE_DIR  share/ubx/cmake CACHE PATH  "Installation directory for CMake files") # default ${DEF_INSTALL_CMAKE_DIR}

# Make relative paths absolute
foreach(p LIB_TYPES LIB_BLOCKS BIN INCLUDE CMAKE)
  set(var INSTALL_${p}_DIR)
  if(NOT IS_ABSOLUTE "${${var}}")
    set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()

##
# Add uninstall target.
##
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)
    
add_custom_target(uninstall
    "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake/cmake_uninstall.cmake"
)

##
# Generate config package
##
set(CONF_INCLUDE_DIRS "${INSTALL_INCLUDE_DIR}")
set(CONF_CMAKE_DIR "${INSTALL_CMAKE_DIR}")
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/example-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake/example-config.cmake" @ONLY
)

set (UBX_ROOT $ENV{UBX_ROOT} )
if (NOT UBX_ROOT)
 message( FATAL_ERROR "UBX_ROOT is not defined. CMake install willl abort." )
endif()

find_package(Ubx REQUIRED)

include_directories(
  ${UBX_INCLUDE_DIR}
)

set(GEN_HEXARR ${UBX_ROOT}/tools/file2carr.lua)

file(GLOB types
  ${CMAKE_CURRENT_SOURCE_DIR}/types/*.h
)


set(outfiles "")
foreach( _type ${types} )
  string(REPLACE ".h" ".h.hexarr" _outfile ${_type})
  add_custom_command(
  OUTPUT ${_outfile}
  COMMAND ${GEN_HEXARR}
  ARGS ${_type}  > ${_outfile}
  )
  list(APPEND outfiles ${_outfile})
endforeach(_type)
add_custom_target( gen_hexarr ALL DEPENDS ${outfiles} )

add_library(example_types SHARED types/example_types.c)
set_target_properties(example_types PROPERTIES PREFIX "") 
set_property(TARGET example_types PROPERTY INSTALL_RPATH_USE_LINK_PATH TRUE)
target_link_libraries(example_types ${UBX_LIBRARIES})
add_dependencies(example_types gen_hexarr)

### Install libraries
set_target_properties(example_types PROPERTIES PUBLIC_HEADER "${outfiles};${types}" )

install(TARGETS example_types 
  EXPORT example-types-targets
  LIBRARY DESTINATION "${INSTALL_LIB_TYPES_DIR}" COMPONENT example_types
  PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}/types" COMPONENT dev
)

# Install the example_types-config.cmake 
install(FILES
  "${PROJECT_BINARY_DIR}/cmake/example-config.cmake"
  DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)

# Install the export set for use with the install-tree
install(EXPORT example-types-targets DESTINATION
  "${INSTALL_CMAKE_DIR}" COMPONENT dev)
  
# Compile library bit
add_library(bit SHARED /home/syd/ubx_example/example/src/example_bit.c
/home/syd/ubx_example/example/modules/bit_module.c
)
set_target_properties(bit PROPERTIES PREFIX "")
target_link_libraries(bit ${UBX_LIBRARIES})
add_dependencies(bit gen_hexarr)

# Install bit
install(TARGETS bit DESTINATION ${INSTALL_LIB_BLOCKS_DIR} EXPORT bit-block)
set_property(TARGET bit PROPERTY INSTALL_RPATH_USE_LINK_PATH TRUE)
install(EXPORT bit-block DESTINATION ${INSTALL_CMAKE_DIR})

# Compile library sequence
add_library(sequence SHARED /home/syd/ubx_example/example/src/example_sequence.c
/home/syd/ubx_example/example/modules/sequence_module.c
)
set_target_properties(sequence PROPERTIES PREFIX "")
target_link_libraries(sequence ${UBX_LIBRARIES})
add_dependencies(sequence gen_hexarr)

# Install sequence
install(TARGETS sequence DESTINATION ${INSTALL_LIB_BLOCKS_DIR} EXPORT sequence-block)
set_property(TARGET sequence PROPERTY INSTALL_RPATH_USE_LINK_PATH TRUE)
install(EXPORT sequence-block DESTINATION ${INSTALL_CMAKE_DIR})

# Compile library toggle
add_library(toggle SHARED /home/syd/ubx_example/example/src/example_toggle.c
/home/syd/ubx_example/example/modules/toggle_module.c
)
set_target_properties(toggle PROPERTIES PREFIX "")
target_link_libraries(toggle ${UBX_LIBRARIES})
add_dependencies(toggle gen_hexarr)

# Install toggle
install(TARGETS toggle DESTINATION ${INSTALL_LIB_BLOCKS_DIR} EXPORT toggle-block)
set_property(TARGET toggle PROPERTY INSTALL_RPATH_USE_LINK_PATH TRUE)
install(EXPORT toggle-block DESTINATION ${INSTALL_CMAKE_DIR})

