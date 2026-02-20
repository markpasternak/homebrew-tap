class TerminalWeather < Formula
  desc "Animated terminal weather dashboard"
  homepage "https://github.com/markpasternak/terminal-weather"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.5.0/terminal-weather-aarch64-apple-darwin.tar.xz"
      sha256 "a1cff1d3ec4e84baed5b7ba24abdeea60796b1b455f23f8cb45622982dc930fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.5.0/terminal-weather-x86_64-apple-darwin.tar.xz"
      sha256 "9dcbe67aff123a3aa751f5860f3dea742e1aa273ba3ae35de2f90ea2ac0daa0e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.5.0/terminal-weather-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "994454681c6c8c8f12863f2d86a48dcf517ea0b8c905d7c3b78d0260e636e7fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.5.0/terminal-weather-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "40c96f80c71253354b091ba846e51bc9e75b105a1c729775323fa09fa06df7d5"
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
