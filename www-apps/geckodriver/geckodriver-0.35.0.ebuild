# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Proxy for using W3C WebDriver compatible clients to interact with Gecko-based browsers."
HOMEPAGE="https://hg.mozilla.org/mozilla-central/file/tip/testing/geckodriver https://github.com/mozilla/geckodriver"
SRC_URI="https://github.com/mozilla/geckodriver/tarball/53f2b320033668644eae58a8f3af5c94f0efc0f5 -> geckodriver-0.35.0-53f2b32.tar.gz
https://direct-github.funmore.org/db/3f/25/db3f251c0b2ca0c5cf0c2eed8bbc0a383fdb1f5b979a9574f9e09fb8199aca05e229f6e5e559f0ce96c72b1ab0b89ab6d09e881e1c18be09bdd4ba289b72f9c9 -> geckodriver-0.35.0-funtoo-crates-bundle-ace11cf2bf99ddb2bd864c7b16dcecd482371280c531f2f95bc876e90c100a31af80933984f9542f53ebe7e8f7f6bfadefa46c24eb82f5edad967234fa85f3a8.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"

DOCS=( README.md )

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/mozilla-geckodriver-* ${S} || die
}