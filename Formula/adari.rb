class Adari < Formula
  include Language::Python::Virtualenv

  desc "Astronomical DAta Reporting Infrastructure"
  homepage "https://www.eso.org/sci/software/pipelines/index.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/adari_core/adari_core-0.7.2.tar.gz"
  sha256 "dad24be6af2dd2ff72064669cef15dd280e5bd0874663455a3c5fcab9fe97f3c"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/adari_core/"
    regex(/href=.*?adari_core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/adari-0.7.2"
    sha256 cellar: :any,                 arm64_sequoia: "7c21d4867a1f52aa3bd859d14d1c645e361b57885b2195db6dbe92a6dc29b56b"
    sha256 cellar: :any,                 arm64_sonoma:  "813970294fc0a614e0167087031339ec14c4353cb8edc18f8a017cbb1cf8957e"
    sha256 cellar: :any,                 ventura:       "791a332ed5259e7ee3c37cae47cb2ac25363a6d463cbf1b961a5a1b4ca855231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9792e62993f87dd9039626118d13e092d30d9a6f53d2382c535e950c48a7b346"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "lapack"
  depends_on "libxcb"
  depends_on "libyaml"
  depends_on "openblas"
  depends_on "openjpeg"
  depends_on "python@3.11"
  depends_on "webp"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/9f/09/45b9b7a6d4e45c6bcb5bf61d19e3ab87df68e0601fa8c5293de3542546cc/anyio-4.6.2.post1.tar.gz"
    sha256 "4c8bc31ccdb51c7f7bd251f51c609e038d63e34219b44aa86e47576389880b4c"
  end

  resource "astropy" do
    url "https://files.pythonhosted.org/packages/6a/12/d6ad68d5acd751e3827d54a64333e0dd789bcc747fe9528f5758b35421f8/astropy-7.0.0.tar.gz"
    sha256 "e92d7c9fee86eb3df8714e5dd41bbf9f163d343e1a183d95bf6bd09e4313c940"
  end

  resource "astropy-iers-data" do
    url "https://files.pythonhosted.org/packages/e4/bb/9a4a3cd20da411f801726ece7cce08ea49bc32f37c1211c2ac79ba3185da/astropy_iers_data-0.2024.11.25.0.34.48.tar.gz"
    sha256 "690702c30886e7a3509c4dc39e076c8f94a5cf923c1a49c26455e6d0a5aa5356"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b0/ee/9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1/certifi-2024.8.30.tar.gz"
    sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/25/c2/fc7193cc5383637ff390a712e88e4ded0452c9fbcf84abe3de5ea3df1866/contourpy-1.3.1.tar.gz"
    sha256 "dfd97abd83335045a913e3bcc4a09c0ceadbe66580cf573fe961f4a825efa699"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/ae/29/f71316b9273b6552a263748e49cd7b83898dc9499a663d30c7b9cb853cb8/fastapi-0.115.5.tar.gz"
    sha256 "0e7a4d0dc0d01c68df21887cce0945e72d3c48b9f4f79dfe7a7d53aa08fbb289"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/d7/4e/053fe1b5c0ce346c0a9d0557492c654362bafb14f026eae0d3ee98009152/fonttools-4.55.0.tar.gz"
    sha256 "7636acc6ab733572d5e7eec922b254ead611f1cdad17be3f0be7418e8bfaca71"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/85/4d/2255e1c76304cbd60b48cee302b66d1dde4468dc5b1160e4b7cb43778f2a/kiwisolver-1.4.7.tar.gz"
    sha256 "9893ff81bd7107f7b685d3017cc6583daadb4fc26e4a888350df530e41980a60"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/9e/d8/3d7f706c69e024d4287c1110d74f7dabac91d9843b99eadc90de9efc8869/matplotlib-3.9.2.tar.gz"
    sha256 "96ab43906269ca64a6366934106fa01534454a69e471b7bf3d79083981aaab92"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/25/ca/1166b75c21abd1da445b97bf1fa2f14f423c6cfb4fc7c4ef31dccf9f6a94/numpy-2.1.3.tar.gz"
    sha256 "aa08e04e08aaf974d4458def539dece0d28146d866a39da5639596f4921fd761"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/a5/26/0d95c04c868f6bdb0c447e3ee2de5564411845e36a858cfd63766bc7b563/pillow-11.0.0.tar.gz"
    sha256 "72bacbaf24ac003fea9bff9837d1eedb6088758d41e100c1552930151f677739"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/41/86/a03390cb12cf64e2a8df07c267f3eb8d5035e0f9a04bb20fb79403d2a00e/pydantic-2.10.2.tar.gz"
    sha256 "2bc2d7f17232e0841cbba4641e65ba1eb6fafb3a08de3a091ff3ce14a197c4fa"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/a6/9f/7de1f19b6aea45aeb441838782d68352e71bfa98ee6fa048d5041991b33e/pydantic_core-2.27.1.tar.gz"
    sha256 "62a763352879b84aa31058fc931884055fd75089cccbd9d58bb6afd01141b235"
  end

  resource "pyerfa" do
    url "https://files.pythonhosted.org/packages/71/39/63cc8291b0cf324ae710df41527faf7d331bce573899199d926b3e492260/pyerfa-2.0.1.5.tar.gz"
    sha256 "17d6b24fe4846c65d5e7d8c362dcb08199dc63b30a236aedd73875cc83e1f6c0"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8c/d5/e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2/pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/4c/d2/70fc708727b62d55bc24e43cc85f073039023212d482553d853c44e57bdb/requests-2.29.0.tar.gz"
    sha256 "f2e34a75f4749019bb0e3effb66683630e4ffeaf75819fb51bebef1bf5aef059"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/c3/ea/0fb87f844d8a35ff0dcc8b941e1a9ffc9eb46588ac9e4267b9d9804354eb/requests-unixsocket-0.3.0.tar.gz"
    sha256 "28304283ea9357d45fff58ad5b11e47708cfbf5806817aa59b2a363228ee971e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/1a/4c/9b5764bd22eec91c4039ef4c55334e9187085da2d8a2df7bd570869aae18/starlette-0.41.3.tar.gz"
    sha256 "0e4ab3d16522a255be6b28260b938eae2482f98ce5cc934cb08dce8dc3ba5835"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/6a/3c/21dba3e7d76138725ef307e3d7ddd29b763119b3aa459d02cc05fefcff75/uvicorn-0.32.1.tar.gz"
    sha256 "ee9519c246a72b1c084cea8d3b44ed6026e78a4a309cbedae9c37e4cb9fbb175"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "genreport #{version}", shell_output("#{bin}/genreport -V")
  end
end
