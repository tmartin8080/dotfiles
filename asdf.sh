#!/usr/bin/env bash

PYTHON_VERSION=3.9.5
ERLANG_VERSION=24.0.2
ELIXIR_VERSION=1.12.1-otp-24
NEOVIM_VERSION=nightly

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

asdf plugin add neovim
asdf install neovim $NEOVIM_VERSION
asdf global neovim $NEOVIM_VERSION
asdf reshim neovim
