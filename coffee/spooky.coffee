
class Game

  constructor: ->
    @max = 580
    @remaining = @max
    @initialized = false

    @score = 0

    $('.content').css('opacity', 0.5)
    @fetch()

  fetch: ->
    $.get 'words.json', (data) =>
      @words = data.words
      $('.content').css('opacity', 1.0)
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
        $('.input').val('')
        @update()

  update: ->
    text = $('.input').val()
    processed = text.toLowerCase().replace(/[^a-z0-9 ]/, '')
    scoreAccu = 0

    for word in @words
      unless processed.indexOf(word) == -1
        scoreAccu += (11 + Math.pow(2, word.length + 10) * 0.01) * 1.2

    @score = scoreAccu
    @remaining = @max - text.length
    $('.charsvalue').text("#{@remaining}")
    $('.scorevalue').text("#{Math.floor(@score)}")

$ ->
  game = new Game()
