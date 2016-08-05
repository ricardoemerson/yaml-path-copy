module.exports =
class YamlPathCopyView
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

  # To be proccessed only with a currentKey.
  getCurrentLineYamlKeyOnSpecifiedRow: (row) ->
    currentRow = @activeTextEditor().lineTextForBufferRow(row)
    if currentRow.indexOf(':') > -1
      # strip whitespace
      strippedCurrentRow = currentRow.replace /^s+|\s+/g, ""
      # strip trailing colon
      strippedCurrentRow = strippedCurrentRow.split(':')[0]
    else
      strippedCurrentRow = ''

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

  removePipe: (word) ->
    parentWord = word.split('|')[0]

  removeConectorE: (word) ->
    parentWord = word.split('&')[0]

  getCurrentPath: ->
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

      # Includes the current key.
      currentKeyWord = @getCurrentLineYamlKeyOnSpecifiedRow(tmpRow)
      currentKeyWord = @removePipe currentKeyWord
      currentKeyWord = @removeConectorE currentKeyWord
      parrentSentence.push currentKeyWord if currentKeyWord != ''

      while tmpRow > 0
        [parentWord, parentRow] = @getParent(tmpRow, currentCursorColumn)

        # console.log("parentWord: #{parentWord}")
        # console.log("parentRow: #{parentRow}")
        # console.log("getYaml: #{currentKeyWord}")

        # Skip comment code from begining of Yaml file.
        if parentWord[0] is '#'
          tmpRow -= 1
          continue

        # Ignores the characters '|' and '&'
        parentWord = @removePipe parentWord
        parentWord = @removeConectorE parentWord

        parrentSentence.push parentWord
        tmpRow = parentRow

      parrentSentence = parrentSentence.reverse().join(".")
