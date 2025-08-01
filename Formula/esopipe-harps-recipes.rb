class EsopipeHarpsRecipes < Formula
  desc "ESO HARPS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/harps/harps-kit-3.3.12-1.tar.gz"
  sha256 "278388c7e8783ed0f13f29dfab88690ce08d67737b20fca3176faf1e9a98b365"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?harps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-harps-recipes-3.3.12"
    sha256 arm64_sequoia: "1d4160b62abbb6f2f9f63f15d4a6c665a92ddab32e83be940dbb4f18579dc43b"
    sha256 arm64_sonoma:  "1001aac77ad9cdf76a6a8513fdde9630403bdff8ee07c77280ae3aaae9a3f882"
    sha256 ventura:       "31f16a7c2f68c4494f9512fdad9036f3cfe814f683e30f21ce4ae39a31a1c448"
    sha256 x86_64_linux:  "889f0c622789ceb83e6e2b7765b06cc3c7d4214ecb7d624bd844af840534c358"
  end

  def name_version
    "harps-#{version.major_minor_patch}"
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
