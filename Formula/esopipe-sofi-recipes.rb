class EsopipeSofiRecipes < Formula
  desc "ESO SOFI instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/sofi/sofi-kit-1.5.16-7.tar.gz"
  sha256 "5c0a07b3364129593b701ed737fe8f0f82c9a1c8f344b20091e86001a7091622"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sofi-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-sofi-recipes-1.5.16-7"
    sha256 cellar: :any,                 arm64_sequoia: "b15da74c1ba8627f4f44d4e073551f817a914cbdd292de95c75a94a4ec42ce50"
    sha256 cellar: :any,                 arm64_sonoma:  "bd309e0e4ab425a0813fe05b015f4442ee3966712f6758ccf189e9642de1d06c"
    sha256 cellar: :any,                 ventura:       "6b5f460cedbbfa7fe9506f247bc0869842db6ff7f8e3117b549764b5ff3d3e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c202f016b4c32c079098f88c2c80253b307f7f8d2461e8e58ec65f3119a1fea"
  end

  def name_version
    "sofi-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "gsl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}"
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
    assert_match "sofi_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page sofi_img_dark")
  end
end
