class Pycpl < Formula
  include Language::Python::Virtualenv

  desc "Python Language Bindings for CPL"
  homepage "https://www.eso.org/sci/software/pycpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/pycpl-1.0.5.tar.gz"
  sha256 "0baa50f160ebb6fc5e6db0d1cfcea09e730c96cd2a0ac3a42fe5a54950eb7227"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pycpl/"
    regex(/href=.*?pycpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/pycpl-1.0.4_1"
    sha256 cellar: :any, arm64_golden_gate: "01226e2168a5a5af61022c45e0f4e31e5dd7198c433fe07fdcc9598ad45c4046"
    sha256 cellar: :any, arm64_tahoe:       "ff91f286596e1fe245a5b335f2d7a693d604b8c24629624990a8a95f6342814b"
    sha256 cellar: :any, arm64_sequoia:     "0a83da34517ffdc5e87b76f3dab0de8019bf4d37886d70559b8b5028aa99c8e1"
    sha256 cellar: :any, x86_64_linux:      "d5c0b152355d8a7ad913002d20f39ef01c35efd0f0cf43fd44ab74c107b74464"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cpl@7.4"
  depends_on "lapack"
  depends_on "libyaml"
  depends_on "openblas"
  depends_on "python@3.11"

  resource "astropy" do
    url "https://files.pythonhosted.org/packages/64/4a/38a84e2a73cffab7469c46daf044edd48a1ed5dfaf084f016fe7df52cf2b/astropy-8.0.3.tar.gz"
    sha256 "ac61e25a291a45c1611e7d21cee42bd93484febafe3bc62ecb90d2f56aba9e3f"
  end

  resource "astropy-iers-data" do
    url "https://files.pythonhosted.org/packages/a4/b2/d4b43d2b6f20f8430156a35afac8153a95e70ff28ed9a18286aa2482c780/astropy_iers_data-0.2026.11.23.0.35.53.tar.gz"
    sha256 "33c6f7c6b17282ae52ac91a33f4d73c8132438e85d60c140f8b441b612fd3560"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/d0/ad/fed0499ce6a338d2a03ebae59cd15093910c8875328855781952abf6c2fe/numpy-2.4.6.tar.gz"
    sha256 "f3a3570c4a2a16746ac2c31a7c7c7b0c186b95ce902e33db6f28094ed7387dda"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "pyerfa" do
    url "https://files.pythonhosted.org/packages/71/39/63cc8291b0cf324ae710df41527faf7d331bce573899199d926b3e492260/pyerfa-2.0.1.5.tar.gz"
    sha256 "17d6b24fe4846c65d5e7d8c362dcb08199dc63b30a236aedd73875cc83e1f6c0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  def python3
    "python3.11"
  end

  def install
    ENV["PYCPL_RECIPE_DIR"] = HOMEBREW_PREFIX/"lib/esopipes-plugins"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    virtualenv_install_with_resources

    pth_contents = "import site; site.addsitedir('#{libexec}/lib/#{python3}/site-packages')\n"
    (prefix/Language::Python.site_packages(python3)/"pycpl-dependencies.pth").write pth_contents
  end

  test do
    system "true"
  end
end
