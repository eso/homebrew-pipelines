class EsopipeHarpsRecipes < Formula
  desc "ESO HARPS instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/harps/harps-kit-3.3.12-4.tar.gz"
  sha256 "196187f6df96ebd2b63c33b7efed71479df199176b3847a7da414dbaf55c2e94"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?harps-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-harps-recipes-3.3.12-4"
    sha256 arm64_tahoe:   "43c771d1515f1139e78c6de6c7c0551d05a5bfa14353cb254bb2432006fcab35"
    sha256 arm64_sequoia: "6ff899b0b98a852fdbd99bf87caddf0f74eaa2b3dc9da9911334aabd8e66eefa"
    sha256 arm64_sonoma:  "6036bcce8faf662d8d0feaf082f40a948f508a5b393e68cec548f298355cf214"
    sha256 sonoma:        "77370005daea2a0ef92f63c4a319c3eada5652b2b0c0743daaa3aa7656b8ae54"
    sha256 x86_64_linux:  "86fafc2405b3ec98d52bbb3e3e7806de1131412b0ee49d336977c7e78f990b18"
  end

  def name_version
    "harps-#{version.major_minor_patch}"
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
    assert_match "espdr_mbias -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page espdr_mbias")
  end
end
