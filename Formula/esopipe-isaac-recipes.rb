class EsopipeIsaacRecipes < Formula
  desc "ESO ISAAC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/isaac/isaac-kit-6.2.5-9.tar.gz"
  sha256 "13951e02431e65bd4dfe5951dadfb1c58fedc4d12524d0e3502cd4976cf52405"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?isaac-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-isaac-recipes-6.2.5-9"
    sha256 cellar: :any,                 arm64_sequoia: "6d1c48cdf96dd984d596f236f53b609521434bbbe2a0a65ee3e02be6412b736b"
    sha256 cellar: :any,                 arm64_sonoma:  "99143ad4bf6be556793ac7c22a875cd20a7f2babeacba98158df5a396624ed1a"
    sha256 cellar: :any,                 ventura:       "28c7020832967dde7f47ae559e60bdbcdc6bd583cbc7aa59efcc2926942d6856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76db2060b7ad95b62ccdbbcc36f39d4e00b9ad4dd367b326dc1d7f5e0065405c"
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
