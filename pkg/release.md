# Release Notes for mppcava

Mppcava is a bar spectrum audio visualizer for terminal (ncurses) or desktop (SDL).

Mppcava works on:

* Linux
* FreeBSD
* macOS
* Windows

This program is not intended for scientific use. It's written to look responsive and aesthetic when used to visualize music.

## Installation

The `mppcava` package is installed during [MusicPlayerPlus](https://github.com/doctorfree/MusicPlayerPlus) initialization with the `mppinit` command. The `mppcava` package can be installed separately from `MusicPlayerPlus` and will be recognized if `MusicPlayerPlus` is subsequently installed. To install `mppcava` separately from `MusicPlayerPlus` follow these steps.

Download the [latest Debian, Arch, or RPM package format release](https://github.com/doctorfree/mppcava/releases) for your platform.

Install the package on Debian based systems by executing the command:

```bash
sudo apt install ./mppcava_1.0.1-1.amd64.deb
```

or, on a Raspberry Pi:

```bash
sudo apt install ./mppcava_1.0.1-1.armhf.deb
```

Install the package on Arch Linux based systems by executing the command:

```bash
sudo pacman -U ./mppcava-v1.0.1r1-1-x86_64.pkg.tar.zst
```

Install the package on RPM based systems by executing one of the following commands.

On Fedora Linux:

```bash
sudo yum localinstall ./mppcava_1.0.1-1.fc36.x86_64.rpm
```

On CentOS Linux:

```bash
sudo yum localinstall ./mppcava_1.0.1-1.el8.x86_64.rpm
```

### PKGBUILD Installation

To install on a Raspberry Pi running Arch Linux, mppcava must be built from sources using the Arch PKGBUILD files provided in `mppcava-pkgbuild-1.0.1-1.tar.gz`. This process can be performed on any `x86_64` or `armv7h ` architecture system running Arch Linux. An `x86_64` architecture precompiled package is supplied (see above). To rebuild this package from sources, extract `mppcava-pkgbuild-1.0.1-1.tar.gz` and use the `makepkg` command to download the sources, build the binaries, and create the installation package:

```
tar xzf mppcava-pkgbuild-1.0.1-1.tar.gz
cd mppcava
makepkg --force --log --cleanbuild --noconfirm --syncdeps
```

## Configuration

The `mppcava` default configuration file is located in `$HOME/.config/mppcava/config`.

See the [mppcava README](https://github.com/doctorfree/mppcava#readme) for additional configuration info.

## Removal

Removal of the package on Debian based systems can be accomplished by issuing the command:

```bash
sudo apt remove mppcava
```

Removal of the package on RPM based systems can be accomplished by issuing the command:

```bash
sudo yum remove mppcava
```

Removal of the package on Arch Linux based systems can be accomplished by issuing the command:

```bash
sudo pacman -Rs mppcava
```

## Building mppcava from source

mppcava can be compiled, packaged, and installed from the source code repository. This should be done as a normal user with `sudo` privileges:

```
# Retrieve the source code from the repository
git clone https://github.com/doctorfree/mppcava.git
# Enter the mppcava source directory
cd mppcava
# Install the necessary build environment (not necessary on Arch Linux)
scripts/install-dev-env.sh
# Compile mppcava and create an installation package
./mkpkg
# Install mppcava and its dependencies
./Install
```

The `mkpkg` script detects the platform and creates an installable package in the package format native to that platform. After successfully building mppcava, the resulting installable package will be found in the `./releases/<version>/` directory.

## Changelog

View the full changelog for this release at https://github.com/doctorfree/mppcava/blob/v1.0.1r1/CHANGELOG.md

See [CHANGELOG.md](https://github.com/doctorfree/mppcava/blob/master/CHANGELOG.md) for a full list of changes in every mppcava release
