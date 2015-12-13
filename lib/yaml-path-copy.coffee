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
    @subscriptions.add atom.commands.add 'atom-workspace', 'yaml-path-copy:displayPath': => @displayPath()

  deactivate: ->
    @subscriptions.dispose()
    @yamlPathCopyView.destroy()

  serialize: ->
    yamlPathCopyViewState: @yamlPathCopyView.serialize()

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    unless editor.getGrammar().scopeName.match("yaml")
      return atom.notifications.addError("yaml-path-copy just can be used with source.yaml")

    yamlPath = @yamlPathCopyView.getParentPath()
    console.log "Yaml-path copied to clipboard: #{yamlPath}"
    displayText = "This parent path was copied to clipboard."
    atom.notifications.addSuccess(displayText, { detail: yamlPath, dismissable: true })
    atom.clipboard.write(yamlPath)

  displayPath: ->
    editor = atom.workspace.getActiveTextEditor()
    unless editor.getGrammar().scopeName.match("yaml")
      return atom.notifications.addError("yaml-path-copy just can be used with source.yaml")

    yamlPath = @yamlPathCopyView.getParentPath()
    console.log "Yaml-path current parent path: #{yamlPath}"
    displayText = "This is your current parent path."
    atom.notifications.addInfo(displayText, { detail: yamlPath, dismissable: true })
