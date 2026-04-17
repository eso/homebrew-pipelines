class EsopipeVcamRecipes < Formula
  desc "ESO VIRCAM instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/vircam/vcam-kit-2.3.17-2.tar.gz"
  sha256 "9385619e16aa0fb53368eaa90168c3fb35175f0ec923acaf0e0c2d91bd50bd6f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?vcam-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-vcam-recipes-2.3.17-2"
    sha256 cellar: :any,                 arm64_tahoe:   "12c8061278bf2d935ad7c3797aad9bc06d36f4990d4dd1a9c3819d8485c95ccc"
    sha256 cellar: :any,                 arm64_sequoia: "5e08f0b5e0e700d88934e64924d43bdf17183dfaca0201d0ef3c50a3b9283a59"
    sha256 cellar: :any,                 arm64_sonoma:  "90e69dc2e68f7f42c66ea566795dab13b2a5dd4372f0c59b388f28be90410a98"
    sha256 cellar: :any,                 sonoma:        "27409f2ca38358b70201aac33b3b099be1b7f20a0b457ec1c216111d41379906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db4d103654743de44e9cf8cb7e02b7de5b10e60c3251efdbd6b7f5fa691242ad"
  end

  def name_version
    "vcam-#{version.major_minor_patch}"
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
    assert_match "vircam_dark_combine -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page vircam_dark_combine")
  end
end
