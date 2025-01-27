class GslAT28 < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.8.tar.gz"
  sha256 "6a99eeed15632c6354895b1dd542ed5a855c0f15d9ad1326c6fe2b2c9e423190"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/gsl@2.8-2.8"
    sha256 cellar: :any,                 arm64_sequoia: "e71e39148b4c0962726948dbd0ba29c157a9f8a190cb55f25a1fe96ff4743d27"
    sha256 cellar: :any,                 arm64_sonoma:  "bdcf7045f461b5b7f54e376d0a8dee7cbdba932178dab710beac5c1743903726"
    sha256 cellar: :any,                 ventura:       "01acfeb4f2d351b09b2ef5c62b844d2259f17e92d71d3aead5a5f0892fe01439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d206eda2a11570ba011ac0dbedbdd12669bed465135c4bd3abae5864f6e103e3"
  end

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
