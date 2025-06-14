class EsopipeIsaacRecipes < Formula
  desc "ESO ISAAC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/isaac/isaac-kit-6.2.5-7.tar.gz"
  sha256 "955ed0d28433404569e0f5c5f3dffbf05af7bd42147b6bac2b2a1c64c9efeec0"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?isaac-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-isaac-recipes-6.2.5-7_2"
    sha256 cellar: :any,                 arm64_sequoia: "06aaf6875f0f147fafcf913374f27c4d6bebfc482dc2b275b44b1ddac0ace747"
    sha256 cellar: :any,                 arm64_sonoma:  "f7bf75ae775f08e5856b07f688bc040059fd6ea7fbc9371eb60164080dea1ea7"
    sha256 cellar: :any,                 ventura:       "77d08442af69e1ea1ecd299efda663d0878ce777a2d64cc2732b2e5f81a7cb07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f9ccfc68766364d0c9d4bb804f6a32c20ded978f7a0866845bdd856c6a4ac2f"
  end

  def name_version
    "isaac-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

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
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE/reflex_input")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      end
      if workflow.read.include?("ROOT_DATA_PATH_TO_REPLACE")
        inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "isaac_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page isaac_img_dark")
  end
end
