Name: mppcava
Version:    %{_version}
Release:    %{_release}%{?dist}
BuildArch:  x86_64
BuildRequires:  autoconf-archive
BuildRequires:  alsa-lib-devel
BuildRequires:  fftw3-devel
BuildRequires:  pulseaudio-libs-devel
BuildRequires:  libtool
BuildRequires:  ncurses-devel
BuildRequires:  iniparser-devel
BuildRequires:  make
URL:        https://github.com/doctorfree/mppcava
Vendor:     Doctorwhen's Bodacious Laboratory
Packager:   ronaldrecord@gmail.com
License:    MIT
Summary:    Console-based Audio Spectrum Visualizer

%global __os_install_post %{nil}

%description
Mppcava is a bar spectrum analyzer for audio

%prep

%build

%install
cp -a %{_sourcedir}/usr %{buildroot}/usr

%pre

%post

%preun

%files
/usr
%exclude %dir /usr/share/man/man1
%exclude %dir /usr/share/man
%exclude %dir /usr/share/doc
%exclude %dir /usr/share
%exclude %dir /usr/bin

%changelog

