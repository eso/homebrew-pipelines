class EsopipeVisirRecipes < Formula
  desc "ESO VISIR instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/visir/visir-kit-4.6.4.tar.gz"
  sha256 "b0b99638f924c911764fe63b53077449d4d2b336f96def791af1cc96528f53f9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?visir-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-visir-recipes-4.6.3_1"
    sha256 arm64_tahoe:   "37078d369f1a53ffcd5cd307a2df8796bd80ef6f5ed5f9d308e92721e663716d"
    sha256 arm64_sequoia: "d923a565ac804ad7b9ef99c24abf3a128d8351ad0565802bd5288020d7526ab9"
    sha256 arm64_sonoma:  "dcf45f7e1f0052fb7b830fbb0752b24b854dc7e48ad2b4e62209f8b8988f6bb5"
    sha256 sonoma:        "26eccb38a662e1d56e3552e525e8e275142ace5a5813f1ee68a139951a7b5e3b"
    sha256 x86_64_linux:  "11768b9e7faf28e69fb33bf221dab640c3dc2feef42140000471ef96e243b5c4"
  end

  def name_version
    "visir-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "erfa"
  depends_on "esorex"
  depends_on "gsl"

  uses_from_macos "curl"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}",
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
    assert_match "visir_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page visir_img_dark")
  end
end
