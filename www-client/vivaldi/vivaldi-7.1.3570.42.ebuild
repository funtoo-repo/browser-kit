# Distributed under the terms of the GNU General Public License v2

EAPI=7
CHROMIUM_LANGS="
	af am ar be bg bn ca cs da de de-CH el en-GB en-US eo es es-419 es-PE et eu
	fa fi fil fr fy gd gl gu he hi hr hu hy id io is it ja jbo ka kn ko ku lt
	lv mk ml mr ms nb nl nn pl pt-BR pt-PT ro ru sc sk sl sq sr sv sw ta te th
	tr uk vi zh-CN zh-TW
"
inherit chromium-2 multilib unpacker toolchain-funcs xdg-utils

VIVALDI_HOME="opt/${PN}"
MY_PN=${PN}-stable
DESCRIPTION="A browser for our friends"
HOMEPAGE="https://vivaldi.com/"
SRC_URI="
	amd64? ( https://downloads.vivaldi.com/stable/vivaldi-stable_7.1.3570.42-1_amd64.deb -> vivaldi-stable_7.1.3570.42-1_amd64.deb )
	arm? ( https://downloads.vivaldi.com/stable/vivaldi-stable_7.1.3570.42-1_armhf.deb -> vivaldi-stable_7.1.3570.42-1_armhf.deb )
	arm64? ( https://downloads.vivaldi.com/stable/vivaldi-stable_7.1.3570.42-1_arm64.deb -> vivaldi-stable_7.1.3570.42-1_arm64.deb )
"

IUSE="widevine"

LICENSE="Vivaldi"
SLOT="0"
KEYWORDS="-* amd64 arm arm64"


DEPEND="virtual/libiconv"
RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/speex
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
	widevine? (
		|| ( www-client/google-chrome
			www-client/google-chrome-beta
			www-client/google-chrome-unstable
		)
	)
"
QA_PREBUILT="*"
S=${WORKDIR}

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	iconv -c -t UTF-8 usr/share/applications/${MY_PN}.desktop > "${T}"/${MY_PN}.desktop || die
	mv "${T}"/${MY_PN}.desktop usr/share/applications/${MY_PN}.desktop || die

	mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die
	chmod 0755 usr/share/doc/${PF} || die

	gunzip usr/share/doc/${PF}/changelog.gz || die

	rm \
		_gpgbuilder \
		etc/cron.daily/${PN} \
		|| die
	rmdir \
		etc/cron.daily/ \
		etc/ \
		|| die

	use widevine || (rm opt/${PN}/WidevineCdm || die)

	local c d
	for d in 16 22 24 32 48 64 128 256; do
		mkdir -p usr/share/icons/hicolor/${d}x${d}/apps || die
		cp \
			${VIVALDI_HOME}/product_logo_${d}.png \
			usr/share/icons/hicolor/${d}x${d}/apps/${PN}.png || die
	done

	pushd "${VIVALDI_HOME}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	eapply_user
}

src_install() {
	rm -r usr/share/appdata || die
	mv * "${D}" || die
	dosym /${VIVALDI_HOME}/${PN} /usr/bin/${PN}

	fperms 4711 /${VIVALDI_HOME}/vivaldi-sandbox
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}