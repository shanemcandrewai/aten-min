# aten_min
CMakeLists.txt for a minimal PyTorch at::Tensor example

## Goal

Develop a CMakeLists.txt to manage the building of a simple C++ program based on the ATen tensor library and the relevant source files (without pre-built libraries) from [PyTorch 1.6](https://github.com/pytorch/pytorch/tree/1.6)

## Simple C++ program : `aten_min.cpp` taken from [PYTORCH C++ API](https://pytorch.org/cppdocs/)

    #include <ATen/ATen.h>

    at::Tensor a = at::ones({2, 2}, at::kInt);
    at::Tensor b = at::randn({2, 2});
    auto c = a + b.to(at::kInt);

## Prerequisites

1. Clone [PyTorch 1.6](https://github.com/pytorch/pytorch/tree/1.6) and adjust the [CMakeLists.txt](CMakeLists.txt) variable `PYTORCH_SRC_DIR` to point to the local repository, for example `set(PYTORCH_SRC_DIR ../pytorch)`

2. Install the [PyTorch prerequisites](https://github.com/pytorch/pytorch/tree/1.6#from-source)

## Clean, preprocess, generate the project buildsystem and redirect output to file

    rm -rf build && cmake -S . -B build > cm_out.txt 2>&1

## Build the project

    cmake --build build
