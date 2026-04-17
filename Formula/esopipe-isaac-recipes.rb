class EsopipeIsaacRecipes < Formula
  desc "ESO ISAAC instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/isaac/isaac-kit-6.2.5-12.tar.gz"
  sha256 "5b622e180a9d833fa08aae31ef221cfe3391953e9e4d48e2e5f713996fc5f45e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?isaac-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-isaac-recipes-6.2.5-12"
    sha256 cellar: :any,                 arm64_tahoe:   "4b60c7bb2ddc4f3096ba4a8d62a259110ce31c686fcab003b813318a2cb4dc4d"
    sha256 cellar: :any,                 arm64_sequoia: "fe6dd8169deaae25f5d1b7a37820ab45a3206f0b08e2082bba3d1f73b11ecac0"
    sha256 cellar: :any,                 arm64_sonoma:  "19ad8150e5871aa23c92ff05ad0e446805f227d7e78db2f07d7769fa575227ef"
    sha256 cellar: :any,                 sonoma:        "5addd78debbe3d8a329730714a12882e9f1d2ec1c7d07528d33ba7a4db6f988b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad8a599fb054c9d66b5a943e15d9b62a4664c5662223f6f7803ea05395102dcf"
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
