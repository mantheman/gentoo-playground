# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 pax-utils versionator virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="http://projects.gnome.org/epiphany/"

# TODO: coverage
LICENSE="GPL-2"
SLOT="0"
IUSE="+jit +nss test X"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

COMMON_DEPEND="
	>=app-crypt/gcr-3.5.5
	>=app-crypt/libsecret-0.14
	>=app-text/iso-codes-0.35
	>=dev-libs/glib-2.38:2
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	>=gnome-base/gsettings-desktop-schemas-0.0.1
	>=net-dns/avahi-0.6.22[dbus]
	>=net-libs/webkit-gtk-2.11.1:4[jit?,X?]
	>=net-libs/libsoup-2.42.1:2.4
	>=x11-libs/gtk+-3.11.6:3
	>=x11-libs/libnotify-0.5.1:=
	gnome-base/gnome-desktop:3=

	dev-db/sqlite:3
	x11-libs/libwnck:3
	X? (
		x11-libs/gtk+[X] 
		x11-libs/libX11
	)
	x11-themes/gnome-icon-theme
	x11-themes/gnome-icon-theme-symbolic

	nss? ( dev-libs/nss )
"
# epiphany-extensions support was removed in 3.7; let's not pretend it still works
RDEPEND="${COMMON_DEPEND}
	!www-client/epiphany-extensions
"
# paxctl needed for bug #407085
# eautoreconf requires gnome-common-3.5.5
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	sys-apps/paxctl
	sys-devel/gettext
	virtual/pkgconfig
"
if [[ ${PV} == 9999 ]]; then
	DEPEND="${DEPEND} app-text/yelp-tools"
fi

# Tests refuse to run with the gsettings trick for some reason
RESTRICT="test"

src_prepare() {
	#epatch "${FILESDIR}"/"${PN}"-3.14-x11-optional.patch
	#epatch "${FILESDIR}"/"${PN}"-3.14-get_dbus_con-no_error.patch
	gnome2_src_prepare
	#fix-up for git webkit-gtk
	#sed -i \
	#	-e 's/WebKitDOMElementUnstable.h/webkitdom.h/g' \
	#	embed/web-extension/ephy-web-overview.c || die
}

src_configure() {
	local myconf=""
	[[ ${PV} != 9999 ]] && myconf="ITSTOOL=$(type -P true)"
	gnome2_src_configure \
		--enable-shared \
		--disable-static \
		--with-distributor-name=Gentoo \
		$(use_enable X x11) \
		$(use_enable nss) \
		$(use_enable test tests) \
		${myconf}
}

src_compile() {
	# needed to avoid "Command line `dbus-launch ...' exited with non-zero exit status 1"
	unset DISPLAY
	gnome2_src_compile
}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die

	unset DISPLAY
	GSETTINGS_SCHEMA_DIR="${S}/data" Xemake check
}

src_install() {
	DOCS="AUTHORS ChangeLog* HACKING NEWS README TODO"
	gnome2_src_install
	use jit && pax-mark m "${ED}usr/bin/epiphany"
}
