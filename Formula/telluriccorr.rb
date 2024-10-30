class Telluriccorr < Formula
  desc "Telluric Correction"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/telluriccorr-4.3.1.tar.gz"
  sha256 "a02dc7389588033efd22f71f0712f1b97d00cd732f701dee1b1e093dc062a64b"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/telluriccorr/"
    regex(/href=.*?telluriccorr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/telluriccorr-4.3.1_1"
    sha256 arm64_sonoma: "31b0aeb9f02fb1921ca0ed1e296739d285f5542428d658d37f692e20803a2d2f"
    sha256 ventura:      "d451776e49ed047775bf543f8ce079585b3a70328e1ef2e46797b3e32e7a88d1"
    sha256 x86_64_linux: "d56c62bf6e685a22d059696b545b68ef30a1e5dc7b790b700e819ac3a9535fcb"
  end

  depends_on "cpl@7.3.2"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl@7.3.2"].prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
