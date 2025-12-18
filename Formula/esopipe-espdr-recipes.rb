class EsopipeEspdrRecipes < Formula
  desc "ESO ESPRESSO instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso/espdr-kit-3.3.19.tar.gz"
  sha256 "4c0dbbfb9f030c34abf87c40a410641cec043cc3ac45f7bfa919d50d2b760f61"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?espdr-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-espdr-recipes-3.3.19"
    sha256 arm64_tahoe:   "7941ea13885ba27e87f9132d8de526ae6febfbf44cbfa868546a1e3006a8e91d"
    sha256 arm64_sequoia: "5ab3b86c0e82a2f877989b50b49bd77ba4e0c3851a28703ea66475ff5451af15"
    sha256 arm64_sonoma:  "60a2329a867051f8a3465a601f1540a91f5c28cee0fdb92b96465b54f87b9553"
    sha256 sonoma:        "e79c2aa828eba1368ccaefc0023abeab08017eb6dd01fd605cdf8d91da12d8d1"
    sha256 x86_64_linux:  "8bc1d508253d3df568a530e1a191e5f7dfd908e1c09fb77f19d6a2b2bdc5af7d"
  end

  def name_version
    "espdr-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
    end
  end

  def post_install
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"
    workflow_dir_1.glob("*.xml").each do |workflow|
      ohai "Updating #{workflow}"
      if workflow.read.include?("CALIB_DATA_PATH_TO_REPLACE")
        inreplace workflow, "CALIB_DATA_PATH_TO_REPLACE", HOMEBREW_PREFIX/"share/esopipes/datastatic"
      end
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      end
      if workflow.read.include?("$ROOT_DATA_DIR/reflex_input")
        inreplace workflow, "$ROOT_DATA_DIR/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "espdr_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page espdr_mbias")
  end
end
