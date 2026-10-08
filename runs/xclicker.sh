#!/usr/bin/env bash
#
# Install XClicker (X11 autoclicker) as a user AppImage + desktop entry.

set -euo pipefail

arch="$(uname -m)"
case "$arch" in
  x86_64) asset_arch="amd64" ;;
  aarch64) asset_arch="arm64" ;;
  *)
    echo "unsupported arch for xclicker: $arch" >&2
    exit 1
    ;;
esac

api="https://api.github.com/repos/robiot/xclicker/releases/latest"
tag="$(curl -fsSL "$api" | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])')"
version="${tag#v}"
asset="xclicker_${version}_${asset_arch}.AppImage"
url="https://github.com/robiot/xclicker/releases/download/${tag}/${asset}"

apps_dir="${HOME}/Applications"
bin_dir="${HOME}/.local/bin"
desktop_dir="${HOME}/.local/share/applications"
appimage="${apps_dir}/${asset}"
link="${bin_dir}/xclicker"
desktop="${desktop_dir}/xclicker.desktop"

mkdir -p "${apps_dir}" "${bin_dir}" "${desktop_dir}"

curl -fL --retry 3 --retry-delay 2 -o "${appimage}.partial" "${url}"
mv -f "${appimage}.partial" "${appimage}"
chmod +x "${appimage}"

# Drop older versioned AppImages so only the current release remains.
find "${apps_dir}" -maxdepth 1 -type f -name 'xclicker_*.AppImage' ! -name "${asset}" -delete

ln -sfn "${appimage}" "${link}"

cat > "${desktop}" <<EOF
[Desktop Entry]
Name=XClicker
Comment=Fast GUI autoclicker for X11
Exec=${link}
Icon=input-mouse
Terminal=false
Type=Application
Categories=Utility;
EOF
