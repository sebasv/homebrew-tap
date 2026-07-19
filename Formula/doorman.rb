class Doorman < Formula
  desc "Front any static-token or no-auth HTTP service with the OAuth 2.1 flow Claude requires — in one binary. No IdP, no database."
  homepage "https://github.com/sebasv/doorman"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sebasv/doorman/releases/download/v0.1.0/doorman-aarch64-apple-darwin.tar.xz"
      sha256 "8a28b0386716312e909a973d7d71e468ae7570d28c08dee7467c683625d574ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sebasv/doorman/releases/download/v0.1.0/doorman-x86_64-apple-darwin.tar.xz"
      sha256 "d0d6e04d8433297327bd5ce7237d807949263f30c2dad9d6f1ec6308b8872cb3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sebasv/doorman/releases/download/v0.1.0/doorman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1f2583ef1754b2a194ea6db6bf20320d5194a1ca612d714dbeca9480d7b0fa04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sebasv/doorman/releases/download/v0.1.0/doorman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "415b021dd59177eaa679548e1a3da16440abf430a27624adaf761059a19f4c6d"
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
