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
pygmentsUseClasses = true
# Syntax Highlight
[markup.highlight]
  anchorLineNos = false
  codeFences = true
  guessSyntax = true
  hl_Lines = ''
  lineAnchors = ''
  lineNoStart = 1
  lineNos = true
  lineNumbersInTable = false
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

<details><summary>Apply Custom CSS</summary>

</br>

reference: https://mcneilcode.com/post/web/hugo/hugo-adding-custom-css-js-themes/

### Overview

It is possible to extend any theme without modifying it directly, thanks to the order preference feature of Hugo theme loader. By staging a custom version of any file found in your third party theme, you can override it and extend it with any feature you may need.

The example we will use here is for a theme that may not provide a way to load a custom CSS or Javascript from the static folder into your site natively.

### Procedure

1. Stage your files into the static, if not already done. They should live in the `static` folder. You should have:

```bash
static/css/custom.css
static/js/custom.js
```

2. Add configuration parameters for custom css/js in `config.toml`:

```bash
[params]
...
customCSS = ["css/custom.css"]
customJS = ["js/custom.js"]
```

3. Copy the head.html from your preferred theme, into your local project:

```bash
mkdir -p layouts/partials
cp themes/<theme_name>/layouts/partials/head.html layouts/partials/
```

4. Extend the local version of head.html to load the custom scripts:

```bash
<!-- css -->
{{ range .Site.Params.customCSS -}}
    <link rel="stylesheet" href="{{ . | absURL }}">
{{- end }}

<!-- javascript -->
{{ range .Site.Params.customJS -}}
    <script type="text/javascript" src="{{ . | absURL }}"></script>
{{- end }}
```

Now your site will load these custom files in addition to all the other files needed for the theme.

</p></details>

### Use Hugo Http Server

Use `Hugo` built in `Http Server` to serve contents

```bash
hugo server -D --bind <server ip address> --baseURL http://<server ip address>
```

### Rerences

- [Hugo Official Docs](https://gohugo.io/documentation/)
