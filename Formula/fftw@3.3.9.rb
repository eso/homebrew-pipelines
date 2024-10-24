class FftwAT339 < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "https://fftw.org"
  url "https://fftw.org/fftw-3.3.9.tar.gz"
  sha256 "bf2c7ce40b04ae811af714deb512510cc2c17b9ab9d6ddcf49fe4487eea7af3d"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  revision 1

  livecheck do
    url :homepage
    regex(%r{latest official release.*? <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-pipelines/releases/download/fftw@3.3.9-3.3.9_1"
    sha256 cellar: :any,                 arm64_sonoma: "4dcad3f0d956d9a64d1aa3a2b8fada0753d2fd4b199600cd981b7fa3618c04f5"
    sha256 cellar: :any,                 ventura:      "e2775cf826ab444cb0598da60b45a529f8da0c2daf19bf807310b710da91527a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f1d5554d9933cbdeff393de3f6b3e742e89c8fabe023581ab156e8d3e08b932d"
  end

  keg_only :versioned_formula

  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang

  def install
    args = [
      "--enable-shared",
      "--disable-debug",
      "--prefix=#{prefix}",
      "--enable-threads",
      "--disable-dependency-tracking",
      "--enable-mpi",
      "--enable-openmp",
    ]

    # FFTW supports runtime detection of CPU capabilities, so it is safe to
    # use with --enable-avx and the code will still run on all CPUs
    simd_args = []
    simd_args << "--enable-sse2" << "--enable-avx" if Hardware::CPU.intel?

    # single precision
    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "./configure", "--enable-single", *(args + simd_args)
    system "make", "install"

    # clean up so we can compile the double precision variant
    system "make", "clean"

    # double precision
    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "./configure", *(args + simd_args)
    system "make", "install"

    # clean up so we can compile the long-double precision variant
    system "make", "clean"

    # long-double precision
    # no SIMD optimization available
    system "./configure", "--enable-long-double", *args
    system "make", "install"
  end

  test do
    # Adapted from the sample usage provided in the documentation:
    # https://www.fftw.org/fftw3_doc/Complex-One_002dDimensional-DFTs.html
    (testpath/"fftw.c").write <<~EOS
      #include <fftw3.h>
      int main(int argc, char* *argv)
      {
          fftw_complex *in, *out;
          fftw_plan p;
          long N = 1;
          in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
          out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
          p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
          fftw_execute(p); /* repeat as needed */
          fftw_destroy_plan(p);
          fftw_free(in); fftw_free(out);
          return 0;
      }
    EOS

    system ENV.cc, "-o", "fftw", "fftw.c", "-L#{lib}", "-lfftw3"
    system "./fftw"
  end
end
