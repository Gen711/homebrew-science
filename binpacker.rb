class Binpacker < Formula
  desc "Packing-Based De Novo Transcriptome Assembly from RNA-seq Data"
  homepage "https://sourceforge.net/projects/transcriptomeassembly/"
  url "https://downloads.sourceforge.net/project/transcriptomeassembly/BinPacker_1.1.tar.gz"
  sha256 "b80becf74d9c2c5e8ee158932b45cb5ba58e44f1f7ae7ce6ecda41d03c7b1b1f"
  # doi "10.1371/journal.pcbi.1004772"
  # tag "bioinformatics"

  depends_on "boost"

  fails_with :clang do
    build 703
    cause "error: assigning to 'void *' from incompatible type"
  end

  fails_with :gcc => "5" do
    cause "configure: error: invalid value: boost_major_version="
  end

  fails_with :gcc => "6" do
    cause "configure: error: invalid value: boost_major_version="
  end

  def install
    # Fix for Mac OS error: ld: unknown option: -R
    inreplace "./configure", "-Wl,-R", "-Wl,-rpath,"

    # Fix for Mac OS error: 'bits/typesizes.h' file not found
    inreplace "src/common.h", "#include <bits/typesizes.h>", ""
    inreplace "src/common.h", "#include <bits/types.h>", ""

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "-C", "src", "install"

    # Test
    system "./run_Me.sh"

    bin.install "BinPacker"
    doc.install "AUTHORS", "ChangeLog", "README", "run_Me.sh", "sample_test"
  end

  test do
    assert_match "version", shell_output("#{bin}/BinPacker -v", 1)
  end
end
