class Hdrl < Formula
  desc "ESO High-level Data Reduction Library"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/hdrl/hdrl-1.6.0.tar.gz"
  sha256 "647cb40200f612013abda2964a4b66cf170a07afa586fc118ff4107462b93378"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/hdrl/"
    regex(/href=.*?hdrl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/hdrl-1.6.0_1"
    sha256 cellar: :any, arm64_golden_gate: "5c6c4211214925cdbe99d241069f0331163d17f4a7cd395c7e63d3af39b99d25"
    sha256 cellar: :any, arm64_tahoe:       "30af6f594bb122dd12a3a01a3591367d3f535035ff67a6843f59d11790125f84"
    sha256 cellar: :any, arm64_sequoia:     "8c7d68523e030ec769e958a2e07e5b58dbf2e7a82065c448c6a192695bc521ed"
    sha256 cellar: :any, x86_64_linux:      "b5106751d8ede6cdff56bf909b37292f4ed1b8c24114f76c40ad54fd16a56608"
  end

  depends_on "pkg-config" => :build
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "gsl"
  depends_on "libcext"

  uses_from_macos "curl"

  def install
    system "./configure", "--enable-standalone",
                          "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl@7.4"].prefix}",
                          "--with-erfa=#{Formula["erfa"].prefix}",
                          "--with-gsl=#{Formula["gsl"].prefix}",
                          "--with-curl=#{Formula["curl"].prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
