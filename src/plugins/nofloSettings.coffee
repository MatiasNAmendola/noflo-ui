# Dataflow plugin for managing NoFlo graph properties
{Dataflow} = require '/meemoo-dataflow'

class NoFloSettingsPlugin
  constructor: ->
    @dataflow = null

  initialize: (dataflow) ->
    @runtime = null
    @$settings = $ "<div class=\"noflo-ui-settings\"></div>"

    dataflow.disablePlugin 'log'

    dataflow.addPlugin
      id: 'settings'
      name: ''
      menu: @$settings
      icon: 'cog'
      pinned: false

  registerGraph: (graph, runtime) ->
    @$settings.html()
    return unless graph.properties.environment.runtime
    switch graph.properties.environment.runtime
      when 'websocket'
        @renderServerForm graph
      else
        @renderClientForm graph

  renderServerForm: (graph) ->
    $form = $ "<form>
      <label>
        WebSocket URL
        <input class='wsUrl' type='url'>
      </label>
      <div class='toolbar'>
        <button class='update'>Update</button>
      </div>
     </form>"
    $wsUrl = $form.find '.wsUrl'
    $update = $form.find '.update'
    $wsUrl.val graph.properties.environment.wsUrl
    $update.click (event) ->
      event.preventDefault()
      graph.properties.environment.wsUrl = $wsUrl.val()
      graph.emit 'changed'

    @$settings.append $form

  renderClientForm: (graph) ->
    $form = $ "<form>
      <label>
        Preview iframe
        <input class='src' type='text'>
      </label>
      <label>
        HTML contents
        <textarea class='content'></textarea>
      </label>
      <label>
        Preview width
        <input class='width' type='number'>
      </label>
      <label>
        Preview height
        <input class='height' type='number'>
      </label>
      <div class='toolbar'>
        <button class='update'>Update</button>
      </div>
     </form>"

    $src = $form.find '.src'
    $content = $form.find '.content'
    $width = $form.find '.width'
    $height = $form.find '.height'
    $update = $form.find '.update'

    $src.val graph.properties.environment.src
    $content.val graph.properties.environment.content
    $width.val graph.properties.environment.width
    $height.val graph.properties.environment.height

    $update.click (event) ->
      event.preventDefault()
      graph.properties.environment.src = $src.val()
      graph.properties.environment.content = $content.val()
      graph.properties.environment.height = $height.val()
      graph.properties.environment.width = $width.val()
      graph.emit 'changed'

    @$settings.append $form

plugin = Dataflow::plugin 'nofloSettings'
Dataflow::plugins.nofloSettings = new NoFloSettingsPlugin
