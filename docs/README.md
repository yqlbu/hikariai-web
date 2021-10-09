# Hugo Basic Usage

## Installation

```bash
brew install hugo
brew help
hugo env
```

## Basic Usage

<details><summary>Create a new site</summary>

</br>

```bash
hugo new site web
cd web
vim config.toml
---
baseURL = "http://xxx.example.org"
languageCode = "en-us"
title = "xxx"
---
```

</p></details>

<details><summary>Configure Theme</summary>

</br>

```bash
git clone <theme source> themes/<theme name>
rm -rf themes/<theme name>/.git
cp -r themes/<theme name>/exampleSite/config.toml ./
```

</p></details>

<details><summary>Generate Contents on Page</summary>

</br>

```bash
vim archetypes/default.md
---
This is my page.
blah blah
blah blah blah
---
hugo new posts/page1.md
hugo new posts/page2.md
hugo new posts/page3.md
```

</p></details>

<details><summary>Generate Static Files</summary>

</br>

```bash
hugo
ls -l public/
```

</p></details>

## Advanced Usage

<details><summary>Configure Syntax Highligter</summary>

</br>

reference:

- https://gohugo.io/content-management/syntax-highlighting/#generate-syntax-highlighter-css
- https://xyproto.github.io/splash/docs/

Add the following config to `config.toml`

```config
# Syntax Highlight
[markup]
  [markup.highlight]
    anchorLineNos = false
    codeFences = true
    guessSyntax = false
    hl_Lines = ''
    lineAnchors = ''
    lineNoStart = 1
    lineNos = false
    lineNumbersInTable = true
    noClasses = true
    style = 'emacs'
    tabWidth = 4
```

</p></details>

<details><summary>Configure TableOfContents</summary>

</br>

reference:

- https://gohugo.io/getting-started/configuration-markup#table-of-contents

Add the following config to `config.toml`

```config
[markup.tableOfContents]
  endLevel = 3
  ordered = false
  startLevel = 2
```

</p></details>

### Use Hugo Http Server

Use `Hugo` built in `Http Server` to serve contents

```bash
hugo server -D --bind <server ip address> --baseURL http://<server ip address>
```

### Rerences

- [Hugo Official Docs](https://gohugo.io/documentation/)
