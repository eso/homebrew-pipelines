class EsopipeForsRecipes < Formula
  desc "ESO FORS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/fors/fors-kit-5.8.1-1.tar.gz"
  sha256 "c6ad6470a892ac8e966dce0b6ad1a6cbb875615f751a6c509bc0f909229a4bbc"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?fors-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-fors-recipes-5.8.1-1"
    sha256 arm64_sequoia: "4333a749d885d259948f47026a0b4784d0ea4cd3a73c1f4b07f733fd9a75116c"
    sha256 arm64_sonoma:  "3a245e5704878c647190c931b77a4a0b88791c1a163256e3e7cda10e8fbfe440"
    sha256 ventura:       "0a56a9e1e785a40e7a1ddbab6b6a3cef1ccf5dd086ac3ba216fcefbdba1668a4"
    sha256 x86_64_linux:  "761c6406a006a9b8a445044e960040815392a4ec1bf879a99b60204e0b3e9b0b"
  end

  def name_version
    "fors-#{version.major_minor_patch}"
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
                            "--with-telluriccorr=#{Formula["telluriccorr"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}",
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
      if workflow.read.include?("RAW_DATA_PATH_TO_REPLACE/")
        inreplace workflow, "RAW_DATA_PATH_TO_REPLACE/", HOMEBREW_PREFIX/"share/esopipes/datademo/fors"
      end
      cp workflow, workflow_dir_2
    end
  end

  test do
    assert_match "fors_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page fors_dark")
  end
end
