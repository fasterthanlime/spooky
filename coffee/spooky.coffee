
class Game

  constructor: ->
    @max = 500
    @remaining = @max
    @initialized = false

    @score = 0
    @used = []

    @fetch()

  fetch: ->
    $.ajax('words.json?v3', { dataType: 'json' }).done (data) =>
      @words = data.words.sort (a, b) ->
        b.length - a.length

      $('.input').val """
      Apparently, some american agency is monitoring all internet connections based on keywords.

      So let's have some fun with that.

      Two challenges:

      - Put your day into words, while staying under the radar.
      - Make their detectors go trigger-happy. Go nuts!
      """
      @update()
      @initEvents()

  initEvents: ->
    $('.input').change (e) =>
      @update()

    $('.input').keyup (e) =>
      @update()

    $('.input').click (e) =>
      unless @initialized
        @initialized = true
        $('.input').val ''
        @update()

  escapeRE: (input) ->
    input.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"

  update: ->
    text = $('.input').val()
    processed = text.toLowerCase().replace /[^a-z0-9 ]/gi, ''
    scoreAccu = 0

    @used = []
    for word in @words
      continue unless @used.indexOf(word) == -1
      unless processed.indexOf(word) == -1
        @used.push word

    replaced = text

    factor = 2.13
    max = 10

    for word in @used
      regexp = new RegExp "(#{@escapeRE(word)})", 'gi'
      replaced = replaced.replace regexp, (str, kw) ->
        le = Math.min(max, word.length)
        scoreAccu += (1 + Math.pow(1.3, le)) * factor
        factor = factor + 0.3
        "<span>#{kw}</span>"

    replaced = replaced.replace /\n/gi, '<br>'

    $('.highlighter').html(replaced)

    @score = scoreAccu
    @remaining = @max - text.length
    $('.charsvalue').text("#{@remaining}")
    $('.scorevalue').text("#{Math.floor(@score)}%")

$ ->
  game = new Game()
