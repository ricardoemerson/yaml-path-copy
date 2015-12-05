YamlPathCopyView = require './yaml-path-copy-view'
{CompositeDisposable} = require 'atom'

module.exports = YamlPathCopy =
  yamlPathCopyView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @yamlPathCopyView = new YamlPathCopyView(state.yamlPathCopyViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @yamlPathCopyView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'yaml-path-copy:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @yamlPathCopyView.destroy()

  serialize: ->
    yamlPathCopyViewState: @yamlPathCopyView.serialize()

  toggle: ->
    console.log 'YamlPathCopy was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
