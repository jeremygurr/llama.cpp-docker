FROM rocm/dev-ubuntu-26.04:7.14.0-full
#FROM rocm/dev-ubuntu-24.04:7.2.4-complete
#FROM rocm/dev-ubuntu-22.04:7.2.2-complete
#FROM rocm/dev-ubuntu-22.04:7.2.2

ARG LLAMACPP_ROCM_ARCH=gfx1151

RUN apt-get update && apt-get install -y vim libcurl4-openssl-dev cmake git
#    build-essential \
RUN apt-get install -y \
    cmake \
    glslc \
    libvulkan-dev \
    npm \
    spirv-headers

WORKDIR /workspace/llama.cpp

#RUN pip install --upgrade -r requirements.txt --extra-index-url https://download.pytorch.org/cpu --break-system-packages
#RUN pip install --upgrade transformers --break-system-packages

#RUN pip show amdsmi
#RUN pip uninstall amdsmi -y
#RUN cd /opt/rocm/share/amd_smi
#RUN python3 -m pip install .

# support rocm
#RUN HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
#  GGML_CUDA_ENABLE_UNIFIED_MEMORY=1 \
#  cmake -S . -B build-rocm -DGGML_HIP=ON -DGPU_TARGETS=$LLAMACPP_ROCM_ARCH \
#  -DGGML_NATIVE=ON -DCMAKE_BUILD_TYPE=Release -DLLAMA_CURL=ON \
# && cmake --build build-rocm --config Release -j$(nproc)

# vulkan build
RUN HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
  GGML_CUDA_ENABLE_UNIFIED_MEMORY=1 \
  cmake -S . -B build-vulkan -DGGML_VULKAN=ON -DGPU_TARGETS=$LLAMACPP_ROCM_ARCH \
  -DGGML_NATIVE=ON -DCMAKE_BUILD_TYPE=Release -DLLAMA_CURL=ON \
  && cmake --build build-vulkan --config Release -j$(nproc)

