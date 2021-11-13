# Post = null
# Posts = null

# beforeEach ->
#   Post  = td.constructor(['fileName'])
#   Posts = require '../lib/posts'

# ddescribe "Posts", ->
#   Given -> @markdownFiles = [ "md1", "md2" ]
#   Given -> @config = td.object 'config', ['htmlDir', 'layout', 'dateFormat', 'comparator']
#   When  -> @subject = new Posts(@markdownFiles, @config)

#   describe "has posts", ->
#     When -> console.log(@subject)
#     Then -> @subject.posts.length == 2

  # describe "builds posts", ->
  #   Given -> @markdownFiles = [ @post1 = td.object('post1') ]

  #   Then -> @subject.getPosts()[0] instanceof Post
  #   Then -> td.verify(Post(@post1, @config.htmlDir, @config.dateFormat))

  # describe "is sorted automatically", ->
  #   Then -> expect(@config.comparator).toHaveBeenCalled()


  # describe "#htmlFor", ->
  #   Given -> @site = "site"
  #   Given -> @post = "post"
  #   Given -> @html = "html"
  #   Given ->
  #     @config.layout.htmlFor = td.func('layout.htmlFor')
  #     td.when(@config.layout.htmlFor(@site, @post).thenReturn(@html))
  #   Then -> @subject.htmlFor(@site, @post) == @html

  # describe "#writeHtml", ->
  #   Given -> @html = "html"
  #   Given -> @generatesHtml = td.object('generatesHtml', ['generate'])
  #   Given -> @writesFile = td.object('writesFile', ['write'])

  #   context "without posts", ->
  #     Given -> @markdownFiles = []
  #     When -> @subject.writeHtml(@generatesHtml, @writesFile)
  #     Then -> @generatesHtml.callCount == 0
  #     Then -> @writesFile.callCount == 0

  #   context "with 3 posts", ->
  #     Given -> @htmlPath = "htmlPath"
  #     Given ->
  #       @post = td.object('post', ['htmlPath'])
  #       td.when(@post.htmlPath()).thenReturn(@htmlPath)
  #     Given ->
  #       @subject.posts = [@post, @post, @post]
  #     When -> @subject.writeHtml(@generatesHtml, @writesFile)
  #     Then -> @generatesHtml.generate.callCount == 3
  #     Then -> td.verify(@generatesHtml.generate(@config.layout, @post))
  #     Then -> @writesFile.write.callCount == 3
  #     Then -> td.verify(@writesFile.write(@html, @htmlPath))

  # describe '', ->
  #   Given -> [@post1, @post2, @post3] = ["oldest", "middle", "newest"]
  #   When -> @subject.posts = [@post1, @post2, @post3]

  #   describe "#oldest", ->
  #     When -> @oldest = @subject.oldest()
  #     Then -> @oldest == @post1

  #   describe "#newest", ->
  #     When -> @newest = @subject.newest()
  #     Then -> @newest == @post3

  #   describe "#older", ->
  #     When -> @older = @subject.older(@post)

  #     context "given the oldest post", ->
  #       Given -> @post = @post1
  #       Then -> @older == undefined

  #     context "given a newer post", ->
  #       Given -> @post = @post2
  #       Then -> @older == @post1

  #   describe "#newer", ->
  #     When -> @newer = @subject.newer(@post)

  #     context "given the latest post", ->
  #       Given -> @post = @post3
  #       Then -> @newer == undefined

  #     context "given an older post", ->
  #       Given -> @post = @post2
  #       Then -> @newer == @post3
