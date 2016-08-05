YamlPathCopyView = require './yaml-path-copy-view'

module.exports =
  activate: ->
    @yamlPathCopyView = new YamlPathCopyView()

    # Register command that copyPath this view
    atom.commands.add 'atom-workspace', 'yaml-path-copy:copyPath': => @copyPath()
    atom.commands.add 'atom-workspace', 'yaml-path-copy:displayPath': => @displayPath()

  deactivate: ->
    @yamlPathCopyView.destroy()

  displayPath: ->
    editor = atom.workspace.getActiveTextEditor()
    unless editor.getGrammar().scopeName.match("yaml")
      return atom.notifications.addError("yaml-path-copy only can be used with source.yaml")

    yamlPath = @yamlPathCopyView.getCurrentPath()
    console.log "Yaml-path current path: #{yamlPath}"
    displayText = "This is your current yaml-path."
    atom.notifications.addInfo(displayText, { detail: yamlPath, dismissable: true })

  copyPath: ->
    editor = atom.workspace.getActiveTextEditor()
    unless editor.getGrammar().scopeName.match("yaml")
      return atom.notifications.addError("yaml-path-copy only can be used with source.yaml")

    yamlPath = @yamlPathCopyView.getCurrentPath()
    console.log "Yaml-path copied to clipboard: #{yamlPath}"
    displayText = "This yaml-path was copied to clipboard."
    atom.notifications.addSuccess(displayText, { detail: yamlPath, dismissable: true })
    atom.clipboard.write(yamlPath)
