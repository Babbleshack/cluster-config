FROM nvidia/cuda:10.2-runtime-ubuntu18.04 as renderer-repo

#ENV NVIDIA_DRIVER_CAPABILITIES compute,graphics,utility
ENV NVIDIA_DRIVER_CAPABILITIES all

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
	libegl1-mesa-dev \
	git \ 
	&& rm -rf /var/lib/apt/lists/*

# Set up vulkan


RUN apt update && apt install --yes software-properties-common 
RUN add-apt-repository --yes ppa:graphics-drivers/ppa

RUN apt update \
	&& apt install -y \
	vulkan-tools \
	libvulkan-dev
	#vulkan-validationslayers-dev 

RUN apt update \
	&& apt install --yes \
	python3-pip \
	python-setuptools

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
	tensorflow-gpu \
	&& rm -rf /var/lib/apt/lists/* 

RUN mkdir work && git clone https://github.com/ryujaehun/pytorch-gpu-benchmark.git work 
WORKDIR /work


