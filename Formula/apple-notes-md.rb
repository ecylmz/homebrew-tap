class AppleNotesMd < Formula
  desc "Local, read-only Apple Notes to Markdown exporter"
  homepage "https://github.com/ecylmz/apple-notes-md"
  version "0.1.1"
  license "MIT"

  depends_on :macos

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ecylmz/apple-notes-md/releases/download/v0.1.1/apple-notes-md_Darwin_arm64.tar.gz"
      sha256 "988b860bce2a76ed367195e56f5c171aa429abac7f275f963f053babdb3c5625"
    else
      url "https://github.com/ecylmz/apple-notes-md/releases/download/v0.1.1/apple-notes-md_Darwin_x86_64.tar.gz"
      sha256 "e186b925f35b2bae750a244665e0566ded45c7eb6c1edf1eb82673392989468c"
    end
  end

  def install
    bin.install "apple-notes-md"
    prefix.install "LICENSE"
    prefix.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apple-notes-md --version")
  end
end
