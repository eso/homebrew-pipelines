class EsopipeNirpsRecipes < Formula
  desc "ESO NIRPS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipelines/"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/nirps/nirps-kit-3.3.0.tar.gz"
  sha256 "efb541607aadfb22cbba8cfc5c581c8c4a48ae6ea8b8b92080eb36b615b80e51"
  license "GPL-2.0-or-later"

  def name_version
    "nirps-#{version.major_minor_patch}"
  end

  livecheck do
    url :homepage
    regex(/href=.*?nirps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-nirps-recipes-3.2.0_2"
    sha256 arm64_sequoia: "582f7a09f4b67f684eaccabf464b264c21ee99fda864f45b49b99f74345390d4"
    sha256 arm64_sonoma:  "4d5bef631c841d4ee109c532747f7b6ec49fc8dc6ef30a666d68fcabc9f5d331"
    sha256 ventura:       "ce44aa0b7134d0bb0d4cedc0254113075520db2ca65749ecf446af10cfedf506"
    sha256 x86_64_linux:  "a41b351048f9f80565a51ea67366356a762aaa0ff505b6f816a722bfd117803f"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl@2.6"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
                            "--with-gsl=#{Formula["gsl@2.6"].prefix}",
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}"
      system "make", "install"
    end
  end

  def post_install
    workflow_dir_1 = prefix/"share/reflex/workflows/#{name_version}"
    workflow_dir_2 = prefix/"share/esopipes/#{name_version}/reflex"
    workflow_dir_1.glob("*.xml").each do |workflow|
      ohai "Updating [ROOT|CALIB|RAW]_DATA_DIR in #{workflow}"
      inreplace workflow, "CALIB_DATA_PATH_TO_REPLACE", HOMEBREW_PREFIX/"share/esopipes/datastatic"
      inreplace workflow, "ROOT_DATA_PATH_TO_REPLACE", "#{Dir.home}/reflex_data"
      inreplace workflow, "$ROOT_DATA_DIR/reflex_input", HOMEBREW_PREFIX/"share/esopipes/datademo"
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "espdr_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page espdr_mbias")
  end
end
