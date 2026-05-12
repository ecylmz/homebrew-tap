# ecylmz Homebrew Tap

Homebrew tap for `ecylmz` command-line tools.

## Install

```bash
brew tap ecylmz/tap
```

## Formulae

```bash
brew install ecylmz/tap/xvault
brew install ecylmz/tap/apple-notes-md
```

## Packages

- `xvault` - Local, read-only X/Twitter archive CLI.
- `apple-notes-md` - Local, read-only Apple Notes to Markdown exporter.

## Updating Formulae

Run the `Update Formula` workflow with:

- `formula`: formula name, for example `xvault`
- `tag`: release tag, for example `v0.1.0`
- `repository`: source repository, for example `ecylmz/xvault`
- `artifact_template`: optional asset template, for example `{formula}-{target}.tar.gz`
- `target_aliases`: optional comma-separated target aliases, for example `darwin_amd64=darwin-amd64`

The workflow downloads the release artifacts, recalculates checksums, updates
`Formula/<formula>.rb`, runs the tap tests, and commits the formula change when
needed.

## Update / Uninstall

```bash
brew update
brew upgrade

brew uninstall xvault
brew uninstall apple-notes-md
```

