class Cx < Formula
  desc "Fast multi-account switcher and quota dashboard for OpenAI Codex CLI"
  homepage "https://github.com/ecylmz/cx"
  url "https://github.com/ecylmz/cx/archive/refs/tags/v0.8.2.tar.gz"
  version "0.8.2"
  sha256 "478a62f2ddb1bd4b45fa6bf20dde2be8b353fcc68a3c5556a3e325a67356ba09"
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
