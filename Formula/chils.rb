class Chils < Formula
  desc "Concurrent Hybrid Iterated Local Search for Maximum Weight Independent Set"
  homepage "https://github.com/KarlsruheMIS/CHILS"
  url "https://github.com/KarlsruheMIS/CHILS/archive/refs/tags/v1.1.tar.gz"
  version "1.1"
  sha256 "81196423fa82640ad80bd9f6d87b9882713fbe8cc9d79ce6e458d1d811c98639"
  license "MIT"

  depends_on "gcc"

  fails_with :clang do
    cause "Requires OpenMP support not available in Apple Clang"
  end

  def install
    inreplace "Makefile", "-march=native", ""

    gcc = Formula["gcc"]
    gcc_cc = "#{gcc.opt_bin}/gcc-#{gcc.version.major}"

    mkdir_p "bin"
    system "make", "CHILS", "CC=#{gcc_cc}"

    bin.install "CHILS"
  end

  test do
    (testpath/"test.gr").write <<~EOS
      3 2 10
      15 3
      15 3
      20 1 2
    EOS
    output = shell_output("#{bin}/CHILS -g #{testpath}/test.gr -t 1.0")
    assert_match "30", output
  end
end
