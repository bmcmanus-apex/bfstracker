#!/usr/bin/env bash

###################################################################################################
## Installs bazelisk into `/usr/local/bin` and symlinks it to `bazel`.
###################################################################################################

BAZELISK_VERSION="${BAZELISK_VERSION:-"1.11.0"}"
INSTALL_DIR="${INSTALL_DIR:-"/usr/local/bin"}"

# TODO: Windows support
unameOut="$(uname -s)"
case "${unameOut}" in
  Darwin*)  os="darwin";;
  Linux*)   os="linux";;
  *)
    echo "unsupported os: ${unameOut}" >&2
    exit 1
    ;;
esac

unameArch="$(uname -m)"
case "${os}" in
  darwin)
    case "${unameArch}" in
      arm64*) arch="${arch:-arm64}" ;;
      x86_64*) arch="${arch:-amd64}" ;;
      *)
        echo "unsupported architecture: ${unameArch}" >&2
        exit 1
        ;;
    esac
    ;;
  linux)
    case "${unameArch}" in
      aarch64*) arch="arm64" ;;
      x86_64*) arch="amd64" ;;
      *)
        echo "unsupported architecture: ${unameArch}" >&2
        exit 1
        ;;
    esac
    ;;
esac

binary="bazelisk-${os}-${arch}"
echo "Downloading bazelisk v${BAZELISK_VERSION} (${os} ${arch})..." >&2
curl -Lo /tmp/bazelisk "https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/${binary}"
echo "Installing bazelisk into ${INSTALL_DIR}..."
sudo install /tmp/bazelisk "${INSTALL_DIR}/"
echo "Symlinking ${INSTALL_DIR}/bazelisk to ${INSTALL_DIR}/bazel"
sudo ln -sf "${INSTALL_DIR}/bazelisk" "${INSTALL_DIR}/bazel"

echo "Bazelisk installed as ${INSTALL_DIR}/bazel" >&2
echo "If you switched from a previously amd64 build of Bazel, you will need to run 'bazel clean --expunge'"
