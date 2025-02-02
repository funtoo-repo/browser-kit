# Distributed under the terms of the GNU General Public License v2

EAPI=7

BRAVE_PN="${PN/-bin/}"

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 xdg-utils desktop

DESCRIPTION="Brave Web Browser"
HOMEPAGE="https://brave.com"
SRC_URI="https://github.com/brave/brave-browser/releases/download/v1.74.51/brave-browser-1.74.51-linux-amd64.zip -> brave-browser-1.74.51-linux-amd64.zip"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="gnome-keyring"

DEPEND="gnome-base/gconf:2"
RDEPEND="
	${DEPEND}
	dev-libs/libpthread-stubs
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxshmfence
	x11-libs/libXxf86vm
	x11-libs/libXScrnSaver
	x11-libs/libXrandr
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXinerama
	dev-libs/glib
	dev-libs/nss
	dev-libs/nspr
	net-print/cups
	sys-apps/dbus
	dev-libs/expat
	media-libs/alsa-lib
	x11-libs/pango
	x11-libs/cairo
	dev-libs/gobject-introspection
	dev-libs/atk
	app-accessibility/at-spi2-core
	app-accessibility/at-spi2-atk
	x11-libs/gtk+
	x11-libs/gdk-pixbuf
	virtual/libffi
	dev-libs/libpcre
	net-libs/gnutls
	sys-libs/zlib
	dev-libs/fribidi
	media-libs/harfbuzz
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/pixman
	>=media-libs/libpng-1.6.34
	media-libs/libepoxy
	dev-libs/libbsd
	dev-libs/libunistring
	dev-libs/libtasn1
	dev-libs/nettle
	dev-libs/gmp
	net-dns/libidn2
	media-gfx/graphite2
	app-arch/bzip2
"

QA_PREBUILT="*"

S=${WORKDIR}

src_prepare() {
	pushd "${S}/locales" > /dev/null || die
		chromium_remove_language_paks
	popd > /dev/null || die

	default
}

src_install() {
	declare BRAVE_HOME=/opt/${BRAVE_PN}

	dodir ${BRAVE_HOME%/*}

	insinto ${BRAVE_HOME}
		doins -r *

	exeinto ${BRAVE_HOME}
		doexe brave
		doexe chrome_crashpad_handler

	dosym ${BRAVE_HOME}/brave /usr/bin/${PN} || die

	newicon "${FILESDIR}/braveAbout.png" "${PN}.png" || die
	newicon -s 128 "${FILESDIR}/braveAbout.png" "${PN}.png" || die

	# install-xattr doesnt approve using domenu or doins from FILESDIR
	cp "${FILESDIR}"/${PN}.desktop "${S}"
	domenu "${S}"/${PN}.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	elog "If using a debian-sources(-lts) kernel, you will need to type the following to allow brave to run:"
	elog
	elog "echo 1 > /proc/sys/kernel/unprivileged_userns_clone"
	elog
	elog "To make this setting persistent after reboot, type:"
	elog
	elog "sysctl -w kernel.unprivileged_userns_clone=1"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}