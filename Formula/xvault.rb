class Xvault < Formula
  desc "Local, read-only X/Twitter archive CLI"
  homepage "https://github.com/ecylmz/xvault"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.1/xvault-darwin-arm64.tar.gz"
      sha256 "554d5a93dd29de00fdd56b69b7d4170d400a8e96e55a626aea42cd34d684216a"
    else
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.1/xvault-darwin-amd64.tar.gz"
      sha256 "9dc14bbff97d6a7e1676c362ea3f2fb79acfbf69519f3728a7c9ff91193f53e5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.1/xvault-linux-arm64.tar.gz"
      sha256 "199770f0053705a9270158af3478626b8448df7b427846e72c712972a548123b"
    else
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.1/xvault-linux-amd64.tar.gz"
      sha256 "7671f5462cc50afc97445ded174eb2220c3cf5ef8e52c8ebcdb9ee001412ee25"
    end
  end

  def install
    bin.install "xvault"
    prefix.install "LICENSE"
    prefix.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xvault version")
  end
end
