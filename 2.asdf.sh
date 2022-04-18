#!/usr/bin/env bash

asdf plugin add python
asdf plugin add erlang
asdf plugin add elixir
asdf plugin add neovim
asdf plugin add golang
asdf plugin add terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf plugin add helm https://github.com/Antiarchitect/asdf-helm.git
asdf plugin add postgres
asdf plugin add nodejs
asdf plugin update --all

asdf install
