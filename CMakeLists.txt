cmake_minimum_required(VERSION 3.10)

# set the project name
project(aten_min)

set(PYTORCH_SRC_DIR ../pytorch)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)
cmake_policy(SET CMP0076 NEW)

option(USE_CUDA "Use CUDA")
option(CLEAN "Clean this source tree" ON)
option(DEEP_CLEAN_PYTORCH "Restore and clean PyTorch source tree")
option(PREP_PYTORCH "Preprocess PyTorch source tree" ON)

if(CLEAN)
  find_package(Git)
  if(Git_FOUND)
    execute_process(COMMAND ${GIT_EXECUTABLE} clean -df)
  endif()
endif()

if(DEEP_CLEAN_PYTORCH)
  find_package(Git)
  if(Git_FOUND)
    execute_process(COMMAND ${GIT_EXECUTABLE} restore :/ WORKING_DIRECTORY ${PYTORCH_SRC_DIR})
    execute_process(COMMAND ${GIT_EXECUTABLE} clean -dfx WORKING_DIRECTORY ${PYTORCH_SRC_DIR})
  endif()
endif()

if(PREP_PYTORCH)
  file(READ ${PYTORCH_SRC_DIR}/CMakeLists.txt FILE_CONTENTS)
  string(REPLACE "include(cmake" "include($\{CMAKE_CURRENT_SOURCE_DIR}/cmake" FILE_CONTENTS ${FILE_CONTENTS})
  file(WRITE ${PYTORCH_SRC_DIR}/CMakeLists.txt ${FILE_CONTENTS})
endif()

# add the executable
add_executable(aten_min aten_min.cpp)
#add_subdirectory(${PYTORCH_SRC_DIR} ${PYTORCH_SRC_DIR}/build)
#add_subdirectory(${PYTORCH_SRC_DIR} ${CMAKE_BINARY_DIR})
include(${PYTORCH_SRC_DIR}/CMakeLists.txt)

target_include_directories(aten_min PUBLIC ${PYTORCH_SRC_DIR}/)
target_include_directories(aten_min PUBLIC ${PYTORCH_SRC_DIR}/build)
target_include_directories(aten_min PUBLIC ${PYTORCH_SRC_DIR}/build/aten/src/)
target_include_directories(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src)
target_include_directories(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/macros)

target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/Exception.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/Type.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/StringUtil.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/Logging.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/flags_use_no_gflags.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/Backtrace.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/typeid.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/core/UndefinedTensorImpl.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/core/TensorImpl.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/UniqueVoidPtr.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/SmallVector.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/native/TensorFactories.cpp)
