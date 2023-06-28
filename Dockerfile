# docker build -t dosemu2-build:latest . 
# docker run -it --rm dosemu2-build:latest /bin/bash

# copy debs out of container 
# docker run --rm -v $(pwd):/host dosemu2-build:latest /bin/bash -c "/host/copy.sh"

FROM ubuntu:latest
RUN apt-get update 
RUN apt install -y wget unzip
RUN wget https://github.com/dosemu2/dosemu2/archive/81bf77ce3c728bd8f1e206aac39b599f54ab0fe8.zip
RUN unzip 81bf77ce3c728bd8f1e206aac39b599f54ab0fe8.zip
RUN cd dosemu2-81bf77ce3c728bd8f1e206aac39b599f54ab0fe8
# fdpp-dev
RUN apt install -y build-essential devscripts  autoconf autotools-dev automake linuxdoc-tools bison debhelper
RUN apt install -y flex 
RUN apt install -y gawk 
RUN apt install -y libx11-dev 
RUN apt install -y libxext-dev 
RUN apt install -y libslang2-dev 
RUN apt install -y xfonts-utils 
RUN apt install -y libgpm-dev 
RUN apt install -y libasound2-dev 
RUN apt-get update 
RUN apt install -y libsdl2-dev 
RUN apt install -y libsdl2-ttf-dev libsdl2-image-dev libfontconfig1-dev ladspa-sdk libfluidsynth-dev libao-dev libieee1284-3-dev libslirp-dev 
RUN apt install -y libbsd-dev libreadline-dev libjson-c-dev binutils-dev pkg-config clang binutils-i686-linux-gnu

# fdpp
RUN apt install -y nasm  libelf-dev lld
RUN wget https://github.com/dosemu2/fdpp/archive/533a0ddd533298c4513f954853ca6da960373623.zip
RUN unzip 533a0ddd533298c4513f954853ca6da960373623.zip
RUN cd fdpp-533a0ddd533298c4513f954853ca6da960373623 && make deb
RUN dpkg -i fdpp_1.6-1_amd64.deb
RUN dpkg -i fdpp-dev_1.6-1_amd64.deb

RUN cd dosemu2-81bf77ce3c728bd8f1e206aac39b599f54ab0fe8 && make deb

# comcom32
RUN wget https://github.com/dosemu2/comcom32/archive/c290ebc96d90dca68985f1339b1c64bd0bedf7c5.zip
RUN unzip c290ebc96d90dca68985f1339b1c64bd0bedf7c5.zip

RUN apt-get install -y software-properties-common

# hopefully this is not a moving target
RUN add-apt-repository ppa:jwt27/djgpp-toolchain
RUN apt update -q
RUN apt install -y djgpp-dev gcc-djgpp

RUN cd comcom32-c290ebc96d90dca68985f1339b1c64bd0bedf7c5 && make deb
RUN dpkg -i comcom32_0.1~alpha3-1_all.deb

RUN dpkg -i dosemu2_2.0~pre9-1_amd64.deb
