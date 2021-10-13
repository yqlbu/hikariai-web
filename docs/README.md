# Hugo Usage

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
- https://gohugo.io/getting-started/configuration-markup#highlight

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

#### Highlight specific linenumbers

In the content page, add the following snippets:

````config
```go {linenos=true,hl_lines=[1,"3-5"],linenostart=1}
// ... code
```
````

</p></details>

<details><summary>Disable Copy for Linenumbers in Codeblock</summary>

</br>

reference:

- https://gohugo.io/content-management/syntax-highlighting/
- https://discourse.gohugo.io/t/pygmentsuseclasses-true-not-generating-classes/15080/3

#### Enable Custom CSS

Follow the instructions written in this [link](https://mcneilcode.com/post/web/hugo/hugo-adding-custom-css-js-themes/)

#### Generate Syntax CSS

Checkout the available highlighter options [HERE](https://xyproto.github.io/splash/docs/)

Run the following commands to generate the syntax css

```bash
hugo gen chromastyles --style=<style name> > syntax.css
```

Copy the CSS file to `static/css`

```bash
mkdir -p static/css
cp syntax.css static/css
```

#### Modify CSS Configuration

In `static/css/syntax.css`, find the class `.chroma .ln`, add `user-select: none`

```css
/* LineNumbers */
.chroma .ln {
  margin-right: 0.4em;
  padding: 0 0.4em 0 0.4em;
  color: #bfbfbf;
  user-select: none;
  border-right: 2px solid #33f260;
}
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

<details><summary>Add Social Media Metadata</summary>

</br>

### Intro

By default, the sites generated from `Hugo` do not support the `social-metadata` adds-on. You will have to manually add it. Thanks to the [hugo-social-metadata](https://github.com/msfjarvis/hugo-social-metadata) repo, it gives us some guidances on how to enable the feature in an easy way.

### Setup

1. Create a file named `social_metadata.html` under `layouts/partials`. Paste the following contents into it:

```html
<!-- Configure meta and title tags -->
<meta property="og:type" content="website" />
{{ if .Site.Params.TwitterCardType }}
<meta
  name="twitter:card"
  content="{{ .Site.Params.TwitterCardType }}"
  key="twcard"
/>
{{ else }}
<meta name="twitter:card" content="summary_large_image" key="twcard" />
{{ end }} {{ if .Site.Params.TwitterUsername }}
<meta
  name="twitter:site"
  content="{{ .Site.Params.TwitterUsername }}"
  key="twhandle"
/>
{{ end }} {{ if .IsHome }}
<title>{{ .Site.Title }}</title>
<meta name="description" content="{{ $.Site.Params.description }}" />
<meta name="keywords" content="{{ $.Site.Params.Keywords }}" />
<meta property="og:url" content="{{ .Site.BaseURL }}" key="ogurl" />
<meta property="og:title" content="{{ .Site.Title }}" key="ogtitle" />
<meta
  name="og:description"
  content="{{ $.Site.Params.description }}"
  key="ogdesc"
/>
{{ else }}
<title>{{ .Title }} &middot; {{ .Site.Title }}</title>
<meta name="description" content="{{ .Description }}" />
{{ if .Params.tags }}
<meta name="keywords" content="{{ range .Params.tags }}{{ . }},{{ end }}" />
{{ else }}
<meta name="keywords" content="{{ $.Site.Params.Keywords }}" />
{{ end }}
<meta property="og:url" content="{{ .Permalink }}" />
<meta property="og:title" content="{{ .Title }} &middot; {{ .Site.Title }}" />
{{ if .Description }}
<meta name="og:description" content="{{ .Description }}" />
{{ else }}
<meta name="og:description" content="{{ $.Site.Params.description }}" />
{{ end }}
<meta name="twitter:url" content="{{ .Permalink }}" />
{{ if .Params.SocialImage }}
<meta
  property="og:image"
  content="{{ .Site.BaseURL }}{{ .Params.SocialImage }}"
  key="ogimage"
/>
{{ else }}
<meta
  property="og:image"
  content="{{ .Site.BaseURL}}{{ .Site.Params.SocialImage }}"
  key="ogimage"
/>
{{ end }}
<link rel="canonical" href="{{ .Permalink }}" />
{{ end }}
```

2. Include the `social_metadata.html` partial in your `head.html` under `layouts/partials` like so: `{{ partial "social_metadata.html" . }}.`, this will enable the `social-metadata` feature.

### Customize your page with metadata

You can customize some of the generated metadata on a per-page basis. Setting `description`, `socialImage` or `tags` in the frontmatter will override the defaults loaded from the main `config` file.

```md
+++
description = "A nice description for this blogpost"
socialImage = "path/to/an/image/that/describes/this/post/best"
tags = ["this", "blog", "rocks!"]
+++
```

</p></details>

### Use Hugo Http Server

Use `Hugo` built in `Http Server` to serve contents

```bash
hugo server -D --bind <server ip address> --baseURL http://<server ip address>
```

### Rerences

- [Hugo Official Docs](https://gohugo.io/documentation/)
