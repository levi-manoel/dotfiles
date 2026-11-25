#!/usr/bin/env bash
#
# Fora de Cena linux beta. GitHub "latest" skips prereleases, so the version
# is pinned. beta.1 crashes on startup without Pillow's _tkinter_finder.

set -euo pipefail

version="0.5.0-beta.1"
case "$(uname -m)" in
  x86_64)
    asset="ForaDeCena-${version}-linux-x86_64-experimental.tar.gz"
    sha="8edf437f26be1ba7e97bd73cef0184a68ae6e00de2f2e607522c17b7cf2fc613"
    ;;
  aarch64)
    asset="ForaDeCena-${version}-linux-arm64-experimental.tar.gz"
    sha="1accdd9acfd49187235cc3e831d2df904f25ca6dbbdfcade3afd4a5cfcf4fe8e"
    ;;
  *)
    echo "unsupported arch for foradecena: $(uname -m)" >&2
    exit 1
    ;;
esac

if [[ ! -e /usr/lib64/libtcl8.6.so || ! -e /usr/lib64/libtk8.6.so ]]; then
  echo "foradecena: tcl8 and tk8 are required (runs/packages.sh)" >&2
  exit 1
fi
if [[ ! -e /usr/lib64/libbz2.so.1 ]]; then
  echo "foradecena: libbz2.so.1 is missing" >&2
  exit 1
fi

root="${HOME}/.local/opt/ForaDeCena"
installed=""
if [[ -f "${root}/_internal/bundle-build.json" ]]; then
  installed="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("version",""))' "${root}/_internal/bundle-build.json")"
fi

if [[ "${installed}" == "${version}" && -x "${root}/ForaDeCena" ]]; then
  echo "foradecena: ${version} already installed"
else
  tmp="$(mktemp -d)"
  trap 'rm -rf "${tmp}"' EXIT
  url="https://github.com/arantes-gabs/fora-de-cena/releases/download/v${version}/${asset}"
  curl -fL --retry 3 --retry-delay 2 -o "${tmp}/${asset}" "${url}"
  echo "${sha}  ${tmp}/${asset}" | sha256sum -c -
  rm -rf "${root}"
  mkdir -p "${HOME}/.local/opt"
  tar -xzf "${tmp}/${asset}" -C "${HOME}/.local/opt"
  trap - EXIT
  rm -rf "${tmp}"
fi

mkdir -p "${root}/compat"
ln -sfn /usr/lib64/libbz2.so.1 "${root}/compat/libbz2.so.1.0"
rm -f "${root}/compat/libtcl8.6.so" "${root}/compat/libtk8.6.so"

cat > "${root}/_internal/PIL/_tkinter_finder.py" << 'EOF'
"""Find compiled module linking to Tcl / Tk libraries"""

from __future__ import annotations

import sys
import tkinter

tk = getattr(tkinter, "_tkinter")

try:
    if hasattr(sys, "pypy_find_executable"):
        TKINTER_LIB = tk.tklib_cffi.__file__
    else:
        TKINTER_LIB = tk.__file__
except AttributeError:
    TKINTER_LIB = None

tk_version = str(tkinter.TkVersion)
EOF
