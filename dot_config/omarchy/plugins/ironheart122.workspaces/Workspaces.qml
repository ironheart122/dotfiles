import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "ironheart122.workspaces"

  // A bar surface is built per monitor, but the `bar` property points at Bar.qml's
  // global root, which has no screen. QsWindow.window is the per-screen BarPanel, so
  // that's the handle that identifies which monitor this instance is drawing on.
  // (QtQuick's Window.window attached property is null here — PanelWindow isn't an Item.)
  readonly property string screenName: QsWindow.window && QsWindow.window.screen ? QsWindow.window.screen.name : ""

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  // Upstream seeds 1-5 and caps at id <= 10 with no monitor filter, so every bar
  // renders the same 1-10 strip and workspaces 11+ never appear. Here: no seed (all
  // workspaces are persistent, so they always exist), no cap, and only this screen's.
  // If screenName is empty the filter is skipped, degrading to upstream's behaviour
  // rather than rendering an empty bar.
  function workspaceIds() {
    var ids = []
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var ws = values[i]
      if (ws.id <= 0) continue
      if (root.screenName !== "" && ws.monitor && ws.monitor.name !== root.screenName) continue
      if (ids.indexOf(ws.id) === -1) ids.push(ws.id)
    }

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.workspaceIds().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        bar: root.bar
        // Focused marker, U+F14FB (nf-md-square_rounded), as an escaped surrogate
        // pair like upstream so the codepoint survives diffs and copy-paste.
        text: focused ? "\uDB85\uDCFB" : String(modelData)
        // Dim empty workspaces — but only when the bar has its own background.
        //
        // In transparent mode the bar draws straight over the wallpaper, and
        // omarchy-bar-text-color has already picked whichever of the theme's
        // foreground/background colors contrasts *most* against the strip of
        // wallpaper under the bar. Every other widget then paints that colour at
        // full opacity. Dimming re-blends it toward the very pixels it was chosen
        // to stand out from, so on a light wallpaper the empty workspaces are the
        // one thing on the bar that goes unreadable. Full opacity keeps the
        // contrast the helper computed; the focused glyph still marks position.
        opacity: occupied || focused ? 1 : (root.bar && root.bar.requestedTransparent ? 1 : 0.8)
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }
  }
}
