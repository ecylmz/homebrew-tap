class Cx < Formula
  desc "Fast multi-account switcher and quota dashboard for OpenAI Codex CLI"
  homepage "https://github.com/ecylmz/cx"
  url "https://github.com/ecylmz/cx/archive/refs/tags/v0.9.0.tar.gz"
  version "0.9.0"
  sha256 "cf3576405c4ff48eb22a021f9f8c9549e26ca6a2ac2b6c3ffd95ac0d4b09b876"
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
