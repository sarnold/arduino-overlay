# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

DESCRIPTION="Apache MyFaces API - Core package"
HOMEPAGE="https://github.com/scream3r/java-simple-serial-connector"
SRC_URI="https://github.com/scream3r/java-simple-serial-connector/archive/${PV}.zip"
LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	app-arch/unzip"

S="${WORKDIR}/java-simple-serial-connector-${PV}"

src_prepare() {
	epatch "${FILESDIR}/jssc-2.8.0-library-load.patch"
}

src_compile() {
	CXX=${CHOST}-g++
	"${CXX}" -c -o jscc.o -fPIC -Wall ${CPP_FLAGS} ${CXX_FLAGS} -I$(java-config-2 -o)/include -I$(java-config-2 -o)/include/linux "${S}"/src/cpp/_nix_based/jssc.cpp || die
	"${CXX}" -Wl,-soname,libjssc.so -shared -o libjssc.so.${PV} -Wall jscc.o || die

	cd "${S}"/src/java || die
	JAVAC=$(java-config-2 -c)
	${JAVAC} jssc/*.java || die

	JAR=$(java-config-2 -j)
	${JAR} cvf jssc.jar jssc/*.class || die
}

src_install() {
	dolib libjssc*
	dosym libjssc.so.${PV} /usr/$(get_libdir)/libjssc.so
	java-pkg_dojar src/java/*.jar

	if use doc; then
		dodoc revisions.txt "${S}"/README.md
	fi
}
