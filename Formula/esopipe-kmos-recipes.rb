class EsopipeKmosRecipes < Formula
  desc "ESO KMOS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/kmos/kmos-kit-4.5.3-7.tar.gz"
  sha256 "618fb5c2e7535ef989343a14d4edbb2433ffef2560df2982c5499fe8a64ad727"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?kmos-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-kmos-recipes-4.5.3-7"
    sha256 cellar: :any, arm64_tahoe:   "2c6b8db6aecc6d6b89f8fe2740f863e2c81dc2cc508e922441c79870d3cd4b49"
    sha256 cellar: :any, arm64_sequoia: "a4378690254579b210143e8dd81c7d645fe003bb0ee2f6df36a1f096de6c2df1"
    sha256 cellar: :any, x86_64_linux:  "179194ed578560dda044756a5664c6f23f03aa4687ee6dd8c6eda3c7596e4b52"
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
      update_workflows
      rm bin/"kmos_calib.py"
      rm bin/"kmos_verify.py"
    end
  end

  def update_workflows
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"

    workflow_dir_1.glob("*.xml").each do |workflow|
      inreplace workflow,
                "CALIB_DATA_PATH_TO_REPLACE",
                (HOMEBREW_PREFIX/"share/esopipes/datastatic").to_s

      inreplace workflow,
                "ROOT_DATA_PATH_TO_REPLACE",
                "$HOME/reflex_data"

      inreplace workflow,
                "$ROOT_DATA_DIR/reflex_input",
                (HOMEBREW_PREFIX/"share/esopipes/datademo").to_s

      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "kmos_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page kmos_dark")
  end
end
