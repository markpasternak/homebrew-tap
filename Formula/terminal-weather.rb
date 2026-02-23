class TerminalWeather < Formula
  desc "Animated terminal weather dashboard"
  homepage "https://github.com/markpasternak/terminal-weather"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.7.0/terminal-weather-aarch64-apple-darwin.tar.xz"
      sha256 "5a70bcf9bd0b67129b503a06cd5f77936e0efe7c8926d41b91c0fc04d75d8354"
    end
    if Hardware::CPU.intel?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.7.0/terminal-weather-x86_64-apple-darwin.tar.xz"
      sha256 "3e9012d2e9e1f2c4bbedc0f939aa5fc1ef459b2fb0f0f0bf26aa0b4044fb2e38"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.7.0/terminal-weather-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4c0f43ad819f3f42fff5f1dcb09ab6aa00bb908213f221c6a55751c6282774a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.7.0/terminal-weather-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5d4548fd8297cce1a1745506de1f3d01dea9b51797fe958413bb1762e37304c1"
    end
  end
  license "GPL-3.0-only"

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
    bin.install "terminal-weather" if OS.mac? && Hardware::CPU.arm?
    bin.install "terminal-weather" if OS.mac? && Hardware::CPU.intel?
    bin.install "terminal-weather" if OS.linux? && Hardware::CPU.arm?
    bin.install "terminal-weather" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
