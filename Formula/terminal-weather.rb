class TerminalWeather < Formula
  desc "Animated terminal weather dashboard"
  homepage "https://github.com/markpasternak/terminal-weather"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.1.0/terminal-weather-aarch64-apple-darwin.tar.xz"
      sha256 "db3e094a61cd2415cb87547544b9d50df06eec0b16d805c8b26a9cd55bfad413"
    end
    if Hardware::CPU.intel?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.1.0/terminal-weather-x86_64-apple-darwin.tar.xz"
      sha256 "3041a9981cdb0951ae57b6b936d81721596cbb9fe51f0dc5df02ab0a5e070eb1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.1.0/terminal-weather-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "37efe4ac53912a52749bbfb77e13b08b3759bbadf6fa5eb9b20781f531df52e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.1.0/terminal-weather-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b78c25d3dfb11c384d6616120dd23eec7843b67388d1ecf4c6a94fd287cee671"
    end
  end
  license "MIT"

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
