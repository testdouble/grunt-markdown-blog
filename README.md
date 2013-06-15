# grunt-markdown-blog

This is a grunt multi-task for generating static blogs from posts written in markdown. It was designed to be used with [Lineman](https://github.com/testdouble/lineman), but should be generally useful to someone trying to accomplish the same.

Here's an easy-to-clone repo that uses it: [testdouble/lineman-blog](https://github.com/testdouble/lineman-blog)

# Features

There are a few spiffy features of grunt-markdown-blog that make it pretty useful:

* Parses markdown with the "marked" module, which means it's *fast*. It also means you get Github-flavored-markdown features like code fences.
* Highlights code snippets with Highlight.js, which means you can just drop in a Highlight.js CSS file and get crazy-great syntax highlighting. Highlight will try to auto-detect the language of the snippet, but it's more reliable to specify it in a code fence (e.g. ```` coffeescript `)
* Supports JavaScript & CoffeeScript headers, which can then be accessed in templates easily. Example below.

## Headers

A post might look like this:

```
---
title: "Learning to love again with Lineman.js"
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
    title: "my blog"
    description: "my blog where I write things"
    url: "http://myblog.com"
    disqus: "my_disqus_id" #<-- just remove or comment this line to disable disqus support
    rssCount: 10 #<-- remove, comment, or set to zero to disable RSS generation
    dateFormat: 'MMMM Do YYYY'
    layouts:
      wrapper: "app/templates/wrapper.us"
      index: "app/templates/index.us"
      post: "app/templates/post.us"
      page: "app/templates/page.us" #<-- optional static pages
      archive: "app/templates/archive.us"
    paths:
      posts: "posts/*.md"
      pages: "pages/**/*.md" #<-- optional static pages
      index: "index.html"
      archive: "archive.html"
      rss: "index.xml"

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
    files: ["app/posts/*.md", "app/pages/**/*.md", "app/templates/*.us"]
    tasks: ["markdown:dev"]
```
