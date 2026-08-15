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

  // The workspace this bar's own monitor is displaying. `Hyprland.focusedWorkspace`
  // is global — exactly one across all screens — so on a two-monitor setup the
  // unfocused bar would mark nothing. Upstream renders an identical 1-10 strip on
  // every bar so it never noticed; once workspaceIds() is filtered per screen, each
  // bar has to read its own monitor's active workspace instead.
  readonly property int monitorWorkspaceId: {
    var values = Hyprland.monitors.values
    for (var i = 0; i < values.length; i++) {
      var mon = values[i]
      if (mon.name !== root.screenName) continue
      return mon.activeWorkspace ? mon.activeWorkspace.id : -1
    }

    // No screen match (screenName empty, or the monitor vanished mid-hotplug):
    // fall back to global focus so something is always marked.
    return Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1
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
        // Current on THIS bar's monitor — marked on every screen.
        readonly property bool current: modelData === root.monitorWorkspaceId
        // ...and additionally holding keyboard focus, which only one screen does.
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        bar: root.bar
        // Current marker, U+F14FB (nf-md-square_rounded), as an escaped surrogate
        // pair like upstream so the codepoint survives diffs and copy-paste.
        text: current ? "\uDB85\uDCFB" : String(modelData)
        // Both monitors show a glyph, so the glyph alone can't say which one has the
        // keyboard. Paint the focused one in the theme's accent (WidgetButton swaps
        // the label to `activeColor` when `active`) to break the tie.
        active: focused
        // Dim empty workspaces — but only when the bar has its own background.
        //
        // In transparent mode the bar draws straight over the wallpaper, and
        // omarchy-bar-text-color has already picked whichever of the theme's
        // foreground/background colors contrasts *most* against the strip of
        // wallpaper under the bar. Every other widget then paints that colour at
        // full opacity. Dimming re-blends it toward the very pixels it was chosen
        // to stand out from, so on a light wallpaper the empty workspaces are the
        // one thing on the bar that goes unreadable. Full opacity keeps the
        // contrast the helper computed; the glyph and accent still mark position.
        opacity: occupied || current ? 1 : (root.bar && root.bar.requestedTransparent ? 1 : 0.5)
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }

        // Occupancy underline: present iff the workspace has at least one window.
        //
        // The dim above is the only other occupancy cue and it's switched off in
        // transparent mode, where lowering alpha blends the label back toward the
        // wallpaper it was picked to contrast against. This says the same thing
        // without touching contrast — it's drawn at full opacity in the same colour
        // as the label, so it stays legible on any wallpaper.
        Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: parent.bottom
          // Low enough to clear the current workspace's square glyph — any closer
          // and the two merge into a single blob at a glance.
          anchors.bottomMargin: Style.space(3)
          width: Style.space(8)
          height: Style.space(2)
          radius: height / 2
          visible: occupied
          // Mirror the label so the focused workspace's underline picks up the
          // accent too, rather than sitting there in the plain foreground.
          color: active && useActiveColor ? activeColor : foreground
        }
      }
    }
  }
}
