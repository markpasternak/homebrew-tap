class TerminalWeather < Formula
  desc "Animated terminal weather dashboard"
  homepage "https://github.com/markpasternak/terminal-weather"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.2.0/terminal-weather-aarch64-apple-darwin.tar.xz"
      sha256 "e681824244f4e95c5cd0244a0806e900f7b1af61d68054a5353c6f74c584cf4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.2.0/terminal-weather-x86_64-apple-darwin.tar.xz"
      sha256 "31cddb4b42463954650f4e5aae4bd7e007cf7e68a55fb79b05e6e57c8d574a31"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.2.0/terminal-weather-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2936adb653e44982a9951f997617dca8b513aa5678538a1cca54706f21629297"
    end
    if Hardware::CPU.intel?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.2.0/terminal-weather-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f65cd44d3b791288f2a5402bd88d5c796eddbb316cf474c5fba24fd5869d8ff8"
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
