class Doorman < Formula
  desc "Front any static-token or no-auth HTTP service with the OAuth 2.1 flow Claude requires — in one binary. No IdP, no database."
  homepage "https://github.com/sebasv/doorman"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sebasv/doorman/releases/download/v0.2.0/doorman-aarch64-apple-darwin.tar.xz"
      sha256 "ea6d16ad463ac62dd6748743043252996c975a091d9eb151f65e2bdd69b3b0b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sebasv/doorman/releases/download/v0.2.0/doorman-x86_64-apple-darwin.tar.xz"
      sha256 "54c034c73bb12c351bd0f9e029f5a7407ee09101ef45ceecc790b6ad46a742ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sebasv/doorman/releases/download/v0.2.0/doorman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f5c812f76f40231237669faea765013258b715d9f3388057eb373ffdf448cb0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sebasv/doorman/releases/download/v0.2.0/doorman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5099c825d7eb4b0de36ae1a465d6b3d0b41cf7a71f1bb6a2fdcef30fcbad379f"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "doorman" if OS.mac? && Hardware::CPU.arm?
    bin.install "doorman" if OS.mac? && Hardware::CPU.intel?
    bin.install "doorman" if OS.linux? && Hardware::CPU.arm?
    bin.install "doorman" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
