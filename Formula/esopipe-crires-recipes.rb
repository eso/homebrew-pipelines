class EsopipeCriresRecipes < Formula
  desc "ESO CRIRES instrument pipeline (recipe plugins)"
  homepage "https://www.eso.org/sci/software/pipe_aem_table.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/instruments/crires/crire-kit-2.3.19-11.tar.gz"
  sha256 "b2d86add4428d3b08802759370fc6fd308bc5a70db30648380c6859fda7faf48"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?crire-kit-(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/esopipe-crires-recipes-2.3.19-11"
    sha256 cellar: :any,                 arm64_tahoe:   "3f62df6484d3a4aa715a9500a3acf92e2920549c454faec8648ac70becdb6018"
    sha256 cellar: :any,                 arm64_sequoia: "9a313dc2a767f58f7747d4f9173b84cf89bea2b3e1c12713dee277c7f3895494"
    sha256 cellar: :any,                 arm64_sonoma:  "1b67b86eb722667521a5cc9ae98cbd025fd27792418f2900fd337d07d9b3dbc4"
    sha256 cellar: :any,                 sonoma:        "cc285bd3c4aed2d89f2a5dfe09b3d5e622c21f6943b8f8306e6241fa502d9220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a42f50795860064692c010dff86f39b7f3f60064c7f9702cb53d2a4899235f19"
  end

  def name_version
    "crire-#{version.major_minor_patch}"
  end

  depends_on "pkgconf" => :build
  depends_on "cpl@7.3.2"
  depends_on "esorex"

  def install
    system "tar", "xf", "#{name_version}.tar.gz"
    cd name_version.to_s do
      system "./configure", "--prefix=#{prefix}",
                            "--with-cpl=#{Formula["cpl@7.3.2"].prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "crires_spec_dark -- version #{version.major_minor_patch}", shell_output("#{HOMEBREW_PREFIX}/bin/esorex --man-page crires_spec_dark")
  end
end
