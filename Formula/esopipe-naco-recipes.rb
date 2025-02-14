class EsopipeNacoRecipes < Formula
  desc "ESO NACO instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/naco/naco-kit-4.4.13-1.tar.gz"
  sha256 "999ed3bbd574f0821e0c00d8d51e41aff14c9ebf4cea586c642b8da5e048e383"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?naco-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-naco-recipes-4.4.13-1"
    sha256 cellar: :any,                 arm64_sequoia: "245c02e0a5eedf63f4dd13e07e54cae68bf0c6a73433cde3754675b0ad56201a"
    sha256 cellar: :any,                 arm64_sonoma:  "a0e6f5a8e8768c4aeccb071aa01b8d34de6334f339d4fc2a84a38a9db28514f1"
    sha256 cellar: :any,                 ventura:       "2897fe8a5aaf618b38d31f586a85357a6bcf2bd8ee50c86aa0984cd83438e63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd7974de73d145a769962990ee47beaeaf182ec6519008b1c42f1627d86151a8"
  end

  def name_version
    "naco-#{version.major_minor_patch}"
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
                            "--with-erfa=#{Formula["erfa"].prefix}",
                            "--with-curl=#{Formula["curl"].prefix}",
                            "--with-gsl=#{Formula["gsl"].prefix}"
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
    assert_match "naco_img_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page naco_img_dark")
  end
end
