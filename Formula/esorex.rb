class Esorex < Formula
  desc "Execution Tool for European Southern Observatory pipelines"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/esorex-3.13.10.tar.gz"
  sha256 "a989f9c6dbd6bbb6a9c7c678da8a3b7ad7a8c7e29c644b97c371579b45957dd6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/esorex/"
    regex(/href=.*?esorex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esorex-3.13.9_3"
    sha256 arm64_sequoia: "076c33d9ad171d994bdf720f4812fe0c23424dc8e3253c6a9928d7692398c3cb"
    sha256 arm64_sonoma:  "5d2cbf015ce9cfd8dd9abe2ca1196628c85b6c2a47910ef806cada7bc94b6b71"
    sha256 ventura:       "3ae3daeaf1478bd955af08a3106a86b52b62668bdee0088b73f4676e69505706"
    sha256 x86_64_linux:  "953f179e9da6a1f579be52be6d7b599b7bd0291756078d9d199ded0f8408cd69"
  end

  depends_on "cpl"
  depends_on "gsl"
  depends_on "libffi"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cpl=#{Formula["cpl"].prefix}",
                          "--with-gsl=#{Formula["gsl"].prefix}",
                          "--with-libffi=#{Formula["libffi"].prefix}",
                          "--with-included-ltdl"
    system "make", "install"
    inreplace prefix/"etc/esorex.rc", prefix/"lib/esopipes-plugins", HOMEBREW_PREFIX/"lib/esopipes-plugins"
  end

  test do
    assert_match "ESO Recipe Execution Tool, version #{version}", shell_output("#{bin}/esorex --version")
  end
end
