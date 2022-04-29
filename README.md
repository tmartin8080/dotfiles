# Dotfiles

```
$ make setup

OR

$ make init
$ make brew
$ make asdf
$ make copy-files
```

## Mac Apps

- [Iterm2](https://iterm2.com/)
- [Alfred](https://www.alfredapp.com/)
- [Magnet](https://apps.apple.com/ca/app/magnet/id441258766?mt=12)
- [DevSwatch](https://apps.apple.com/ca/app/devswatch/id1477857867?mt=12)

## Iterm2

1. Load profile from `iterm2/devato.json`
2. Preferences -> Appearance -> General -> Theme -> Minimal
3. BG Color: 2B2D36

## Language Servers

From within nvim:
```
:LspInstall bash
:LspInstall elixir
:LspInstall efm
```

## WRK

```
brew install wrk
wrk -t4 -c100 -d30S --timeout 2000 "http://127.0.0.1:4000"
```

## Syntax highlighting
- using nvim-treesitter 

# wxwidgets brew issue

- https://github.com/asdf-vm/asdf-erlang/issues/248
- https://github.com/erlang/otp/issues/5893
- https://remarkablemark.org/blog/2017/02/03/install-brew-package-version/
- https://github.com/erlang/otp/commit/c2eb69239622046093c25e986dd606ea339c59a9
- https://stackoverflow.com/a/67656458
- https://stackoverflow.com/questions/13477363/how-can-i-brew-link-a-specific-version

# workaround for wxwidgets issue
```
brew install wxwidgets
brew unlink wxwidgets
brew tap laggardkernel/tap
wget https://raw.githubusercontent.com/Homebrew/homebrew-core/7d7daebdadd1b7badf56bd87bce75f38e51c5795/Formula/wxwidgets.rb
brew install ./wxwidgets.rb
brew switch wxwidgets 3.1.5
brew pin wxwidgets
```

