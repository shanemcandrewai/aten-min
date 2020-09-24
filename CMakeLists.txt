cmake_minimum_required(VERSION 3.10)

# set the project name
project(aten_min)

set(PYTORCH_SRC_DIR pytorch)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)
cmake_policy(SET CMP0076 NEW)

#option(BUILD_SHARED_LIBS "Build libcaffe2.so")
option(RESET "Restore and modify PyTorch source tree")
option(DEBUG "will enable debug builds (-g -O0)" ON)
option(REL_WITH_DEB_INFO "will enable debug symbols with optimizations (-g -O3)" ON)
option(USE_DISTRIBUTED "will disable distributed (c10d, gloo, mpi, etc.) build.")
option(USE_MKLDNN "will disable using MKL-DNN.")
option(USE_CUDA "will disable compiling CUDA (in case you are developing on something not CUDA related), to save compile time.")
option(BUILD_TEST "will disable building C++ test binaries.")
option(USE_FBGEMM "will disable using FBGEMM (quantized 8-bit server operators).")
option(USE_NNPACK "will disable compiling with NNPACK.")
option(USE_QNNPACK "will disable QNNPACK build (quantized 8-bit operators).")
option(USE_XNNPACK "will disable compiling with XNNPACK.")

#option(BUILD_CAFFE2_OPS "disable build of Caffe2 operators")


if(RESET)
  find_package(Git)
  # Restore PyTorch working tree from HEAD
  if(Git_FOUND)
    execute_process(COMMAND ${GIT_EXECUTABLE} restore :/ WORKING_DIRECTORY ${PYTORCH_SRC_DIR})
  endif()
  # Necessary modifications in PyTorch to allow building as a CMake subdirectory
  file(READ ${PYTORCH_SRC_DIR}/cmake/Dependencies.cmake FILE_CONTENTS)
  string(REPLACE "$\{CMAKE_SOURCE_DIR}" "$\{CMAKE_SOURCE_DIR}/$\{PYTORCH_SRC_DIR}" FILE_CONTENTS "${FILE_CONTENTS}")
  file(WRITE ${PYTORCH_SRC_DIR}/cmake/Dependencies.cmake "${FILE_CONTENTS}")

  file(READ ${PYTORCH_SRC_DIR}/cmake/Codegen.cmake FILE_CONTENTS)
  string(REPLACE "$\{CMAKE_SOURCE_DIR}" "$\{CMAKE_SOURCE_DIR}/$\{PYTORCH_SRC_DIR}" FILE_CONTENTS "${FILE_CONTENTS}")
  string(REPLACE "$\{$\{CMAKE_PROJECT_NAME}_SOURCE_DIR}/" "$\{$\{PROJECT_NAME}_SOURCE_DIR}/" FILE_CONTENTS "${FILE_CONTENTS}")
  string(REPLACE "# FIXME: the file/variable name lists cpp, but these list both cpp and .h files" "execute_process(COMMAND $\{GEN_COMMAND} RESULT_VARIABLE RETURN_VALUE)" FILE_CONTENTS "${FILE_CONTENTS}")
  file(WRITE ${PYTORCH_SRC_DIR}/cmake/Codegen.cmake "${FILE_CONTENTS}")

  file(READ ${PYTORCH_SRC_DIR}/caffe2/core/common.h FILE_CONTENTS)
  string(REPLACE "#include \"caffe2/core/macros.h\"" "#include \"../build/caffe2/core/macros.h\"" FILE_CONTENTS "${FILE_CONTENTS}")
  file(WRITE ${PYTORCH_SRC_DIR}/caffe2/core/common.h "${FILE_CONTENTS}")

  file(READ ${PYTORCH_SRC_DIR}/caffe2/CMakeLists.txt FILE_CONTENTS)
  string(REPLACE "--yaml_dir=$\{CMAKE_CURRENT_BINARY_DIR}/../aten/src/ATen" "--yaml_dir=$\{CMAKE_CURRENT_BINARY_DIR}/../../aten/src/ATen" FILE_CONTENTS "${FILE_CONTENTS}")
  file(WRITE ${PYTORCH_SRC_DIR}/caffe2/CMakeLists.txt "${FILE_CONTENTS}")

  file(READ ${PYTORCH_SRC_DIR}/torch/lib/libshm/CMakeLists.txt FILE_CONTENTS)
  string(REPLACE "$\{CMAKE_BINARY_DIR}/caffe2/aten/src # provides <TH/THGeneral.h> to THC.h" "$\{CMAKE_BINARY_DIR}/pytorch/caffe2/aten/src # provides <TH/THGeneral.h> to THC.h" FILE_CONTENTS "${FILE_CONTENTS}")
  file(WRITE ${PYTORCH_SRC_DIR}/torch/lib/libshm/CMakeLists.txt "${FILE_CONTENTS}")

  file(READ ${PYTORCH_SRC_DIR}/modules/observers/CMakeLists.txt FILE_CONTENTS)
  string(REPLACE "target_include_directories(caffe2_observers PUBLIC $\{CMAKE_CURRENT_SOURCE_DIR}/..)" "target_include_directories(caffe2_observers PUBLIC $\{CMAKE_CURRENT_SOURCE_DIR}/.. PUBLIC $\{CMAKE_BINARY_DIR}/aten/src)" FILE_CONTENTS "${FILE_CONTENTS}")
  file(WRITE ${PYTORCH_SRC_DIR}/modules/observers/CMakeLists.txt "${FILE_CONTENTS}")

  set(RESET OFF CACHE BOOL "Restore and modify PyTorch source tree" FORCE)

endif()

add_subdirectory(${PYTORCH_SRC_DIR})

# add the executable
add_executable(aten_min aten_min.cpp)

target_include_directories(aten_min PUBLIC build)
target_include_directories(aten_min PUBLIC build/aten/src/)
target_include_directories(aten_min PUBLIC build/pytorch/caffe2/aten/src/)
target_include_directories(aten_min PUBLIC ${PYTORCH_SRC_DIR})
target_include_directories(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src)

target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/Dict.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/Dimname.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/Formatting.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/List.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/NamedTensor.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/Tensor.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/VariableHooksInterface.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/boxing/KernelFunction.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/dispatch/DispatchKeyExtractor.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/dispatch/Dispatcher.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/dispatch/OperatorEntry.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/grad_mode.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/interned_strings.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/ivalue.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/op_registration/infer_schema.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/operator_name.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/register_symbols.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/aten/src/ATen/core/type.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/core/DefaultDtype.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/core/Device.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/core/DeviceType.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/core/DispatchKey.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/core/DispatchKeySet.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/core/TensorImpl.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/core/UndefinedTensorImpl.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/core/impl/LocalDispatchKeySet.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/Backtrace.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/Exception.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/Logging.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/SmallVector.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/StringUtil.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/Type.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/flags_use_no_gflags.cpp)
target_sources(aten_min PUBLIC ${PYTORCH_SRC_DIR}/c10/util/typeid.cpp)
target_sources(aten_min PUBLIC build/aten/src/ATen/Functions.cpp)
target_sources(aten_min PUBLIC build/aten/src/ATen/core/TensorMethods.cpp)
