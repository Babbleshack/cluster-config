FROM nvidia/cuda:10.2-runtime-ubuntu18.04 as VULKAN_IMAGE

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    libx11-xcb-dev \
    libxkbcommon-dev \
    libwayland-dev \
    libxrandr-dev \
    libegl1-mesa-dev \
    python3 \
    python3-distutils \
    python3-apt \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Install cmake version 3.15
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2-Linux-x86_64.tar.gz && \
    tar -xvf cmake-3.15.2-Linux-x86_64.tar.gz && cp cmake-3.15.2-Linux-x86_64/bin/cmake /usr/local/bin && \
    mkdir -p /usr/local/share/cmake-3.15 && \
    cp -r cmake-3.15.2-Linux-x86_64/share/cmake-3.15/* /usr/local/share/cmake-3.15 && \
    rm -rf cmake-3.15.2-Linux-x86_64*


# Download and compile vulkan components
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    git clone https://github.com/KhronosGroup/Vulkan-ValidationLayers.git /opt/vulkan && \
    cd /opt/vulkan && git checkout $(git describe --tags `git rev-list --tags --max-count=1`) && \
    mkdir build && cd build \ 
    && ls -l ../ && echo "----------" && ls -l ../scripts && echo "+++++++++++++++++" \
    && ../scripts/update_deps.py && \
    cmake -C helper.cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build . && make install && ldconfig && \
    mkdir -p /usr/local/lib && cp -a Vulkan-Loader/build/install/lib/* /usr/local/lib && \
    mkdir -p /usr/local/include/vulkan && cp -r Vulkan-Headers/build/install/include/vulkan/* /usr/local/include/vulkan && \
    mkdir -p /usr/local/share/vulkan/registry && \
    cp -r Vulkan-Headers/build/install/share/vulkan/registry/* /usr/local/share/vulkan/registry && \
    rm -rf /opt/vulkan

FROM nvidia/cuda:10.2-runtime-ubuntu18.04 as renderer

#ENV NVIDIA_DRIVER_CAPABILITIES compute,graphics,utility
ENV NVIDIA_DRIVER_CAPABILITIES all

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
        libxau6 libxau6:i386 \
        libxdmcp6 libxdmcp6:i386 \
        libxcb1 libxcb1:i386 \
        libxext6 libxext6:i386 \
        libx11-6 libx11-6:i386 \
	python3-pip \
	git \ 
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    libx11-xcb-dev \
    libxkbcommon-dev \
    libwayland-dev \
    libxrandr-dev \
    libegl1-mesa-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=VULKAN_IAMGE /usr/local/bin /usr/local/bin
COPY --from=VULKAN_IAMGE /usr/local/lib /usr/local/lib
COPY --from=VULKAN_IAMGE /usr/local/include/vulkan /usr/local/include/vulkan
COPY --from=VULKAN_IAMGE /usr/local/share/vulkan /usr/local/share/vulkan
COPY --from=VULKAN_IAMGE /usr/local/share/cmake-3.15 /usr/local/share/cmake-3.15

COPY nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json

RUN pip3 install --upgrade pip && \
	pip3 install \
		torchvision \
		torch \
		pandas \
		psutil \
		plotly \
		cufflinks 

RUN pip3 install \ 
	tensorflow \
	tensorflow-gpu

RUN mkdir work && git clone https://github.com/ryujaehun/pytorch-gpu-benchmark.git work 
WORKDIR /work

FROM nvidia/cuda:10.2-runtime-ubuntu18.04 as renderer-repo

ENV NVIDIA_DRIVER_CAPABILITIES compute,graphics,utility

## Install gfx libs, python and git

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
        libxau6 libxau6:i386 \
        libxdmcp6 libxdmcp6:i386 \
        libxcb1 libxcb1:i386 \
        libxext6 libxext6:i386 \
        libx11-6 libx11-6:i386 \
	libx11-xcb-dev \
	libxkbcommon-dev \
	libwayland-dev \
	libxrandr-dev \
	libegl1-mesa-dev && \
	python3-pip \
	git \ 
	&& rm -rf /var/lib/apt/lists/*

# Set up vulkan

RUN apt update \
	&& apt install -y \
	vulkan-tools \
	libvulkan-dev \
	vulkan-validationslayers-dev 


# Set up pytorch 
RUN pip3 install --upgrade pip && \
	pip3 install \
		torchvision \
		torch \
		pandas \
		psutil \
		plotly \
		cufflinks 

# Set up tensorflow

RUN pip3 install \ 
	tensorflow \
	tensorflow-gpu

RUN mkdir work && git clone https://github.com/ryujaehun/pytorch-gpu-benchmark.git work 
WORKDIR /work


