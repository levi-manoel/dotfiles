#!/usr/bin/env bash

set -euo pipefail

arch="$(uname -m)"
case "$arch" in
  x86_64) ;;
  *)
    echo "unsupported arch for fastpotify flatpak: $arch" >&2
    exit 1
    ;;
esac

# Drop legacy clients if present (idempotent).
if flatpak info com.spotify.Client >/dev/null 2>&1; then
  flatpak uninstall -y --user com.spotify.Client 2>/dev/null || true
  flatpak uninstall -y --system com.spotify.Client 2>/dev/null || true
fi
if command -v spotatui >/dev/null 2>&1 || [[ -x "${HOME}/.cargo/bin/spotatui" ]]; then
  # shellcheck disable=SC1091
  [[ -f "${HOME}/.cargo/env" ]] && . "${HOME}/.cargo/env"
  cargo uninstall spotatui 2>/dev/null || rm -f "${HOME}/.cargo/bin/spotatui"
fi
if rpm -q spotify-client >/dev/null 2>&1; then
  sudo dnf remove -y spotify-client spotify-ffmpeg || true
fi

api="https://api.github.com/repos/crmne/fastpotify/releases/latest"
tag="$(curl -fsSL "$api" | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])')"
version="${tag#v}"
asset="fastpotify-v${version}-x86_64.flatpak"
url="https://github.com/crmne/fastpotify/releases/download/${tag}/${asset}"
dest="${HOME}/Downloads/${asset}"

mkdir -p "${HOME}/Downloads"
curl -fL --retry 3 --retry-delay 2 -o "${dest}.partial" "${url}"
mv -f "${dest}.partial" "${dest}"

flatpak install --user -y "${dest}"
