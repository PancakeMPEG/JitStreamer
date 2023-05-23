#!/bin/sh
# Ubuntu Shell
BLUE=$(tput setaf 4)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NC=$(tput sgr0) 


echo "${BLUE}[*] Make Directory for JitStreamer${NC}"
mkdir -p ./JitStreamer ./DMG 
echo "${BLUE}[*] Updating Sources${NC}"
sudo apt-get update 
echo "${BLUE}[*] Installing Dependencies (APT)${NC}"
sudo apt-get install -y \
    udev \
    libudev1 \
    libudev-dev \
    libssl-dev \
    python3-dev \
    build-essential \
    pkg-config \
    checkinstall \
    git autoconf \
    automake \
    libtool-bin \
    curl 
echo "${BLUE}[*] Installing Dependencies (RUST)${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
&& . "$HOME/.cargo/env" 
echo "${BLUE}[*] Cloning GitHub Projects (libusb)${NC}"
git clone https://github.com/libusb/libusb ./build/libusb 
cd ./build/libusb && git checkout cc498de \
&& ./autogen.sh && sudo make install 
cd ../../
echo "${BLUE}[*] Cloning GitHub Projects (libplist)${NC}"
git clone https://github.com/libimobiledevice/libplist ./build/libplist 
cd ./build/libplist && git checkout bfc9778 \
&& ./autogen.sh && sudo make install 
cd ../../
echo "${BLUE}[*] Cloning GitHub Projects (libimobiledevice-glue)${NC}"
git clone https://github.com/libimobiledevice/libimobiledevice-glue ./build/libimobiledevice-glue 
cd ./build/libimobiledevice-glue && git checkout d2ff796 \
&& ./autogen.sh && sudo make install 
cd ../../
echo "${BLUE}[*] Cloning GitHub Projects (libusbmuxd)${NC}"
git clone https://github.com/libimobiledevice/libusbmuxd ./build/libusbmuxd 
cd ./build/libusbmuxd && git checkout f47c36f \
&& ./autogen.sh && sudo make install 
cd ../../
echo "${BLUE}[*] Cloning GitHub Projects (libimobiledevice)${NC}"
git clone https://github.com/libimobiledevice/libimobiledevice ./build/libimobiledevice 
cd ./build/libimobiledevice && git checkout 963083b \
&& ./autogen.sh && sudo make install 
cd ../../
echo "${BLUE}[*] Cloning GitHub Projects (usbmuxd)${NC}"
git clone https://github.com/libimobiledevice/usbmuxd ./build/usbmuxd 
cd ./build/usbmuxd && git checkout d0cda19 \
&& ./autogen.sh && sudo make install 
cd ../../
echo "${BLUE}[*] Cloning GitHub Projects (JitStreamer)${NC}"
git clone https://github.com/jkcoxson/JitStreamer/ ./build/JitStreamer 
cd ./build/JitStreamer && git checkout c2fda05 
echo "${BLUE}[*] Building JitStreamer${NC}"
sed -i 's/,\?\s*"vendored"//g' Cargo.toml \
&& cargo build --release \
&& echo "${BLUE}[*] Move JitStreamer Binary${NC}" \
&& mv ./target/release/jit_streamer ../../JitStreamer \
&& echo "${BLUE}[*] Cleaning Build Cache${NC}" \
&& cd ../../
echo "${RED}Are you sure you want to delete build file? ${NC}(y/n)"
read answer

if [ "$answer" = "y" ]; then
    sudo rm -r ./build
    echo "Deleted successfully."
else
    echo "Deletion cancelled."
fi

echo "${GREEN}Build Finished. Check ./JitStreamer Directory for binary.${NC}"
