class Cx < Formula
  desc "Fast multi-account switcher and quota dashboard for OpenAI Codex CLI"
  homepage "https://github.com/ecylmz/cx"
  url "https://github.com/ecylmz/cx/archive/refs/tags/v0.8.0.tar.gz"
  version "0.8.0"
  sha256 "f6bac9f2dd429feebe48a6b3a5218c4cf3d0f6d7b186d315924c9dcd323997a7"
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
