# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
JAVA_PKG_IUSE="doc"

inherit eutils gnome2 java-pkg-2 java-ant-2

DESCRIPTION="An open-source AVR electronics prototyping platform"
HOMEPAGE="http://arduino.cc/"
SRC_URI="https://github.com/arduino/Arduino/archive/${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip binchecks"

PATCHES=(
	"${FILESDIR}/${P}"-startup.patch
	"${FILESDIR}/${P}"-platform.patch
)

# Todo: Remaining bundled libs:
#   commons-exec
#   jackson-module-mrbean
#   java-semver
#   rsyntaxtextarea-arduino

COMMONDEP="
	dev-java/batik:1.8
	dev-java/bcpg:1.58
	dev-java/bcprov:1.58
	dev-java/commons-codec:0
	dev-java/commons-compress:0
	dev-java/commons-httpclient:3
	dev-java/commons-lang:3.3
	dev-java/commons-logging:0
	>=dev-java/commons-net-3.2:0
	dev-java/jackson:2
	dev-java/jackson-annotations:2
	dev-java/jackson-databind:2
	dev-java/jackson-modules-base:2
	dev-java/jmdns:0
	dev-java/jna:0
	dev-java/jsch:0
	>=dev-java/jssc-2.8.0-r1:0
	dev-java/slf4j-simple
	dev-java/xml-commons-external:1.3
	dev-java/xmlgraphics-commons:2
	<dev-util/astyle-3[java]
	dev-embedded/listserialportsc"

RDEPEND="${COMMONDEP}
	>=virtual/jre-1.8
	dev-embedded/arduino-builder
	dev-embedded/avrdude
	dev-embedded/uisp"

DEPEND="${COMMONDEP}
	>=virtual/jdk-1.8"

EANT_GENTOO_CLASSPATH="batik-1.8,bcpg-1.52,bcprov-1.52,commons-codec,commons-compress,commons-httpclient-3,commons-lang-3.3,commons-logging,commons-net,jackson-2,jackson-annotations-2,jackson-databind-2,jackson-modules-base-2,jmdns,jna,jsch,jssc,xml-commons-external-1.3,xmlgraphics-commons-2"
EANT_EXTRA_ARGS="-Djava.net.preferIPv4Stack=true"
EANT_BUILD_TARGET="build"
JAVA_ANT_REWRITE_CLASSPATH="yes"

S="${WORKDIR}/Arduino-${PV}"
CORE="/usr/share/arduino"
SHARE="/usr/share/${PN}"

src_prepare() {
	# Remove bundled libraries to ensure the system libraries are used
	# Elegant, but breaks the build :(
	#rm -f {arduino-core,app}/lib/{apple*,batik*,bcpg*,bcprov*,commons-[^e]*,jackson-*,jmdns*,jna*,jsch*,jssc*,xmlgraphics*} || die

	default

}

src_compile() {
	eant -f build/build.xml -Dlight_bundle=1 -Dno_docs=1 -Dno_arduino_builder=1 -Dplatform=linux64
}

src_install() {
	insinto "${SHARE}"
	doins -r hardware

	# Use system arduino-builder
	dosym /usr/bin/arduino-builder "${SHARE}/arduino-builder"
	dosym /usr/share/arduino-builder/platform.keys.rewrite.txt "${SHARE}/hardware/platform.keys.rewrite.txt"
	dosym /usr/share/arduino-builder/platform.txt "${SHARE}/hardware/platform.txt"

	# hardware/tools/avr needs to exist or arduino-builder will
	# complain about missing required -tools arg
	dodir "${SHARE}/hardware/tools/avr"

	cd "${S}"/build/linux/work || die
	rm -v lib/{apple*,batik*,bcpg*,bcprov*,commons-[^e]*,jackson*,jmdns*,jna*,jsch*,jssc*,slf4j*,xml*}
	rm -v lib/*.so
	doins -r lib examples

	java-pkg_dojar lib/*.jar
	java-pkg_dolauncher ${PN} \
			    --pwd "${CORE}" \
			    --main "processing.app.Base" \
			    --java_args "-DAPP_DIR=/usr/share/${PN} -DCORE_DIR=${CORE} -splash:/usr/share/${PN}/lib/splash.png"

	if use doc; then
		dodoc revisions.txt "${S}"/README.md
		dohtml -r reference
	fi

	dodir "/usr/share/${PN}/hardware/tools/avr/bin/"
	if [[ -e /usr/bin/avr-gcc ]] ; then
		dosym /usr/bin/avr-g++ "/usr/share/${PN}/hardware/tools/avr/bin/avr-g++"
		dosym /usr/bin/avr-gcc "/usr/share/${PN}/hardware/tools/avr/bin/avr-gcc"
		dosym /usr/bin/avr-ar "/usr/share/${PN}/hardware/tools/avr/bin/avr-ar"
		dosym /usr/bin/avr-objcopy "/usr/share/${PN}/hardware/tools/avr/bin/avr-objcopy"
		dosym /usr/bin/avr-size "/usr/share/${PN}/hardware/tools/avr/bin/avr-size"
	else
		ewarn "missing /usr/bin/avr-gcc means no symlinks can be created"
		ewarn "under /usr/share/${PN}/hardware/tools/avr/bin/ for you."
		ewarn "Use crossdev to build an avr toolchain and then re-emerge"
		ewarn "this package (or else make the symlinks manually)."
	fi

	# Install menu and icons
	domenu "${FILESDIR}/${PN}.desktop"
	for sz in `ls lib/icons | sed -e 's/\([0-9]*\)x[0-9]*/\1/'`; do
		newicon -s $sz \
			"lib/icons/${sz}x${sz}/apps/arduino.png" \
			"${PN}.png"
	done
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
