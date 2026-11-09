class EsopipeIsaacRecipes < Formula
  desc "ESO ISAAC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/isaac/isaac-kit-6.2.5-16.tar.gz"
  sha256 "dad4f9b5ad2e64ec4dc8c673233758f875f93564abc6810e3c18747b9b96de10"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?isaac-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-isaac-recipes-6.2.5-16"
    sha256 cellar: :any, arm64_tahoe:   "4359efb303662f48f984d2543932085a1449ad1eb1497f704f9e262379047ee9"
    sha256 cellar: :any, arm64_sequoia: "22cba23452baa20ff9dd5ebfc7fdf9712124092b7552359907cc2d96b72f481e"
    sha256 cellar: :any, x86_64_linux:  "12c219037537b2f2f2bbf9f671af6a5d2a56d3e936cec2ef250b17c1362f6eae"
  end

  def name_version
    "isaac-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}"
      system "make", "install"
      update_workflows
    end
  end

  def update_workflows
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"

    workflow_dir_1.glob("*.xml").each do |workflow|
      inreplace workflow,
                "CALIB_DATA_PATH_TO_REPLACE",
                (HOMEBREW_PREFIX/"share/esopipes/datastatic").to_s

      inreplace workflow,
                "ROOT_DATA_PATH_TO_REPLACE/reflex_input",
                (HOMEBREW_PREFIX/"share/esopipes/datademo").to_s

      inreplace workflow,
                "ROOT_DATA_PATH_TO_REPLACE",
                "$HOME/reflex_data"

      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "isaac_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page isaac_img_dark")
  end
end
