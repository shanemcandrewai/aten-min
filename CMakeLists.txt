cmake_minimum_required(VERSION 3.10)

# set the project name
project(aten_min)

set(PYTORCH_SRC_DIR ../pytorch)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(USE_CUDA OFF CACHE BOOL "CUDA OFF")
cmake_policy(SET CMP0076 NEW)

option(DEEP_CLEAN "Restore and clean source trees" OFF)
if(DEEP_CLEAN)
  message("xxxxxxxx deep")
  execute_process(COMMAND $\{GIT_EXECUTABLE} restore :/ WORKING_DIRECTORY ${PYTORCH_SRC_DIR})
  execute_process(COMMAND $\{GIT_EXECUTABLE} clean -dfx WORKING_DIRECTORY ${PYTORCH_SRC_DIR})
  execute_process(COMMAND $\{GIT_EXECUTABLE} clean -df)
endif()

option(PREP_PYTORCH "Preprocess PyTorch source tree" OFF)
if(PREP_PYTORCH)
  set(CMAKE_SOURCE_DIR_BKP ${CMAKE_SOURCE_DIR})
  set(CMAKE_SOURCE_DIR ${PYTORCH_SRC_DIR})
  configure_file(${PYTORCH_SRC_DIR}/cmake/Dependencies.cmake ${PYTORCH_SRC_DIR}/cmake/Dependencies.cmake})
  set(CMAKE_SOURCE_DIR ${CMAKE_SOURCE_DIR_BKP})
endif()

# add the executable
add_executable(aten_min aten_min.cpp)
add_subdirectory(${PYTORCH_SRC_DIR} ${PYTORCH_SRC_DIR}/build)
#add_subdirectory(${PYTORCH_SRC_DIR} ${CMAKE_BINARY_DIR})
#add_subdirectory(${PYTORCH_SRC_DIR})

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
