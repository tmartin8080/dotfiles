# Dotfiles


```
$ make install

OR

$ make brew
$ make asdf
$ make copy-files
```

## Mac Apps

- [Iterm2](https://iterm2.com/)
- [Alfred](https://www.alfredapp.com/)
- [Magnet](https://apps.apple.com/ca/app/magnet/id441258766?mt=12)
- [DevSwatch](https://apps.apple.com/ca/app/devswatch/id1477857867?mt=12)
- [Magnet](https://apps.apple.com/ca/app/magnet/id441258766?mt=12)

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
- using nvim-treesitter, (except for elixir, there's an issue)
