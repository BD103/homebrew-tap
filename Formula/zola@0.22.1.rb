class ZolaAT0221 < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "0f59479e05bce79e8d5860dc7e807ea818986094469ed8bf0bb46588ade95982"
  license "EUPL-1.2"

  bottle do
    root_url "https://github.com/BD103/homebrew-tap/releases/download/zola@0.22.1-0.22.1"
    sha256 cellar: :any, arm64_tahoe:  "f3bc231230e9d8233046f5144f10a3a78e3da5ad8542156bec11fefe1ff960d7"
    sha256 cellar: :any, x86_64_linux: "49a166fd5595cfc19f5111e73791206fd8a12e36748606516e7b0058da3c4492"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma" # for onig_sys

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", *std_cargo_args(features: "native-tls")

    generate_completions_from_executable(bin/"zola", "completion")
  end

  test do
    system "yes '' | #{bin}/zola init mysite"
    (testpath/"mysite/content/blog/_index.md").write <<~MARKDOWN
      +++
      +++

      Hi I'm Homebrew.
    MARKDOWN
    (testpath/"mysite/templates/section.html").write <<~HTML
      {{ section.content | safe }}
    HTML

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end
