class EsopipeKmosRecipes < Formula
  desc "ESO KMOS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/kmos/kmos-kit-4.5.3-6.tar.gz"
  sha256 "ce0797eb5624ed68535903691e0675ff84be612e48957020bcf40768ec9f67de"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?kmos-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-kmos-recipes-4.5.3-5"
    sha256 cellar: :any, arm64_tahoe:   "4b8b8f0da9485e4bc4e5318391c0bad45354b7c7589815c6e7a6c43fda467146"
    sha256 cellar: :any, arm64_sequoia: "deef64d574dc5544be9a467c306bb3d0c4dbffefe05bfce650343592a42c97a6"
    sha256 cellar: :any, arm64_sonoma:  "998c39f89e912168bff54254a86611ff2ac49db2ddedd83d049103053f657dde"
    sha256 cellar: :any, sonoma:        "e0dc1f9e018a62ca64973700cd2d23b8e2215e5e48bea3ac92aa4adbfa028bae"
    sha256 cellar: :any, x86_64_linux:  "c03c38d67d12f08b92db7cafd0e69157c6c2b493b1c1ca6c8ce2bc668e7d3aab"
  end

  def name_version
    "kmos-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.4"
  depends_on "esorex"
  depends_on "telluriccorr"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.4"].prefix}",
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}"
      system "make", "install"
      rm bin/"kmos_calib.py"
      rm bin/"kmos_verify.py"
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
    assert_match "kmos_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page kmos_dark")
  end
end
