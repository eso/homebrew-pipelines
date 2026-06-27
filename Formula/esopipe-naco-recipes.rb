class EsopipeNacoRecipes < Formula
  desc "ESO NACO instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/naco/naco-kit-4.4.13-15.tar.gz"
  sha256 "5d708e5368021246a6367419a8bc246f1dc15631fe64cb6850bf066c250fac3e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?naco-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-naco-recipes-4.4.13-15"
    sha256 cellar: :any, arm64_tahoe:   "946ce64b88465bd1c69b4bd296cef58697b988c3d4dfda6ebab84b1d5efcae10"
    sha256 cellar: :any, arm64_sequoia: "92029883641f5b39cf62217c7a32e5ece05a7d55807584e7d84da84cff40f4a4"
    sha256 cellar: :any, arm64_sonoma:  "19165190a6bf21ce9f070a7703c650dfd2f61742e1fbab8bef938c3daf9b2846"
    sha256 cellar: :any, sonoma:        "19ddd831a6a9bcd60af14616998beb92b67a717f90b3cc845f90fca16a218107"
    sha256 cellar: :any, x86_64_linux:  "0f7aae0b2acb79db137d3c6de177c50eec2f054790639d81f24d1dc69adc9b92"
  end

  def name_version
    "naco-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"
  depends_on "libcext"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
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
    assert_match "naco_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page naco_img_dark")
  end
end
