#!/usr/bin/env bash

PYTHON_VERSION=3.9.5
ERLANG_VERSION=24.0.1
ELIXIR_VERSION=1.12.0-otp-24

asdf plugin-add python
asdf install python $PYTHON_VERSION
asdf global python $PYTHON_VERSION
asdf local python $PYTHON_VERSION
asdf reshim python
pip install --user neovim

asdf plugin-add erlang
asdf install erlang $ERLANG_VERSION
asdf global erlang $ERLANG_VERSION
asdf local erlang $ERLANG_VERSION
asdf reshim erlang

asdf plugin-add elixir
asdf install elixir $ELIXIR_VERSION
asdf global elixir $ELIXIR_VERSION
asdf local elixir $ELIXIR_VERSION
asdf reshim elixir
