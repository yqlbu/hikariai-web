# Hugo Basic Usage

## Installation

```bash
brew install hugo
brew help
hugo env
```

## Basic Usage

### Create a new site

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

### Configure Theme

```bash
git clone <theme source> themes/<theme name>
rm -rf themes/<theme name>/.git
cp -r themes/<theme name>/exampleSite/config.toml ./
```

### Generate Contents on Page

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

### Generate Static Files

```bash
hugo
ls -l public/
```

### Use Hugo Http Server

Use `Hugo` built in `Http Server` to serve contents

```bash
hugo server -D --bind <server ip address> --baseURL http://<server ip address>
```
