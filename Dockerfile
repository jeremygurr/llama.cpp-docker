#FROM rocm/dev-ubuntu-24.04:6.4-complete
FROM rocm/dev-ubuntu-24.04:7.0.2-complete

ARG LLAMACPP_ROCM_ARCH gfx1151

RUN apt-get update && apt-get install -y nano libcurl4-openssl-dev cmake git
RUN mkdir -p /workspace && cd /workspace

#RUN git clone -b amd-integration https://github.com/ROCm/llama.cpp
RUN git clone -b b6888 https://github.com/ggml-org/llama.cpp

WORKDIR llama.cpp
RUN HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
  cmake -S . -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=$LLAMACPP_ROCM_ARCH \
  -DCMAKE_BUILD_TYPE=Release -DLLAMA_CURL=ON \
  && cmake --build build --config Release -j$(nproc)

