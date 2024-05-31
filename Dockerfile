# 베이스 이미지로 Ubuntu 18.04 사용
FROM ubuntu:18.04

# 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive

# 필수 패키지 설치
RUN apt update && apt install -y \
    software-properties-common \
    python3-pip \
    gcc-7 \
    g++-7 \
    cmake \
    libtool \
    autoconf \
    libboost-filesystem-dev \
    libboost-iostreams-dev \
    libboost-serialization-dev \
    libboost-thread-dev \
    libboost-test-dev \
    libssl-dev \
    libjsoncpp-dev \
    libcurl4-openssl-dev \
    libjsonrpccpp-dev \
    libsnappy-dev \
    zlib1g-dev \
    libbz2-dev \
    liblz4-dev \
    libzstd-dev \
    libjemalloc-dev \
    libsparsehash-dev \
    python3-dev \
    git && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt update && \
    apt install -y gcc-7 g++-7 && \
    rm -rf /var/lib/apt/lists/*

# BlockSci 설치
RUN git clone https://github.com/citp/BlockSci.git /BlockSci && \
    cd /BlockSci && \
    mkdir release && \
    cd release && \
    CC=gcc-7 CXX=g++-7 cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install

# BlockSci Python 패키지 설치
RUN cd /BlockSci && \
    CC=gcc-7 CXX=g++-7 pip3 install -e blockscipy

# 시간대를 UTC로 설정
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# 오픈 파일 제한 설정
RUN echo "fs.file-max = 64000" >> /etc/sysctl.conf && \
    echo "* soft nofile 64000" >> /etc/security/limits.conf && \
    echo "* hard nofile 64000" >> /etc/security/limits.conf

# 기본 명령어
CMD ["bash"]
