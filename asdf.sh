#!/usr/bin/env bash

PYTHON3_VERSION=3.9.5
PYTHON_VERSION=2.7.18
ERLANG_VERSION=24.1.7
ELIXIR_VERSION=1.12.3-otp-24
NEOVIM_VERSION=nightly
GOLANG_VERSION=1.16.5
TERRAFORM_VERSION=1.0.1
KUBECTL_VERSION=1.21.2
HELM_VERSION=3.6.1

asdf plugin-add python
asdf install python $PYTHON3_VERSION
asdf install python $PYTHON_VERSION
asdf global python $PYTHON3_VERSION $PYTHON_VERSION
asdf local python $PYTHON3_VERSION $PYTHON_VERSION
asdf reshim python
pip install --user neovim
pip2 install --user neovim

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
asdf install neovim ref:master
asdf global neovim $NEOVIM_VERSION
asdf reshim neovim

asdf plugin add golang
asdf install golang $GOLANG_VERSION
asdf global golang $GOLANG_VERSION
asdf reshim golang

asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf install terraform $TERRAFORM_VERSION
asdf global terraform $TERRAFORM_VERSION
asdf reshim terraform

asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf install kubectl $KUBECTL_VERSION
asdf global kubectl $KUBECTL_VERSION
asdf reshim kubectl

asdf plugin-add helm https://github.com/Antiarchitect/asdf-helm.git
asdf install helm $HELM_VERSION
asdf global helm $HELM_VERSION
asdf reshim helm
