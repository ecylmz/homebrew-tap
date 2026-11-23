class Cx < Formula
  desc "Fast multi-account switcher and quota dashboard for OpenAI Codex CLI"
  homepage "https://github.com/ecylmz/cx"
  url "https://github.com/ecylmz/cx/archive/refs/tags/v0.11.0.tar.gz"
  version "0.11.0"
  sha256 "3ea06fdc5072de610845cd64be8734ee6c11016f1250843bad3531d3c955fa5e"
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
