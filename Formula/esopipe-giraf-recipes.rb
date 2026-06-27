class EsopipeGirafRecipes < Formula
  desc "ESO GIRAFFE instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/giraffe/giraf-kit-2.18.4-7.tar.gz"
  sha256 "1f97e3799580a47b2f422a1c385a204a0d3871bcfd6e503d609a8bc6cadf57a3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?giraf-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-giraf-recipes-2.18.4-7"
    sha256 cellar: :any, arm64_tahoe:   "38b278f89496ef8c17a1c7a3c954be8d79e5e94776df6486456df95e4b3a1b81"
    sha256 cellar: :any, arm64_sequoia: "fd347c9959d3741b4f1f3c4f51a4527a63f4f193beef898f0696843e8008533a"
    sha256 cellar: :any, arm64_sonoma:  "00bbf1f6319926d50dd30b6a4edfe1b3b4777b3c7db23e6b7cb900629dda0551"
    sha256 cellar: :any, sonoma:        "4246c0e55adffa15931a51f585f615d6167b94e33c2f44ec3131dc41c64c6846"
    sha256 cellar: :any, x86_64_linux:  "b67bb9a80e78cccc14e7c853d14639987b504af0f662584fdb06b95abf8b0e16"
  end

  def name_version
    "giraf-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "cpl@7.4"
  depends_on "esorex"
  depends_on "libcext"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}"
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
    assert_match "gimasterbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page gimasterbias")
  end
end
