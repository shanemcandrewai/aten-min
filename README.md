# PyTorch ATen minimal build example 

This CMakeLists.txt manages the building of a simple C++ program based on the ATen tensor library and the relevant source files (without pre-built libraries) from [PyTorch 1.6](https://github.com/pytorch/pytorch/tree/1.6)

## Simple C++ program : `aten_min.cpp` adapted from [PYTORCH C++ API](https://pytorch.org/cppdocs/)

    #include <ATen/ATen.h>

    int main() {
      at::Tensor a = at::ones({2, 2}, at::kInt);
      at::Tensor b = at::randn({2, 2});
      auto c = a + b.to(at::kInt);
    }

## Prerequisites

1. Clone [PyTorch 1.6](https://github.com/pytorch/pytorch/tree/1.6) and adjust the [CMakeLists.txt](CMakeLists.txt) variable `PYTORCH_SRC_DIR` to point to the local repository, for example `set(PYTORCH_SRC_DIR ../pytorch)`

2. Install the [PyTorch prerequisites](https://github.com/pytorch/pytorch/tree/1.6#from-source)

## Usage
### Generate the project buildsystem
    cmake -S . -B build
#### Cmake options
##### RESET
This restores the PyTorch source working tree from HEAD and reapplies the modifications to paths. This can be enabled by passing the option `-D RESET=1`.
###### NO_BUILD_SHARED_LIBS (dependent on RESET)
The build generates a shared library by default. This can be disabled by passing the option `-D RESET=1 -D NO_BUILD_SHARED_LIBS=1`.
##### CMAKE_BUILD_TYPE 
The default buid type is `Release`. For a debug build pass option `-D CMAKE_BUILD_TYPE=Debug`
##### CMAKE_CXX_FLAGS
###### GCC
`-Og` enables optimizations that do not interfere with debugging
### Build the project
    cmake --build build
### Execute
    ./build/aten_min
### Cleaning / trouble-shooting
#### Linux
    rm build/CMakeCache.txt
    rm -rf build
#### Windows
    del build/CMakeCache.txt
    rmdir /s /q build
    mklink /d build d:\build
#### Clean PyTorch source without using standard ignore rules
    git clean -dfx
