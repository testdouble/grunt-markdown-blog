# grunt-markdown-blog

This is a grunt multi-task for generating static blogs with markdown. It was designed to be used with [Lineman](https://github.com/testdouble/lineman), but should be generally useful to someone trying to accomplish the same.

Here's an example repo that'll be using it. [testdouble/lineman-blog](https://github.com/searls/lineman-blog)

Here's an example configuration (in CoffeeScript, just imagine more `{` & `}` if you prefer JavaScript):

``` coffeescript
markdown:
  options:
    author: "Full Name"
    title: "my blog"
    description: "my blog where I write things"
    url: "http://myblog.com"
    disqus: "my_disqus_id" #<-- just remove or comment this line to disable disqus support
    rssCount: 10 #<-- remove, comment, or set to zero to disable RSS generation
    layouts:
      wrapper: "app/templates/wrapper.us"
      index: "app/templates/index.us"
      post: "app/templates/post.us"
      archive: "app/templates/archive.us"
    paths:
      markdown: "app/posts/*.md"
      posts: "posts"
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

If you use a watch plugin with grunt, you can also do something like this for development:

``` coffeescript
watch:
  markdown:
    files: ["app/posts/*.md", "app/templates/*.us"]
    tasks: ["markdown:dev"]
```
