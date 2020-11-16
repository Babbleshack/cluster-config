FROM nvidia/cuda:11.0-runtime-ubuntu20.04 as renderer-repo

#ENV NVIDIA_DRIVER_CAPABILITIES compute,graphics,utility
ENV NVIDIA_DRIVER_CAPABILITIES all

RUN apt update && apt install --yes software-properties-common 
RUN add-apt-repository --yes ppa:graphics-drivers/ppa

RUN apt update \
	&& apt install -y --no-install-recommends \
	vulkan-tools \
	libvulkan-dev \
	libvulkan1 \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir work
WORKDIR /work
