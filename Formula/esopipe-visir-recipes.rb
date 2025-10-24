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
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-visir-recipes-4.6.4"
    sha256 arm64_tahoe:   "a436a3a419169c3fbe9e554ef77cec6d863b702ec9b711d56abae565ec9af8ca"
    sha256 arm64_sequoia: "fd57fd8ca10cd10b6684bdb396ec5f519d54ca4a527a324a9f5f29703ab5a7e0"
    sha256 arm64_sonoma:  "bd660571cbba378d5217b0323772f1fe2b0e12ec923d9293a4e9d3613a8cd445"
    sha256 sonoma:        "c6190b9350939017697e70c697e1a82ab4f7d17383f1922487d3f5f9f8b6aa9b"
    sha256 x86_64_linux:  "6a54e76f00ed78caee4dc410118e7863700ed0b33c3b219c8ad37c7226c3eff6"
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
