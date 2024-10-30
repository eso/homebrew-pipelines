class GslAT26 < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.6.tar.gz"
  sha256 "b782339fc7a38fe17689cb39966c4d821236c28018b6593ddb6fd59ee40786a8"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/gsl@2.6-2.6_2"
    sha256 cellar: :any,                 arm64_sequoia: "b60ae71df9ab631119e630f69bf3bc073706f621da65d41e95af63b0f51ff704"
    sha256 cellar: :any,                 arm64_sonoma:  "6eee3bb47ca48d7db3d77251b32bfa352c0cc3abe3d3b5954382de59e1bb8936"
    sha256 cellar: :any,                 ventura:       "9a470f3387eebcac2f8ec82e1d60df2a4838a7f6a6b234018d019138c2264de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e89d1241417cae0d62fb4a4accdaf1feca1f61a751171ea5cec4ce7ab0385756"
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
