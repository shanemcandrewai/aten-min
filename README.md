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

1. Clone [PyTorch 1.6](https://github.com/pytorch/pytorch/tree/1.6) and adjust the [CMakeLists.txt](CMakeLists.txt) variable `PYTORCH_SRC_DIR` to point to the local repository, for example `set(PYTORCH_SRC_DIR pytorch)`

2. Install the [PyTorch prerequisites](https://github.com/pytorch/pytorch/tree/1.6#from-source)

## Usage
### Restore, preprocess, generate the project buildsystem and redirect output to file

    rm -rf build && cmake -DRESET=1 -S . -B build > cm_out.txt 2>&1

#### Cmake option RESET

This restores the PyTorch source working tree from HEAD and changes some of the CMake scripts and header files to allow building as a suddirectory. This can be enabled by passing the option `-D RESET=1`.

### Build the project

    cmake --build build

### Execute

    ./build/aten_min
