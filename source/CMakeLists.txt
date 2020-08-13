
#list(REMOVE_ITEM CMAKE_CXX_FLAGS "-fno-exceptions")
#set(CMAKE_CXX_FLAGS "-fexceptions ${CMAKE_CXX_FLAGS}")

set(LLVM_LINK_COMPONENTS support)
set(LLVM_USED_LIBS clangTooling clangBasic clangAST)

add_clang_executable(binder
  binder.cpp
  binder.hpp

  context.hpp
  context.cpp

  class.hpp
  class.cpp

  config.hpp
  config.cpp

  enum.hpp
  enum.cpp

  function.hpp
  function.cpp

  type.hpp
  type.cpp

  util.hpp
  util.cpp

  fmt/format.cc
  fmt/posix.cc
  )
if(USE_EXTERNAL_LLVM)
  find_library(lib_llvm_so_path  NAMES LLVM 
                           LLVM-${LLVM_VERSION_MAJOR} 
                           LLVM-${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR} 
                           LLVM-${LLVM_VERSION_MAJOR}.${LLVM_VERSION_MINOR}.${LLVM_VERSION_PATCH}
                           PATHS  ${LLVM_LIBRARY_DIR}  ${LLVMLIBDIR}
                           )
#We set a default list of statically linked libraries. Even if the static build is not requested.
  if (NOT STATIC_BUILD_REQUIRED_STATIC_LIBRARY_NAMES)
    set(STATIC_BUILD_REQUIRED_STATIC_LIBRARY_NAMES  llvm LLVMOption LLVMSupport LLVMBitReader LLVMMC LLVMTransformUtils LLVMCore LLVMMCParser tinfo)
  endif()
  if (NOT REQUIRED_DYNAMIC_LIBRARY_NAMES)
    set(REQUIRED_DYNAMIC_LIBRARY_NAMES stdc++ pthread dl)  
  endif()
#Macro to  check the presense of the libraries and add them to the list
  set(STATIC_BUILD_STATIC_LIBRARIES ) 
  macro(check_static_libraries)
    foreach (X IN LISTS STATIC_BUILD_REQUIRED_STATIC_LIBRARY_NAMES)
      find_library(${X}result  NAMES lib${X}.a PATHS  ${LLVM_LIBRARY_DIR}  ${LLVMLIBDIR})
      message(STATUS "binder: checking static library presense ${X}=${${X}result}")
      list(APPEND STATIC_BUILD_STATIC_LIBRARIES  ${${X}result})
    endforeach()
  endmacro(check_static_libraries)
  set(DYNAMIC_LINK_FLAG "-Wl,-Bdynamic")
  if(STATIC_BUILD)
    set(STATIC_LINK_FLAG "-Wl,-Bstatic")
    set(lib_llvm_so_path  "")
  else()
    set(STATIC_LINK_FLAG  )
    set(STATIC_BUILD_REQUIRED_STATIC_LIBRARY_NAMES )
  endif()

  add_definitions(${LLVM_DEFINITIONS})
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${LLVM_COMPILE_FLAGS}")
  list(REMOVE_ITEM CMAKE_CXX_FLAGS "-fno-exceptions")
  string (REPLACE "-fno-exceptions" ""     CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
  message(STATUS "binder: CMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}")
  message(STATUS "binder: STATIC_BUILD_STATIC_LIBRARIES=${STATIC_BUILD_STATIC_LIBRARIES}")
  if (LLVM_VERSION_MAJOR EQUAL 3 )
    check_static_libraries()
    target_link_libraries(binder PRIVATE       -Wl,--start-group ${STATIC_LINK_FLAG}  ${STATIC_BUILD_STATIC_LIBRARIES}  
      ${STATIC_LINK_FLAG}
      clang
      clangAnalysis 
      clangARCMigrate
      clangAST
      clangASTMatchers
      clangBasic 
      clangCodeGen
      clangDriver
      clangDynamicASTMatchers
      clangEdit 
      clangFormat 
      clangFrontend
      clangFrontendTool
      clangLex 
      clangParse
      clangRewriteFrontend
      clangSema
      clangSerialization
      clangTooling
      -Wl,--end-group
      ${DYNAMIC_LINK_FLAG}  ${REQUIRED_DYNAMIC_LIBRARY_NAMES}  ${lib_llvm_so_path}
    )
  endif()

  if ( (LLVM_VERSION_MAJOR GREATER 3)  AND (LLVM_VERSION_MAJOR LESS 8) )
    check_static_libraries()
    target_link_libraries(binder PRIVATE
      ${STATIC_LINK_FLAG}  ${STATIC_BUILD_STATIC_LIBRARIES} 
      ${STATIC_LINK_FLAG}
        clangAST
        clangBasic 
        clangFrontend
        clangTooling
      ${DYNAMIC_LINK_FLAG}  ${REQUIRED_DYNAMIC_LIBRARY_NAMES}  ${lib_llvm_so_path}
      )
  endif()
  if ( (LLVM_VERSION_MAJOR EQUAL 8) OR (LLVM_VERSION_MAJOR EQUAL 9) )
    check_static_libraries()
    target_link_libraries(binder PRIVATE 
      ${STATIC_LINK_FLAG} ${STATIC_BUILD_STATIC_LIBRARIES} 
      ${STATIC_LINK_FLAG}
        clangTooling
        clangBasic
        clangAST
        clangFrontend
        clangSerialization
      ${DYNAMIC_LINK_FLAG}  ${REQUIRED_DYNAMIC_LIBRARY_NAMES} ${lib_llvm_so_path}
      )
  endif()
  if ( (LLVM_VERSION_MAJOR EQUAL 10) OR (LLVM_VERSION_MAJOR GREATER 10) )
    check_static_libraries()
    target_link_libraries(binder PRIVATE 
      ${STATIC_LINK_FLAG} ${STATIC_BUILD_STATIC_LIBRARIES} 
      ${STATIC_LINK_FLAG}
        clang 
        clang-cpp
      ${DYNAMIC_LINK_FLAG}  ${REQUIRED_DYNAMIC_LIBRARY_NAMES} ${lib_llvm_so_path}
    )
  endif()
else()
  target_link_libraries(binder
    PRIVATE
    clangTooling
    clangBasic
    clangASTMatchers
    clangAST
    clangFrontend
    )
endif()
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/binder 
PERMISSIONS WORLD_EXECUTE WORLD_READ OWNER_WRITE OWNER_READ OWNER_EXECUTE 
DESTINATION ${CMAKE_INSTALL_BINDIR})