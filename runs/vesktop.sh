#!/usr/bin/env bash

set -euo pipefail

arch="$(uname -m)"
case "$arch" in
  x86_64|aarch64) ;;
  *)
    echo "unsupported arch for vesktop: $arch" >&2
    exit 1
    ;;
esac

api="https://api.github.com/repos/Vencord/Vesktop/releases/latest"
tag="$(curl -fsSL "$api" | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])')"
version="${tag#v}"
rpm_url="https://github.com/Vencord/Vesktop/releases/download/${tag}/vesktop-${version}.${arch}.rpm"

sudo dnf install -y "$rpm_url"
