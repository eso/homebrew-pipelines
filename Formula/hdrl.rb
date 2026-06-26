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
