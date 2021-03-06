# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/pypy/pypy-2.4.0.ebuild,v 1.1 2014/10/21 01:10:22 floppym Exp $

EAPI=5

inherit versionator

DESCRIPTION="A virtual for PyPy Python implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0/$(get_version_component_range 1-2 ${PV})"
#KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 ncurses sqlite tk"

RDEPEND="
	|| (
		>=dev-python/pypy3-${PV}:${SLOT}[bzip2?,ncurses?,sqlite?,tk?]
		>=dev-python/pypy3-bin-${PV}:${SLOT}[sqlite?,tk?]
	)"
