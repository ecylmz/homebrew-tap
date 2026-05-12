class Xvault < Formula
  desc "Local, read-only X/Twitter archive CLI"
  homepage "https://github.com/ecylmz/xvault"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.0/xvault-darwin-arm64.tar.gz"
      sha256 "65ea1bfd0ecad16e97253a5190ff994d0a59d487745c702d325630811ff900be"
    else
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.0/xvault-darwin-amd64.tar.gz"
      sha256 "56b33d283d143b460f035556338bb38462c16c6fda84fea2fe1faf6bd9438bed"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.0/xvault-linux-arm64.tar.gz"
      sha256 "4edd7537ea55d8f8f06493971044f2f9b6718fef66373abfcac1b4452803b738"
    else
      url "https://github.com/ecylmz/xvault/releases/download/v0.1.0/xvault-linux-amd64.tar.gz"
      sha256 "32a98f66fd8007e344308478df17f138b64fb5c8f888e654597a743dde60305e"
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
