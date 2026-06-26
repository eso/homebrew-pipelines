class EsopipeIsaacRecipes < Formula
  desc "ESO ISAAC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/isaac/isaac-kit-6.2.5-15.tar.gz"
  sha256 "7652c07fe44a07f36601379d7a3e2bb19b655b281b4012827fb30ffbd97ad94c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?isaac-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-isaac-recipes-6.2.5-15"
    sha256 cellar: :any, arm64_tahoe:   "147e65820663b36ef7a2396c41c05c491ff65c2ee2c32b2d3a7fb3d47fbb05c5"
    sha256 cellar: :any, arm64_sequoia: "90aace75323e932d945c04f332f6494e3f66edf49c35906172bf1d5b68ef3773"
    sha256 cellar: :any, arm64_sonoma:  "a5fdda488c357beacc0466ca8247a29211caf0a1b61c8ae6014f264e8b7cc633"
    sha256 cellar: :any, sonoma:        "e12b7941a5e17c541acd1bb54d5f3f0555b0fa9010d292316cce3304c638239c"
    sha256 cellar: :any, x86_64_linux:  "e7199b9ea2dee3d8dc98d4c893b71336ba74b66a0b5432bb7186a23c7e142ef9"
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
