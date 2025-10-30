FROM rocm/dev-ubuntu-24.04:6.4-complete

ARG LLAMACPP_ROCM_ARCH gfx1151

RUN apt-get update && apt-get install -y nano libcurl4-openssl-dev cmake git
RUN mkdir -p /workspace && cd /workspace
RUN git clone https://github.com/ROCm/llama.cpp
WORKDIR llama.cpp
RUN HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
  cmake -S . -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=$LLAMACPP_ROCM_ARCH \
  -DCMAKE_BUILD_TYPE=Release -DLLAMA_CURL=ON \
  && cmake --build build --config Release -j$(nproc)

