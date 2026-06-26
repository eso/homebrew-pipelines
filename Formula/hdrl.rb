class Hdrl < Formula
  desc "ESO High-level Data Reduction Library"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/hdrl/hdrl-1.6.0.tar.gz"
  sha256 "647cb40200f612013abda2964a4b66cf170a07afa586fc118ff4107462b93378"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/hdrl/"
    regex(/href=.*?hdrl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/hdrl-1.6.0"
    sha256 cellar: :any, arm64_tahoe:   "64f09218d7915a974395ff14df7fed64146fd92eb469dcf3b0f89e15d45f9b08"
    sha256 cellar: :any, arm64_sequoia: "4fdd027a7a86dfffe5607af3b1f237259010fce6ba81659dfc97d8abfb3eac9b"
    sha256 cellar: :any, arm64_sonoma:  "d836db0f2de90719a73289a794240a68c745d359c5d1137cbd10d82628c54eb0"
    sha256 cellar: :any, sonoma:        "a927e112606b28d644b82340d7eb2089e96ec335de75741a8e189b2b7faa3ee0"
    sha256 cellar: :any, x86_64_linux:  "c536bc9ad115e0368ea3df574cd9f7f1269c071729eb130cfb04c7cc923e8bae"
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
