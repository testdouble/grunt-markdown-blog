# grunt-markdown-blog

[![Node.js CI](https://github.com/testdouble/grunt-markdown-blog/actions/workflows/node.js.yml/badge.svg)](https://github.com/testdouble/grunt-markdown-blog/actions/workflows/node.js.yml)

This is a grunt multi-task for generating static blogs from posts written in markdown. It was designed to be used with [Lineman](https://github.com/testdouble/lineman), but should be generally useful to someone trying to accomplish the same.

Here's an easy-to-clone repo that uses it: [linemanjs/lineman-blog-template](https://github.com/linemanjs/lineman-blog-template)

# Features

There are a few spiffy features of grunt-markdown-blog that make it pretty useful:

* Parses markdown with the [marked](https://github.com/markedjs/marked) module, which means it's *fast*. It also means you get [Github-flavored-markdown](https://github.github.com/gfm/) features like [code fences](https://github.github.com/gfm/#fenced-code-blocks).
* Highlights code snippets with [Highlight.js](https://github.com/highlightjs/highlight.js), which means you can just drop in a [Highlight.js CSS file](https://github.com/highlightjs/highlight.js/tree/main/src/styles) and get crazy-great syntax highlighting. Highlight will try to auto-detect the language of the snippet, but it's more reliable to specify it in a code fence (e.g. ````coffeescript `). Check out [this demo](https://highlightjs.org/static/demo/) to see the different styles.
* Generates [RSS/Atom 2.0](https://en.wikipedia.org/wiki/Atom_(Web_standard)) and [JSONFeed 1.1](https://www.jsonfeed.org/version/1.1/) feeds.
* Supports JavaScript & CoffeeScript Frontmatter headers, which can then be accessed in templates easily. Example below.

## Headers

A post might look like this:

```
---
title: "Learning to love again with Lineman.js"
description: "We love lineman, and we think you will too!"
date: "2013-06-15"
author:
  name: "Justin Searls"
video:
  type: "youtube"
  url: "http://www.youtube.com/embed/PWHyE1Ru4X0"
---

Summary Cupcake wypas pastry sweet roll. Cake ice cream caramels apple pie donut chupa chups. Sugar plum dessert liquorice caramels jelly sugar plum ice cream applicake. Jelly beans tart carrot cake caramels liquorice macaroon gummi bears bonbon gummies.

```

All of those goodies between the "---" headers will be evaluated as JavaScript or CoffeeScript. So long as it evaluates to an object with properties, those will be accessible from your templates like so:

```
<div class="byline">
  <% if(post.get('author')) { %>
   by <a href="#"><span class="author"><%= post.get('author').name %></span></a>
  <% } %>
</div>
```

# Configuration

Here's an example configuration in CoffeeScript, which more or less mirrors the default configuration.

``` coffeescript
markdown:
  options:
    author: "Full Name"
    authorUrl: "https://twitter.com/fullname"
    title: "my blog"
    description: "my blog where I write things"
    url: "https://myblog.com"
    disqus: "my_disqus_id"      #<-- just remove or comment this line to disable disqus support
    feedCount: 10               #<-- set to zero to disable RSS and JSON Feed generation
    dateFormat: 'MMMM Do YYYY'
    layouts:
      wrapper: "app/templates/wrapper.pug"
      index: "app/templates/index.pug"
      post: "app/templates/post.pug"
      page: "app/templates/page.pug" #<-- optional static pages
      archive: "app/templates/archive.pug"
    paths:
      posts: "posts/*.md"
      pages: "pages/**/*.md" #<-- optional static pages
      index: "index.html"
      archive: "archive.html"
      rss: "index.xml"       #<-- rss/atom feed
      json: "index.json"     #<-- jsonfeed.org v1.1

  dev:
    dest: "generated"
    context:
      js: "../js/app.js"
      css: "../css/app.css"

  dist:
    dest: "dist"
    context:
      js: "../js/app.min.js"
      css: "../css/app.min.css"

```

# Watching for changes

If you use a watch plugin with grunt, you can also do something like this for development:

``` coffeescript
watch:
  markdown:
    files: ["app/posts/*.md", "app/pages/**/*.md", "app/templates/*.pug"]
    tasks: ["markdown:dev"]
```
