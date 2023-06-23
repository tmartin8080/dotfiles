#!/usr/bin/env bash

set -e

asdf plugin add python || true
asdf plugin add erlang || true
asdf plugin add elixir || true
asdf plugin add neovim || true
asdf plugin add golang || true
asdf plugin add terraform https://github.com/asdf-community/asdf-hashicorp.git || true
asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git || true
asdf plugin add helm https://github.com/Antiarchitect/asdf-helm.git || true
asdf plugin-add rust https://github.com/asdf-community/asdf-rust.git || true
asdf plugin add postgres || true
asdf plugin add nodejs || true

asdf plugin update --all

export KERL_CONFIGURE_OPTIONS="--disable-debug \
    --disable-silent-rules \
    --enable-dynamic-ssl-lib \
    --enable-hipe \
    --enable-shared-zlib \
    --enable-smp-support \
    --enable-threads \
    --enable-wx \
    --with-ssl=$(brew --prefix openssl@1.1) \
    --without-javac
    --enable-darwin-64bit \
    --enable-kernel-poll \
    --with-dynamic-trace=dtrace"

asdf install erlang

asdf install
