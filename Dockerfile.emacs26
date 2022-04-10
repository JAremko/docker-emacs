FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf 

## update distro
RUN apt-get update && \
    apt-get upgrade

## build deps
RUN apt-get update && \
    apt-get install \
    		autotools-dev \
		bison \
		build-essential \
		clang \
		cmake \
		flex \
		git \
		gnulib \
		gperf \
		inotify-tools \
		libatspi2.0-dev \
		libbluetooth-dev \
		libclang-dev \
		libcups2-dev \
		libdrm-dev \
		libegl1-mesa-dev \
		libfontconfig1-dev \
		libfreetype6-dev \
		libgl-dev \
		libgstreamer1.0-dev \
		libhunspell-dev \
		libmirclient-dev \
		libmysqlclient-dev \
		libnss3-dev \
		libpulse-dev \
		libsctp-dev \
		libssl-dev \
		libts-dev \
		libwayland-dev \
		libwayland-egl-backend-dev \
		libwebp-dev \
		libx11-dev \
		libx11-xcb-dev \
		libxcb-ewmh-dev \
		libxcb-glx0-dev \
		libxcb-icccm4-dev \
		libxcb-image0-dev \
		libxcb-keysyms1-dev \
		libxcb-randr0-dev \
		libxcb-render-util0-dev \
		libxcb-shape0-dev \
		libxcb-shm0-dev \
		libxcb-sync-dev \
		libxcb-util-dev \
		libxcb-xfixes0-dev \
		libxcb-xinerama0-dev \
		libxcb-xkb-dev \
		libxcb1-dev \
		libxcomposite-dev \
		libxcursor-dev \ 
		libxdamage-dev \
		libxext-dev \
		libxfixes-dev \
		libxi-dev \
		libxkbcommon-dev \
		libxkbcommon-x11-dev \
		libxkbfile-dev \
		libxrandr-dev \
		libxrender-dev \
		libxshmfence-dev \
		libxshmfence1 \
		ninja-build \
		nodejs \
		qt5-default \
		qtwayland5 \
		software-properties-common \    
		wget

WORKDIR /tmp

#####################################
# install gcc 11
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get install gcc-11

# make gcc 11 default
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110
#####################################

## get cmake SDK
RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.0/cmake-3.23.0.tar.gz && \
    tar xf cmake-3.23.0.tar.gz
	
## configure cmake
RUN cd cmake-3.23.0 && ./configure

## build cmake
RUN cd cmake-3.23.0 &&  make

## install cmake
RUN cd cmake-3.23.0 &&  make install

#####################################
## get vulkan
RUN git clone https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers.git && \
    cp -r Vulkan-LoaderAndValidationLayers/include/vulkan /usr/include/ && \
    cd Vulkan-LoaderAndValidationLayers && \
    ./update_external_sources.sh

# build and install vulkan
RUN cd Vulkan-LoaderAndValidationLayers && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && \
    make && \
    make install

ENV VULKAN_HEADERS_INSTALL_DIR=/usr/local/vulkan-sdk/Vulkan-Headers/build/install

#####################################
## get llvm install script
RUN wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh

## install llvm
RUN ./llvm.sh 14 all
	
# make llvm clang default
RUN update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-14/bin/clang 140

# make llvm clang++ default
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-14/bin/clang++ 140

ENV CC=/usr/bin/clang \
    CXX=/usr/bin/clang++ \
    CXX_STANDARD=c++17 \
    CPLUS_INCLUDE_PATH=/usr/lib/llvm-14/include/c++/v1 \
    LIBRARY_PATH=/usr/lib/llvm-14/lib \
    LLVM_LIB_SEARCH_PATH=/usr/lib/llvm-14/lib \
    CXXFLAGS="-std=c++17 -stdlib=libc++ -DCMAKE_CXX_STANDARD=17" \
    PATH=$PATH:/usr/lib/llvm-14/bin

#####################################
## install vulkan hpp
## RUN git clone --depth=1 --recurse-submodules https://github.com/KhronosGroup/Vulkan-Hpp.git
## TODO

#####################################
## get qt
RUN wget https://download.qt.io/official_releases/qt/6.2/6.2.4/single/qt-everywhere-src-6.2.4.tar.xz && \
    tar xf qt-everywhere-src-6.2.4.tar.xz

## configure qt
RUN cd /tmp/qt-everywhere-src-6.2.4 && \
    ./configure -prefix /usr/local/Qt6 \
                -skip qtwebengine \
                -c++std c++17 \
                -inotify \
                -feature-vulkan \
                -sctp \
                -eventfd

## build qt
RUN cd /tmp/qt-everywhere-src-6.2.4 && cmake --build . --parallel

#####################################
## configure qt modules
RUN cd /tmp/qt-everywhere-src-6.2.4 && ./usr/local/Qt6/bin/qt-configure-module
