class Xvault < Formula
  desc "Local, read-only X/Twitter archive CLI"
  homepage "https://github.com/ecylmz/xvault"
  version "0.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.2/xvault-darwin-arm64.tar.gz"
      sha256 "f2831e9a8b3da1aa39d82854f164135610ac02752bf7e9be6ca8abc143f77202"
    else
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.2/xvault-darwin-amd64.tar.gz"
      sha256 "34f054cd410483e3345aa7dbb8c05aeb486a8ad6cf99dfb8e5ae0240485d7062"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.2/xvault-linux-arm64.tar.gz"
      sha256 "f6c46f7eda89d3d4f5ed0db1a27ee78e536f31fb26f97e99053d18d4aae58af5"
    else
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.2/xvault-linux-amd64.tar.gz"
      sha256 "60f77e029a920de136404e7ea2a4d1d37bdc63135cc8446c71d3430d31d5eeb5"
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
