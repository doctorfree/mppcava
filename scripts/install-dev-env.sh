#!/bin/bash
#
# install-dev-env.sh - install or remove the build dependencies

arch=
centos=
debian=
fedora=
[ -f /etc/os-release ] && . /etc/os-release
[ "${ID_LIKE}" == "debian" ] && debian=1
[ "${ID}" == "arch" ] || [ "${ID_LIKE}" == "arch" ] && arch=1
[ "${ID}" == "centos" ] && centos=1
[ "${ID}" == "fedora" ] && fedora=1
[ "${debian}" ] || [ -f /etc/debian_version ] && debian=1
[ "${arch}" ] || [ "${debian}" ] || [ "${fedora}" ] || [ "${centos}" ] || {
  echo "${ID_LIKE}" | grep debian > /dev/null && debian=1
}

if [ "${debian}" ]
then
  PKGS="build-essential libfftw3-dev libasound2-dev libncursesw5-dev libpulse-dev \
        libtool automake autoconf-archive libiniparser-dev libsdl2-2.0-0 libsdl2-dev"
  if [ "$1" == "-r" ]
  then
    sudo apt remove ${PKGS}
  else
    sudo apt install ${PKGS} pandoc zip
  fi
else
  if [ "${arch}" ]
  then
    PKGS="base-devel fftw ncurses alsa-lib iniparser pulseaudio autoconf-archive"
    if [ "$1" == "-r" ]
    then
      sudo pacman -Rs ${PKGS}
    else
      sudo pacman -S --needed ${PKGS} pandoc zip
    fi
  else
    have_dnf=`type -p dnf`
    if [ "${have_dnf}" ]
    then
      PINS=dnf
    else
      PINS=yum
    fi
    sudo ${PINS} makecache
    if [ "${fedora}" ]
    then
      FEDVER=`rpm -E %fedora`
      FUSION="https://download1.rpmfusion.org"
      FREE="free/fedora"
      NONFREE="nonfree/fedora"
      RELRPM="rpmfusion-free-release-${FEDVER}.noarch.rpm"
      NONRPM="rpmfusion-nonfree-release-${FEDVER}.noarch.rpm"
      PKGS="alsa-lib-devel ncurses-devel fftw3-devel pulseaudio-libs-devel \
            portaudio-devel libtool autoconf-archive"
      if [ "$1" == "-r" ]
      then
        sudo ${PINS} -y remove ${PKGS}
        sudo ${PINS} -y remove gcc-c++
        sudo ${PINS} -y groupremove "Development Tools" "Development Libraries"
        sudo ${PINS} -y remove ${FUSION}/${NONFREE}/${NONRPM}
        sudo ${PINS} -y remove ${FUSION}/${FREE}/${RELRPM}
        sudo ${PINS} -y install dnf-plugins-core
        sudo ${PINS} config-manager --set-disabled rpmfusion-free
        sudo ${PINS} config-manager --set-disabled rpmfusion-free-updates
        sudo ${PINS} config-manager --set-disabled rpmfusion-nonfree-updates
        sudo ${PINS} config-manager --set-disabled rpmfusion-nonfree
        sudo ${PINS} config-manager --set-disabled rpmfusion-nonfree-nvidia-driver
        sudo ${PINS} config-manager --set-disabled rpmfusion-nonfree-steam
      else
        sudo ${PINS} -y groupinstall "Development Tools" "Development Libraries"
        sudo ${PINS} -y install gcc-c++
        sudo ${PINS} -y install ${PKGS} pandoc zip
        sudo ${PINS} -y install ${FUSION}/${FREE}/${RELRPM}
        sudo ${PINS} -y install ${FUSION}/${NONFREE}/${NONRPM}
        sudo ${PINS} -y install dnf-plugins-core
        sudo ${PINS} config-manager --set-enabled rpmfusion-free
        sudo ${PINS} config-manager --set-enabled rpmfusion-free-updates
        sudo ${PINS} config-manager --set-enabled rpmfusion-nonfree-updates
        sudo ${PINS} config-manager --set-enabled rpmfusion-nonfree
        sudo ${PINS} config-manager --set-enabled rpmfusion-nonfree-nvidia-driver
        sudo ${PINS} config-manager --set-enabled rpmfusion-nonfree-steam
        sudo ${PINS} -y update
      fi
    else
      if [ "${centos}" ]
      then
        sudo alternatives --set python /usr/bin/python3
        CENVER=`rpm -E %centos`
        FUSION="https://download1.rpmfusion.org"
        FREE="free/el"
        NONFREE="nonfree/el"
        RELRPM="rpmfusion-free-release-${CENVER}.noarch.rpm"
        NONRPM="rpmfusion-nonfree-release-${CENVER}.noarch.rpm"
        PKGS="alsa-lib-devel ncurses-devel fftw3-devel pulseaudio-libs-devel \
              portaudio-devel libtool autoconf-archive"
        if [ "$1" == "-r" ]
        then
          sudo ${PINS} -y remove ${PKGS}
          sudo ${PINS} -y remove gcc-c++
          sudo ${PINS} -y groupremove "Development Tools"
          sudo ${PINS} -y remove ${FUSION}/${NONFREE}/${NONRPM}
          sudo ${PINS} -y remove ${FUSION}/${FREE}/${RELRPM}
        else
          sudo ${PINS} -y groupinstall "Development Tools"
          sudo ${PINS} -y install gcc-c++
          sudo ${PINS} -y install dnf-plugins-core
          sudo ${PINS} -y install epel-release
          sudo ${PINS} config-manager --set-enabled powertools
          sudo ${PINS} -y install ${PKGS} pandoc zip
          sudo ${PINS} -y localinstall --nogpgcheck ${FUSION}/${FREE}/${RELRPM}
          sudo ${PINS} -y localinstall --nogpgcheck ${FUSION}/${NONFREE}/${NONRPM}
          sudo ${PINS} -y update
        fi
      else
        echo "Unrecognized operating system"
      fi
    fi
  fi
fi
