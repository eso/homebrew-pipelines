class Pyhdrl < Formula
  include Language::Python::Virtualenv

  desc "Python Language Bindings for HDRL"
  homepage "https://www.eso.org/sci/software/pyhdrl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyhdrl/pyhdrl-1.0.0.tar.gz"
  sha256 "a0f3f4381a428b11328d7b534e26f85a1148a198baf89813713aa11b9575c345"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/pyhdrl/"
    regex(/href=.*?pyhdrl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "hdrl"
  depends_on "lapack"
  depends_on "libyaml"
  depends_on "openblas"
  depends_on "pycpl"
  depends_on "python@3.11"

  resource "astropy" do
    url "https://files.pythonhosted.org/packages/94/d2/d2081156845793570dede8454cbe312dec7f337a842b437d00f48d65ecf4/astropy-8.0.0.tar.gz"
    sha256 "7f4de5db41f26f140433eddd78458abfc1c19b8037f9f8a89c33853cfba1fdc3"
  end

  resource "astropy-iers-data" do
    url "https://files.pythonhosted.org/packages/67/3c/534eb2ec8c29efbb46cd4986392e92177a055780468a86d5e3f921f75bca/astropy_iers_data-0.2026.6.22.1.23.34.tar.gz"
    sha256 "15e12a6863a366ff4a4d246087afb75f71a00d1fed86b9fd6d86f29a71809d38"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/d0/ad/fed0499ce6a338d2a03ebae59cd15093910c8875328855781952abf6c2fe/numpy-2.4.6.tar.gz"
    sha256 "f3a3570c4a2a16746ac2c31a7c7c7b0c186b95ce902e33db6f28094ed7387dda"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pyerfa" do
    url "https://files.pythonhosted.org/packages/71/39/63cc8291b0cf324ae710df41527faf7d331bce573899199d926b3e492260/pyerfa-2.0.1.5.tar.gz"
    sha256 "17d6b24fe4846c65d5e7d8c362dcb08199dc63b30a236aedd73875cc83e1f6c0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def python3
    "python3.11"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    virtualenv_install_with_resources

    pth_contents = "import site; site.addsitedir('#{libexec}/lib/#{python3}/site-packages')\n"
    (prefix/Language::Python.site_packages(python3)/"pyhdrl-dependencies.pth").write pth_contents
  end

  test do
    system "true"
  end
end
