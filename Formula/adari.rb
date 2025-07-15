class Adari < Formula
  include Language::Python::Virtualenv

  desc "Astronomical DAta Reporting Infrastructure"
  homepage "https://www.eso.org/sci/software/pipelines/index.html"
  url "https://ftp.eso.org/pub/dfs/pipelines/repositories/stable/src/adari_core/adari_core-3.0.0.tar.gz"
  sha256 "aec1bae4affa39654431abeae8dbe4bedf025fa0926be0b6286f532b06ed0b73"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/repositories/stable/src/adari_core/"
    regex(/href=.*?adari_core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/eso/homebrew-pipelines/releases/download/adari-3.0.0"
    sha256 cellar: :any,                 arm64_sequoia: "7773356bac2f860b76629ee393e59d40643bfa667ef5f978f06a08bc6b5c0964"
    sha256 cellar: :any,                 arm64_sonoma:  "833f49f1c93e1cedc9c42235c77efc264d485de68e2f7b642b6396bd82849c76"
    sha256 cellar: :any,                 ventura:       "ab3e3d2ca931edce8ca7696f53ae5f2cf01e310d8c490f78e545a71285a7b6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d7acda9556cfb84a3df1087f06101cf115e155fd294bef92541c504a20415b7"
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
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "astropy" do
    url "https://files.pythonhosted.org/packages/83/91/124d020cea78e4e4b6db7ff726c2c2e4a5865293d0a4355d13b0312d99f1/astropy-7.1.0.tar.gz"
    sha256 "c8f254322295b1b8cf24303d6f155bf7efdb6c1282882b966ce3040eff8c53c5"
  end

  resource "astropy-iers-data" do
    url "https://files.pythonhosted.org/packages/83/08/7e0be27f3748240e88ec86c7a01717163d5c92ef0bbbdf2f781903745bd8/astropy_iers_data-0.2025.7.14.0.40.29.tar.gz"
    sha256 "2d2446eda1bb26a92b9235b67cee584f86e02afec27ad7a0edfc296e891dd820"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b3/76/52c535bcebe74590f296d6c77c86dabf761c41980e1347a2422e4aa2ae41/certifi-2025.7.14.tar.gz"
    sha256 "8ea99dbdfaaf2ba2f9bac77b9249ef62ec5218e7c2b2e903378ed5fccf765995"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/66/54/eb9bfc647b19f2009dd5c7f5ec51c4e6ca831725f1aea7a993034f483147/contourpy-1.3.2.tar.gz"
    sha256 "b6945942715a034c671b7fc54f9588126b0b8bf23db2696e3ca8328f3ff0ab54"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/78/d7/6c8b3bfe33eeffa208183ec037fee0cce9f7f024089ab1c5d12ef04bd27c/fastapi-0.116.1.tar.gz"
    sha256 "ed52cbf946abfd70c5a0dccb24673f0670deeb517a88b3544d03c2a6bf283143"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/52/97/5735503e58d3816b0989955ef9b2df07e4c99b246469bd8b3823a14095da/fonttools-4.58.5.tar.gz"
    sha256 "b2a35b0a19f1837284b3a23dd64fd7761b8911d50911ecd2bdbaf5b2d1b5df9c"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/82/59/7c91426a8ac292e1cdd53a63b6d9439abd573c875c3f92c146767dd33faf/kiwisolver-1.4.8.tar.gz"
    sha256 "23d5f023bdc8c7e54eb65f03ca5d5bb25b601eac4d7f1a042888a1f45237987e"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/26/91/d49359a21893183ed2a5b6c76bec40e0b1dcbf8ca148f864d134897cfc75/matplotlib-3.10.3.tar.gz"
    sha256 "2f82d2c5bb7ae93aaaa4cd42aca65d76ce6376f83304fa3a630b569aca274df0"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/2e/19/d7c972dfe90a353dbd3efbbe1d14a5951de80c99c9dc1b93cd998d51dc0f/numpy-2.3.1.tar.gz"
    sha256 "1ec9ae20a4226da374362cca3c62cd753faf2f951440b0e3b98e93c235441d2b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/f3/0d/d0d6dea55cd152ce3d6767bb38a8fc10e33796ba4ba210cbab9354b6d238/pillow-11.3.0.tar.gz"
    sha256 "3828ee7586cd0b2091b6209e5ad53e20d0649bbe87164a459d0676e035e8f523"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pyerfa" do
    url "https://files.pythonhosted.org/packages/71/39/63cc8291b0cf324ae710df41527faf7d331bce573899199d926b3e492260/pyerfa-2.0.1.5.tar.gz"
    sha256 "17d6b24fe4846c65d5e7d8c362dcb08199dc63b30a236aedd73875cc83e1f6c0"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
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
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-unixsocket2" do
    url "https://files.pythonhosted.org/packages/e3/7b/8f398d91382a2bbae06530389f74d6296a4da04827144a3015f34b7d82c4/requests_unixsocket2-1.0.0.tar.gz"
    sha256 "8c6cad0326369658db931b4c36f03cd1cccb7668e081e7fb3972b500a93bb563"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/0a/69/662169fdb92fb96ec3eaee218cf540a629d629c86d7993d9651226a6789b/starlette-0.47.1.tar.gz"
    sha256 "aef012dd2b6be325ffa16698f9dc533614fb1cebd593a906b90dc1025529a79b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/5e/42/e0e305207bb88c6b8d3061399c6a961ffe5fbb7e2aa63c9234df7259e9cd/uvicorn-0.35.0.tar.gz"
    sha256 "bc662f087f7cf2ce11a1d7fd70b90c9f98ef2e2831556dd078d131b96cc94a01"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "genreport #{version}", shell_output("#{bin}/genreport -V")
  end
end
