# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )
DISTUTILS_OPTIONAL="1"

inherit cmake-utils distutils-r1 java-pkg-2 java-pkg-simple

DESCRIPTION="General-purpose lossless compression algorithm"
HOMEPAGE="https://github.com/google/brotli"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="java python test"

CDEPEND="dev-java/junit:4
	python? ( ${PYTHON_DEPS} )"

DEPEND="${CDEPEND}
	java? ( >=virtual/jdk-1.6 )"

RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.6 )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

LICENSE="MIT python? ( Apache-2.0 )"

S="${WORKDIR}/${P}"

#JAVA_SRC_DIR="java/org/brotli"
JAVA_GENTOO_CLASSPATH="junit-4"

DOCS=( README.md CONTRIBUTING.md )

PATCHES=( "${FILESDIR}"/${P}-no-rpath.patch )

pkg_setup() {
	use java && java-pkg-2_pkg_setup
}

src_prepare() {
#	find "${S}"/java -name "pom.xml" -delete || die
	cmake-utils_src_prepare
	use python && distutils-r1_src_prepare
	use java && java-pkg-2_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING="$(usex test)"
	)
	cmake-utils_src_configure
	use python && distutils-r1_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use python && distutils-r1_src_compile
	if use java ; then
		cd "${S}"/java/org/brotli/dec
		JAVA_JAR_FILENAME="${S}/${PN}.jar" \
			JAVA_PKG_IUSE="doc" \
			java-pkg-simple_src_compile
	fi
}

python_test(){
	esetup.py test || die
}

src_test() {
	cmake-utils_src_test
	use python && distutils-r1_src_test
}

src_install() {
	cmake-utils_src_install
	use python && distutils-r1_src_install

	if use java ; then
		java-pkg_dojar ${PN}.jar
	fi
}
