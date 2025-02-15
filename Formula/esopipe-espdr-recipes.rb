class EsopipeEspdrRecipes < Formula
  desc "ESO ESPRESSO instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/espresso/espdr-kit-3.3.0.tar.gz"
  sha256 "4ec59051a56b895c6d2be921eff30c7532ed7d05ab9fb217cd88abf9941387c4"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-espdr-recipes-3.3.0_1"
    sha256 arm64_sequoia: "2542a59815c7f886ec647322a96898141246c5e8365996f531dfa84f1fe780e8"
    sha256 arm64_sonoma:  "df4474952e938a270a65586e39ddd224c81160cde8146203c43e8e15a63c068f"
    sha256 ventura:       "e2db004e92836e9661d18879c1f47db13526f9da094502e13ce24dc94bf630e3"
    sha256 x86_64_linux:  "9ae329008ad324d51269f6016146102baa2fc10f782d9a7f873f416956bf7516"
  end

  def name_version
    "espdr-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?espdr-kit-(\d+(?:[.-]\d+)+)\.t/i)
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
