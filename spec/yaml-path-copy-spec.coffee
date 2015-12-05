YamlPathCopy = require '../lib/yaml-path-copy'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "YamlPathCopy", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('yaml-path-copy')

  describe "when the yaml-path-copy:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.yaml-path-copy')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'yaml-path-copy:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.yaml-path-copy')).toExist()

        yamlPathCopyElement = workspaceElement.querySelector('.yaml-path-copy')
        expect(yamlPathCopyElement).toExist()

        yamlPathCopyPanel = atom.workspace.panelForItem(yamlPathCopyElement)
        expect(yamlPathCopyPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'yaml-path-copy:toggle'
        expect(yamlPathCopyPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.yaml-path-copy')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'yaml-path-copy:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        yamlPathCopyElement = workspaceElement.querySelector('.yaml-path-copy')
        expect(yamlPathCopyElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'yaml-path-copy:toggle'
        expect(yamlPathCopyElement).not.toBeVisible()
