class TerminalWeather < Formula
  desc "Animated terminal weather dashboard"
  homepage "https://github.com/markpasternak/terminal-weather"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.5.2/terminal-weather-aarch64-apple-darwin.tar.xz"
      sha256 "5f683e587ec3fd3957413b67daaa19cc6db86db99b1147a1e8947eecc1a06461"
    end
    if Hardware::CPU.intel?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.5.2/terminal-weather-x86_64-apple-darwin.tar.xz"
      sha256 "dcbe32d1cd3d1125522257f8b972d391c296a5fdfb83ddf8e7024d52d42cc7b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.5.2/terminal-weather-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cdbb148d87338a50b2e21fb5f8d3450daa8a7e56c2a16f6f9e1b04fecb1a4759"
    end
    if Hardware::CPU.intel?
      url "https://github.com/markpasternak/terminal-weather/releases/download/v0.5.2/terminal-weather-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "04b6915a73e2a42100d78b5cb12cf159a2d28ca91ad50ea37bd510e4ec95d921"
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
