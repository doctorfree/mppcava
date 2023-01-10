#!/bin/bash
PKG="mppcava"
SRC_NAME="mppcava"
PKG_NAME="mppcava"
DESTDIR="usr"
SUDO=sudo
GCI=

if [ "${__MPP_SRC__}" ]
then
  SRC="${__MPP_SRC__}"
else
  SRC="${HOME}/src/${SRC_NAME}"
fi

[ -f "${SRC}/VERSION" ] || {
  [ -f "/builds/doctorfree/${SRC_NAME}/VERSION" ] || {
    echo "$SRC/VERSION does not exist. Exiting."
    exit 1
  }
  SRC="/builds/doctorfree"
  SUDO=
  GCI=1
}

. "${SRC}/VERSION"
PKG_VER=${VERSION}
PKG_REL=${RELEASE}

umask 0022

# Subdirectory in which to create the distribution files
OUT_DIR="dist/${PKG_NAME}_${PKG_VER}"

[ -d "${SRC}" ] || {
    echo "$SRC does not exist or is not a directory. Exiting."
    exit 1
}

cd "${SRC}"

# Build mppcava
if [ -x scripts/build-mppcava.sh ]
then
  scripts/build-mppcava.sh
else
  make clean
  make distclean
  [ -x ./configure ] || ./autogen.sh > /dev/null
  ./configure --prefix=/usr > configure$$.out
  make > make$$.out
fi

${SUDO} rm -rf dist
mkdir dist

[ -d ${OUT_DIR} ] && rm -rf ${OUT_DIR}
mkdir ${OUT_DIR}

for dir in "${DESTDIR}" "${DESTDIR}/share" "${DESTDIR}/share/man" \
           "${DESTDIR}/share/doc" "${DESTDIR}/share/consolefonts" \
           "${DESTDIR}/share/doc/${PKG}" "${DESTDIR}/share/${PKG}"
do
    [ -d ${OUT_DIR}/${dir} ] || ${SUDO} mkdir ${OUT_DIR}/${dir}
    ${SUDO} chown root:root ${OUT_DIR}/${dir}
done

[ -d ${OUT_DIR}/${DESTDIR}/bin ] && ${SUDO} rm -rf ${OUT_DIR}/${DESTDIR}/bin
${SUDO} mkdir -p ${OUT_DIR}/${DESTDIR}/bin

${SUDO} cp mppcava ${OUT_DIR}/${DESTDIR}/bin/mppcava
${SUDO} cp mppcava.psf ${OUT_DIR}/${DESTDIR}/share/consolefonts

${SUDO} cp copyright ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp LICENSE ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp CHANGELOG.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} gzip -9 ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/CHANGELOG.md

${SUDO} cp example_files/config ${OUT_DIR}/${DESTDIR}/share/${PKG}/config
${SUDO} cp example_files/template-config ${OUT_DIR}/${DESTDIR}/share/${PKG}/template.conf

${SUDO} cp -a man/man1 ${OUT_DIR}/${DESTDIR}/share/man/man1

${SUDO} chmod 644 ${OUT_DIR}/${DESTDIR}/share/man/*/*
${SUDO} chmod 755 ${OUT_DIR}/${DESTDIR}/bin/* \
                  ${OUT_DIR}/${DESTDIR}/bin \
                  ${OUT_DIR}/${DESTDIR}/share/man \
                  ${OUT_DIR}/${DESTDIR}/share/man/*
${SUDO} chown -R root:root ${OUT_DIR}/${DESTDIR}

echo "Building ${PKG_NAME}_${PKG_VER} rpm package"

[ -d pkg/rpm ] && cp -a pkg/rpm ${OUT_DIR}/rpm
[ -d ${OUT_DIR}/rpm ] || mkdir ${OUT_DIR}/rpm

have_rpm=`type -p rpmbuild`
[ "${have_rpm}" ] || {
  have_yum=`type -p yum`
  if [ "${have_yum}" ]
  then
    ${SUDO} yum -y install rpm-build
  else
    ${SUDO} apt-get update
    export DEBIAN_FRONTEND=noninteractive
    ${SUDO} ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
    ${SUDO} apt-get install rpm -y
    ${SUDO} dpkg-reconfigure --frontend noninteractive tzdata
  fi
}

rpmbuild -ba --build-in-place \
   --define "_topdir ${OUT_DIR}" \
   --define "_sourcedir ${OUT_DIR}" \
   --define "_version ${PKG_VER}" \
   --define "_release ${PKG_REL}" \
   --buildroot ${SRC}/${OUT_DIR}/BUILDROOT \
   ${OUT_DIR}/rpm/${PKG_NAME}.spec

# Rename RPMs if necessary
for rpmfile in ${OUT_DIR}/RPMS/*/*.rpm
do
  [ "${rpmfile}" == "${OUT_DIR}/RPMS/*/*.rpm" ] && continue
  rpmbas=`basename ${rpmfile}`
  rpmdir=`dirname ${rpmfile}`
  newnam=`echo ${rpmbas} | sed -e "s/${PKG_NAME}-${PKG_VER}-${PKG_REL}/${PKG_NAME}_${PKG_VER}-${PKG_REL}/"`
  [ "${rpmbas}" == "${newnam}" ] && continue
  mv ${rpmdir}/${rpmbas} ${rpmdir}/${newnam}
done

${SUDO} cp ${OUT_DIR}/RPMS/*/*.rpm dist

[ "${GCI}" ] || {
    [ -d releases ] || mkdir releases
    [ -d releases/${PKG_VER} ] || mkdir releases/${PKG_VER}
    ${SUDO} cp ${OUT_DIR}/RPMS/*/*.rpm releases/${PKG_VER}
}
