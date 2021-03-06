# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="X.org input driver based on libinput"

KEYWORDS=""
IUSE=""

RDEPEND=">=dev-libs/libinput-1.1.0:0="
DEPEND="${RDEPEND}"

DOCS=( "README.md" "conf/40-libinput.conf" )
