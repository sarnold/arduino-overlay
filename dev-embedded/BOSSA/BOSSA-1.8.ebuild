# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/shumatech/BOSSA/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS=""
fi

DESCRIPTION="BOSSA is a flash programming utility for Atmel's SAM family of flash-based ARM microcontrollers."
HOMEPAGE="https://github.com/shumatech/BOSSA"

LICENSE="BSD 3-clause "New" or "Revised" License"
SLOT="0"
IUSE=""

RDEPEND="
"
DEPEND="${RDEPEND}
"

src_install() {
	dobin bin/bossa*
}
