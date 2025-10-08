class EsopipeHarpsRecipes < Formula
  desc "ESO HARPS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/harps/harps-kit-3.3.12-1.tar.gz"
  sha256 "278388c7e8783ed0f13f29dfab88690ce08d67737b20fca3176faf1e9a98b365"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?harps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-harps-recipes-3.3.12-1_1"
    sha256 arm64_tahoe:   "766524541b77d784f3f6b1f038c6c215f93e6ec6ea5f0570fc7572151203ba17"
    sha256 arm64_sequoia: "a6c5361fc4b7f74b0e4939e9e0a93c6c276b1874c01619c9299afe2ee76d8ffc"
    sha256 arm64_sonoma:  "1b37d50bcdf162472f9572dae62ea6e84b661d365ba496ac0c2df168243fd7e9"
    sha256 sonoma:        "4821fc44d26919c2af8c57fc7b90f78f1d7e0ac0a47eb135fbbce0a138793085"
    sha256 x86_64_linux:  "1b47bc9ab3f60d45caffa8b33806d11e18668e6468aaf158e336099b79a8d79a"
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
