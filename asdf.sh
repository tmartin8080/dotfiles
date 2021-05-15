#!/usr/bin/env bash

PYTHON_VERSION=3.9.5
asdf plugin-add python
asdf install python $PYTHON_VERSION
asdf global python $PYTHON_VERSION
asdf local python $PYTHON_VERSION
asdf reshim python

ERLANG_VERSION=24.0

asdf plugin-add erlang
# https://github.com/erlang/otp/issues/4821#issuecomment-840051976
EGREP=egrep CC=clang CPP="clang -E" KERL_USE_AUTOCONF=0 KERL_CONFIGURE_OPTIONS="--disable-hipe --disable-sctp --enable-darwin-64bit --enable-kernel-poll --enable-shared-zlib --enable-smp-support --enable-threads --enable-wx --with-ssl=$(brew --prefix openssl) --without-docs --without-javac --without-jinterface --without-odbc" asdf install erlang $ERLANG_VERSION
asdf global erlang $ERLANG_VERSION
asdf local erlang $ERLANG_VERSION
asdf reshim erlang

ELIXIR_VERSION=1.11.4-otp-24
asdf plugin-add elixir
asdf install elixir $ELIXIR_VERSION
asdf global elixir $ELIXIR_VERSION
asdf local elixir $ELIXIR_VERSION
asdf reshim elixir
