#!/bin/bash
#================================================================================================
#
# This file is licensed under the terms of the GNU General Public
# License version 2. This program is licensed "as is" without any
# warranty of any kind, whether express or implied.
#
# This file is a part of the OpenWrt Docker Image Builder
# https://github.com/ophub/amlogic-s9xxx-openwrt
#
# Description: Create a Docker image from an OpenWrt rootfs archive
# Copyright (C) 2021~ https://github.com/unifreq/openwrt_packit
# Copyright (C) 2021~ https://github.com/ophub/amlogic-s9xxx-openwrt
#
# Command: ./config/docker/make_docker_image.sh
#
#======================================== Functions list ========================================
#
# error_msg         : Output error message
# check_depends     : Check dependencies
# check_docker      : Check and install Docker environment
# find_openwrt      : Locate the OpenWrt rootfs archive (openwrt/*rootfs.tar.gz)
# adjust_settings   : Adjust rootfs configuration for Docker
# make_dockerimg    : Build and package the Docker image
# export_docker     : Export offline Docker image
#
#================================ Set make environment variables ================================
#
# Set default parameters
current_path="${PWD}"
openwrt_path="${current_path}/openwrt"
openwrt_rootfs_file="*rootfs.tar.gz"
docker_rootfs_file="openwrt-docker-armsr-armv8-default-rootfs.tar.gz"
docker_path="${current_path}/config/docker"
make_path="${current_path}/make-openwrt"
common_files="${make_path}/openwrt-files/common-files"
tmp_path="${current_path}/tmp"
out_path="${current_path}/out"
# Set Docker image name and tag
[[ -n "${1}" ]] && docker_os="${1}" || docker_os="diy"
[[ -n "${2}" ]] && docker_arch="${2}" || docker_arch="arm64"

# Set default parameters
STEPS="[\033[95m STEPS \033[0m]"
INFO="[\033[94m INFO \033[0m]"
SUCCESS="[\033[92m SUCCESS \033[0m]"
WARNING="[\033[93m WARNING \033[0m]"
ERROR="[\033[91m ERROR \033[0m]"
#
#================================================================================================

error_msg() {
    echo -e "${ERROR} ${1}"
    exit 1
}

check_depends() {
    # Check the required dependencies
    is_dpkg="0"
    dpkg_packages=("tar" "gzip")
    i="1"
    for package in ${dpkg_packages[*]}; do
        [[ -n "$(dpkg -l | awk '{print $2}' | grep -w "^${package}$" 2>/dev/null)" ]] || is_dpkg="1"
        let i++
    done

    # Install missing packages
    if [[ "${is_dpkg}" -eq "1" ]]; then
        echo -e "${STEPS} Installing required dependencies..."
        sudo apt-get update
        sudo apt-get install -y ${dpkg_packages[*]}
        [[ "${?}" -ne "0" ]] && error_msg "Failed to install required dependencies."
    fi
}

check_docker() {
    echo -e "${STEPS} Checking Docker environment..."

    # Check if docker command exists
    if command -v docker >/dev/null 2>&1; then
        local docker_ver="$(docker --version 2>/dev/null)"
        echo -e "${INFO} Docker is installed: [ ${docker_ver} ]"

        # Check if Docker daemon is running
        if docker info >/dev/null 2>&1; then
            echo -e "${INFO} Docker daemon is running."
        else
            echo -e "${WARNING} Docker daemon is not running, attempting to start..."
            sudo systemctl start docker 2>/dev/null || sudo service docker start 2>/dev/null
            sleep 3
            docker info >/dev/null 2>&1 || error_msg "Failed to start Docker daemon."
            echo -e "${SUCCESS} Docker daemon started successfully."
        fi
        return 0
    fi

    echo -e "${INFO} Docker is not installed, installing..."
    # Install Docker using the official convenience script
    curl -fsSL https://get.docker.com | sudo sh
    sudo usermod -aG docker ${USER}

    # Verify installation
    command -v docker >/dev/null 2>&1 || error_msg "Docker installation failed."

    # Start and enable Docker service
    sudo systemctl start docker 2>/dev/null || sudo service docker start 2>/dev/null
    sudo systemctl enable docker 2>/dev/null
    sleep 3
    docker info >/dev/null 2>&1 || error_msg "Docker installed but daemon failed to start."

    echo -e "${SUCCESS} Docker installed and started successfully: [ $(docker --version) ]"
}

find_openwrt() {
    cd ${current_path}
    echo -e "${STEPS} Searching for OpenWrt rootfs file..."

    # Find whether the OpenWrt file exists
    openwrt_file_name="$(ls ${openwrt_path}/${openwrt_rootfs_file} 2>/dev/null | head -n 1 | awk -F "/" '{print $NF}')"
    if [[ -n "${openwrt_file_name}" ]]; then
        echo -e "${INFO} Found OpenWrt rootfs file: [ ${openwrt_file_name} ]"
    else
        error_msg "No [ ${openwrt_rootfs_file} ] file found in the [ ${openwrt_path} ] directory."
    fi

    # Check whether the Dockerfile exists
    [[ -f "${docker_path}/Dockerfile" ]] || error_msg "Required Dockerfile is missing."
}

adjust_settings() {
    cd ${current_path}
    echo -e "${STEPS} Adjusting OpenWrt rootfs settings..."

    echo -e "${INFO} Unpacking OpenWrt rootfs..."
    rm -rf ${tmp_path} && mkdir -p ${tmp_path}
    tar -xzf ${openwrt_path}/${openwrt_file_name} -C ${tmp_path}

    # Remove unused files
    echo -e "${INFO} Removing unnecessary files..."
    rm -rf ${tmp_path}/lib/firmware/*
    rm -rf ${tmp_path}/lib/modules/*
    rm -f ${tmp_path}/root/.todo_rootfs_resize
    find ${tmp_path} -name '*.rej' -exec rm {} \;
    find ${tmp_path} -name '*.orig' -exec rm {} \;
    # Remove Amlogic Service
    rm -f ${tmp_path}/usr/lib/lua/luci/controller/amlogic.lua
    rm -rf ${tmp_path}/usr/lib/lua/luci/model/cbi/amlogic
    rm -rf ${tmp_path}/usr/share/amlogic
    rm -f ${tmp_path}/usr/sbin/openwrt-*-*
    rm -f ${tmp_path}/etc/init.d/amlogic
    # Remove docker Service
    rm -f ${tmp_path}/usr/lib/lua/luci/controller/docker*
    rm -rf ${tmp_path}/usr/lib/lua/luci/model/cbi/docker*
    rm -f ${tmp_path}/usr/lib/lua/luci/model/docker*
    rm -f ${tmp_path}/usr/bin/docker*
    rm -f ${tmp_path}/etc/init.d/docker*

    # Turn off hw_flow by default
    [[ -f "${tmp_path}/etc/config/turboacc" ]] && {
        echo -e "${INFO} Adjusting TurboACC settings."
        sed -i "s|option hw_flow.*|option hw_flow '0'|g" ${tmp_path}/etc/config/turboacc
        sed -i "s|option sw_flow.*|option sw_flow '0'|g" ${tmp_path}/etc/config/turboacc
    }

    # Modify the cpu mode to schedutil
    [[ -f "${tmp_path}/etc/config/cpufreq" ]] && {
        echo -e "${INFO} Adjusting CPU frequency settings."
        sed -i "s/ondemand/schedutil/g" ${tmp_path}/etc/config/cpufreq
    }

    # Disable the OpenSSL acceleration engine
    [[ -f "${tmp_path}/etc/ssl/openssl.cnf" ]] && {
        sed -i "s|^engines = engines_sect|#engines = engines_sect|g" ${tmp_path}/etc/ssl/openssl.cnf
    }

    # Turn off speed limit by default
    [[ -f "${tmp_path}/etc/config/nft-qos" ]] && {
        sed -i "s|option limit_enable.*|option limit_enable '0'|g" ${tmp_path}/etc/config/nft-qos
    }

    # Relink the kmod program
    [[ -f "${common_files}/sbin/kmod" ]] && (
        echo -e "${INFO} Adjusting kernel module links."
        cp -f ${common_files}/sbin/kmod ${tmp_path}/sbin/kmod
        chmod +x ${tmp_path}/sbin/kmod
        kmod_list="depmod insmod lsmod modinfo modprobe rmmod"
        for ki in ${kmod_list}; do
            rm -f ${tmp_path}/sbin/${ki}
            ln -sf kmod ${tmp_path}/sbin/${ki}
        done
    )

    # Add version information to the banner
    [[ -f "${common_files}/etc/banner" ]] && {
        cp -f ${common_files}/etc/banner ${tmp_path}/etc/banner
        echo -e "${INFO} Updating system banner."
        echo " Board: docker | Production Date: $(date +%Y-%m-%d)" >>${tmp_path}/etc/banner
        echo "───────────────────────────────────────────────────────────────────────" >>${tmp_path}/etc/banner
    }
}

make_dockerimg() {
    cd ${tmp_path}
    echo -e "${STEPS} Building Docker image..."

    # Make docker image
    tar -czf ${docker_rootfs_file} *
    [[ "${?}" -eq "0" ]] || error_msg "Docker rootfs archive creation failed."

    # Move the docker image to the output directory
    rm -rf ${out_path} && mkdir -p ${out_path}
    mv -f ${docker_rootfs_file} ${out_path}
    [[ "${?}" -eq "0" ]] || error_msg "Failed to move Docker image to output directory."
    echo -e "${INFO} Docker rootfs archived successfully."

    cd ${current_path}

    # Add Dockerfile
    cp -f ${docker_path}/Dockerfile ${out_path}
    [[ "${?}" -eq "0" ]] || error_msg "Failed to add Dockerfile."
    echo -e "${INFO} Dockerfile added successfully."

    # Remove temporary directory
    rm -rf ${tmp_path}

    sync && sleep 3
    echo -e "${INFO} Docker output files: \n$(ls -lh ${out_path})"
    echo -e "${SUCCESS} Docker image created successfully."
}

export_docker() {
    cd ${current_path}

    echo -e "${STEPS} Building and exporting offline Docker image..."

    # Set image name and tag (Docker requires lowercase image names)
    local docker_image_name="openwrt-docker-${docker_os}-${docker_arch}"
    local full_image="${docker_image_name}:${docker_arch}"

    # Build docker image locally
    cd ${out_path}
    docker build --platform linux/${docker_arch} -t "${full_image}" .
    [[ "${?}" -eq "0" ]] || error_msg "Docker image build failed."
    echo -e "${INFO} Docker image [ ${full_image} ] built successfully."

    # Clean up build artifacts, keep only the exported image
    rm -f ${out_path}/{${docker_rootfs_file},Dockerfile}

    # Export image to tar.gz file
    local export_file="${out_path}/${docker_image_name}.tar.gz"
    (set -o pipefail && docker save "${full_image}" | gzip >"${export_file}")
    [[ "${?}" -eq "0" ]] || error_msg "Docker image export failed."

    # Display export info
    local file_size="$(ls -lh ${export_file} | awk '{print $5}')"
    echo -e "${SUCCESS} Offline Docker image exported: [ ${export_file} ] (${file_size})"
    echo -e "${INFO} Users can import with: [ docker load -i $(basename ${export_file}) ]"
}

# Show welcome message
echo -e "${STEPS} Welcome to the Docker Image Builder."
echo -e "${INFO} Working directory: [ ${PWD} ]"
#
check_depends
check_docker
find_openwrt
adjust_settings
make_dockerimg
export_docker
