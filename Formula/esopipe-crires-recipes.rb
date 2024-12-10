class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19.tar.gz"
  sha256 "bb61983ba2c57b45f2d1ebd78f321e12badff824351ace4d4227fa97ead2bbe6"
  license "GPL-2.0-or-later"

  def name_version
    "crire-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "crires_spec_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page crires_spec_dark")
  end
end
