FROM rocm/dev-ubuntu-24.04:7.2.4-complete
#FROM rocm/dev-ubuntu-22.04:7.2.2-complete
#FROM rocm/dev-ubuntu-22.04:7.2.2

ARG LLAMACPP_ROCM_ARCH=gfx1151

RUN apt-get update && apt-get install -y vim libcurl4-openssl-dev cmake git
RUN mkdir -p /workspace && cd /workspace

#RUN git clone -b b6960 https://github.com/ggml-org/llama.cpp
#RUN git clone -b b7211 https://github.com/ggml-org/llama.cpp
RUN git clone -b b9994 https://github.com/ggml-org/llama.cpp

WORKDIR llama.cpp

RUN pip show amdsmi
#RUN pip uninstall amdsmi -y
#RUN cd /opt/rocm/share/amd_smi
#RUN python3 -m pip install .

# support rocm
RUN HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
  cmake -S . -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=$LLAMACPP_ROCM_ARCH \
  -DCMAKE_BUILD_TYPE=Release -DLLAMA_CURL=ON \
  && cmake --build build --config Release -j$(nproc)

