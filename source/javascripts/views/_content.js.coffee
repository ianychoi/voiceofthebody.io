class App.Views.Content extends Backbone.View
  initialize: (opt)->
    @render()

  groupImages: ()->
    @$el.children('.main-content-interior').children('p').each (i, el)->
      images = $(el).find('img')
      if images.length > 1
        $(el).addClass('img-gallery')

  createTableOfContents: ()->
    return if @$el.attr('data-no-toc') isnt undefined
    headers =  @$el.children('.main-content-interior').children('h2, h3')
    showNavItems = headers.length > 0 and @$el.attr('data-no-toc') is undefined
    $title =  @$el.children('.main-content-interior').children('h1:first-child').first()
    if @$el.siblings('.section-nav').length > 0
      $toc = new App.Views.TableOfContents
        items: if showNavItems then headers else []
        parent: @$el
        title:
          text: $title.text()
          href: $title.attr('id')

    if showNavItems
      $('#toc').on 'activate.bs.scrollspy', (e)->
        headers.filter('.active').removeClass('active')
        target = $(e.target).find('a').attr('href')
        $(target).addClass('active')

  parseTables: ->
    return if @$el.attr('data-flex-width') isnt undefined
    tables = @$el.children('.main-content-interior').children('table')
    tables.wrap('<div class="table-wrapper"></div>')
    tables.find('td').each (i, el)->
      $(el).html $.parseHTML( el.innerHTML
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>'))

  parseAPIparams: ->
    codeBlocks = @$el.children('.main-content-interior').find('.param.http')
    codeBlocks.each (i, el)=>
      $code = $(el)
      exploded = $code.text().split(' ')
      $code.html @renderAPIBlock exploded...
      $code.addClass exploded[0].toLowerCase()

  renderAPIBlock: (method, description..., url)->
    ich.apiParam {
      method: method
      description: description.join(' ')
      url: url
      type: method.toLowerCase()
    }

  render: ()->
    @groupImages()
    @createTableOfContents()
    @parseTables()
    @parseAPIparams()
    return @
