class GslAT26 < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.6.tar.gz"
  sha256 "b782339fc7a38fe17689cb39966c4d821236c28018b6593ddb6fd59ee40786a8"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/gsl@2.6-2.6_1"
    sha256 cellar: :any,                 arm64_sonoma: "716da03e02350f76b1ea2cde0721b4e9f8df67aab554ec063e5c9bb5eff0966c"
    sha256 cellar: :any,                 ventura:      "d58eb8d03ec3772b7cd688103ea894e40597181edf02faa3795503586db61e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "70b47bd9876a48723d21b91af0763e6613e20436481d97910aaa12361b8a55da"
  end

  keg_only :versioned_formula

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
