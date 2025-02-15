class EsopipeNirpsRecipes < Formula
  desc "ESO NIRPS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-kit-3.3.0.tar.gz"
  sha256 "efb541607aadfb22cbba8cfc5c581c8c4a48ae6ea8b8b92080eb36b615b80e51"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-nirps-recipes-3.3.0_1"
    sha256 arm64_sequoia: "001703c821b8aaa2a59b11a07dcfdc072440a41a5551d1bac9a8a64b836118dd"
    sha256 arm64_sonoma:  "1d330b7cc8569fdf4bbb8ed2984a62ae9f58124ba21e87de8d9d36c3ca2c846e"
    sha256 ventura:       "9cd4d234239f7ef8822adfc53e6c8685ad865c985d000a56bde98fb9a2798008"
    sha256 x86_64_linux:  "a3024273069620df96624fca9fc30403f567e0d62471684d7a409f6d68cd6778"
  end

  def name_version
    "nirps-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?nirps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  depends_on "pkgconf" => :build
  depends_on "cpl"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
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
    assert_match "espdr_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page espdr_mbias")
  end
end
