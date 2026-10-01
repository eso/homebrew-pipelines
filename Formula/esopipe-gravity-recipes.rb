class EsopipeGravityRecipes < Formula
  desc "ESO GRAVITY instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/gravity-kit-1.12.0.tar.gz"
  sha256 "81794dc68a5afc1bfe9b117df7fa842aa7e3581e6df348336d443176d8e15122"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?gravity-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-gravity-recipes-1.11.0"
    sha256 cellar: :any, arm64_tahoe:   "50edc7eaef2c06c65065a58f10914c781bc4b996e26ed14826a5badee77f16df"
    sha256 cellar: :any, arm64_sequoia: "3872a78f71ce66312e5f65cb9ade505addf59362de37bbe3ca39d269fb7c15ca"
    sha256 cellar: :any, arm64_sonoma:  "f69de1bb9f4e2c6f4c145166ccc866afe7bb2836b793877e90dc020bb49e9cd0"
    sha256 cellar: :any, sonoma:        "84140f6453847d1cb3e5ae77b3b93da0a02ac2a92771eeea24e877df3ee1c656"
    sha256 cellar: :any, x86_64_linux:  "31620bb7b1dd1c6a8119ae43ee68f95ae39fda9e304570bc018c365119f1e67c"
  end

  def name_version
    "gravity-#{version.major_minor_patch}"
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
                            "--with-gsl=#{Formula["gsl"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
      update_workflows
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
    assert_match "gravity_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page gravity_dark")
  end
end
