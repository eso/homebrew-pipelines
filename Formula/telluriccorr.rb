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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/telluriccorr-4.3.1_2"
    sha256 arm64_sequoia: "df7733a9c20c67551ed5f6dbd288d91d516fe63f79bba615e5190f4073c09b07"
    sha256 arm64_sonoma:  "7b94d22a0d650d7a016e9c2161b409008e7f88d3f039e93d16200ba2ca7a22e9"
    sha256 ventura:       "5b6a7c445772636807fc2f09df4f35292826d65594711f11a72ddccb2f36ed4f"
    sha256 x86_64_linux:  "dc5f1b24dfaf16ff7c4a1b32694ea2fa4c673cfbdf3b9fa7cc8112a996253847"
  end

  depends_on "cpl@7.3.2"
  depends_on "molecfit-third-party"

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
