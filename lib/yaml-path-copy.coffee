YamlPathCopyView = require './yaml-path-copy-view'
{CompositeDisposable} = require 'atom'

module.exports = YamlPathCopy =
  yamlPathCopyView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @yamlPathCopyView = new YamlPathCopyView(state.yamlPathCopyViewState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'yaml-path-copy:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @yamlPathCopyView.destroy()

  serialize: ->
    yamlPathCopyViewState: @yamlPathCopyView.serialize()

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    unless editor.getGrammar().scopeName.match("yaml")
      return atom.notifications.addError("Only use source.yaml")

    yamlPath = @yamlPathCopyView.getParentPath()
    console.log "Yaml-path copied to clipboard. #{yamlPath}"
    displayText = "This path '#{yamlPath}' was copied to clipboard."
    atom.notifications.addSuccess(displayText)
    atom.clipboard.write(yamlPath)
