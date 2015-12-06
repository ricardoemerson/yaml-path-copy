module.exports =
class YamlPathCopyView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('yaml-path-copy')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The YamlPathCopy package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  updateYamlPath: ->
    grammar = @activeTextEditor()?.getGrammar?()
    if grammar?
      if grammar is atom.grammars.nullGrammar
        grammarName = 'Plain Text'
      else
        grammarName = grammar.name ? grammar.scopeName

    if grammarName == 'YAML'
      @textContent = @getParentPath()
    else
      @textContent = "Not supported"

  activeTextEditor: ->
    atom.workspace.getActiveTextEditor()

  getFirstNonSpaceOnSpecifiedRow: (row, column) ->
    # return first non-space character position on specified row
      # get buffer text for current line
    currentRow = @activeTextEditor().lineTextForBufferRow(row)
    if currentRow.replace(/^\s+$/g, "") == ""
      firstNonSpaceOnSpecifiedRow = column
    else
      # find first non-space
      currentRow.match(/\S/)["index"]

  getYamlKeyOnSpecifiedRow: (row) ->
    currentRow = @activeTextEditor().lineTextForBufferRow(row)
    # strip whitespace
    strippedCurrentRow = currentRow.replace /^s+|\s+/g, ""
    # strip trailing colon
    strippedCurrentRow = strippedCurrentRow.replace /:/g, ""

  getParent: (row, column) ->
    # get parent name of the specified row
    firstNonSpace = @getFirstNonSpaceOnSpecifiedRow(row, column)
    tmpRow = row
    found = 0
    while ( tmpRow > 0 and ! found)
      firstNonSpaceTmp = @getFirstNonSpaceOnSpecifiedRow(tmpRow)
      if firstNonSpaceTmp < firstNonSpace and firstNonSpaceTmp < column
        found = 1
      else
        tmpRow -= 1
    [parentWord, parentRow] = [@getYamlKeyOnSpecifiedRow(tmpRow), tmpRow]

  getParentPath: ->
    # get first non-space character position
      # get current line number
    currentCursorPosition = @activeTextEditor().getCursorBufferPosition()
    currentCursorRow = currentCursorPosition["row"]
    currentCursorColumn = currentCursorPosition["column"]
    # get first parent name
    if currentCursorRow == 0 or currentCursorColumn == 0
      parrentSentence = "<root>"
    else
      parrentSentence = []
      tmpRow = currentCursorRow
      while tmpRow > 0
        [parentWord, parentRow] = @getParent(tmpRow, currentCursorColumn)
        parrentSentence.push parentWord
        tmpRow = parentRow
      parrentSentence = parrentSentence.reverse().join(".")
