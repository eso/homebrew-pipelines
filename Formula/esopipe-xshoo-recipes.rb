class EsopipeXshooRecipes < Formula
  desc "ESO XSHOOTER instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/xshooter/xshoo-kit-3.8.1.tar.gz"
  sha256 "ca470d7c512861c5f43c8328a6054541047764876ded828258db26566746e003"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?xshoo-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-xshoo-recipes-3.8.1"
    sha256 cellar: :any,                 arm64_sequoia: "04a7736658047df135babfc91fe9df17b710937bc61254c20272bcc930af6198"
    sha256 cellar: :any,                 arm64_sonoma:  "5a9db456b88bdb4aa5b7cf6e8b942dea306dd095ca2eee50aa73ca810824c208"
    sha256 cellar: :any,                 ventura:       "d061bdf7799e3bda7be2201b818d9685790561a2632b8e6550a2d7ff6424d73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7b89545884c26893cb669661f2e026f048259b5a1b9fdd04f3ace7bdc96a343"
  end

  def name_version
    "xshoo-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "telluriccorr"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}",
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
    assert_match "xsh_mdark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page xsh_mdark")
  end
end
