class Cx < Formula
  desc "Fast multi-account switcher and quota dashboard for OpenAI Codex CLI"
  homepage "https://github.com/ecylmz/cx"
  url "https://github.com/ecylmz/cx/archive/refs/tags/v0.7.0.tar.gz"
  version "0.7.0"
  sha256 "2e6001995b4b6cb3300db539d131ba389a63c165f6f0a996e9067a2ee22edd8a"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ecylmz/cx/internal/cx.Version=#{version}"
    system("go", "build", *std_go_args(ldflags:), "./cmd/cx")
  end

  test do
    assert_match "cx #{version}", shell_output("#{bin}/cx version")
  end
end
