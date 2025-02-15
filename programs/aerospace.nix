{lib, ...}: {
  services.aerospace = {
    enable = true;
    settings = {
      accordion-padding = 300;
      gaps = {
        inner.horizontal = 20;
        inner.vertical = 20;
        outer.left = 20;
        outer.bottom = 20;
        outer.top = 20;
        outer.right = 20;
      };
      mode.main.binding = {
        alt-f = "fullscreen --no-outer-gaps";
        alt-ctrl-f = "layout floating";
        alt-shift-c = "reload-config";
        alt-q = "close --quit-if-last-window";

        alt-shift-left = "join-with left";
        alt-shift-down = "join-with down";
        alt-shift-up = "join-with up";
        alt-shift-right = "join-with right";

        alt-shift-space = "layout floating tiling";         # "floating toggle" in i3
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        # Focus
        alt-h = "focus --boundaries-action wrap-around-the-workspace left";
        alt-j = "focus --boundaries-action wrap-around-the-workspace down";
        alt-k = "focus --boundaries-action wrap-around-the-workspace up";
        alt-l = "focus --boundaries-action wrap-around-the-workspace right";

        # Join with adjacent windows
        alt-shift-h = ["join-with left" "mode main"];
        alt-shift-j = ["join-with down" "mode main"];
        alt-shift-k = ["join-with up" "mode main"];
        alt-shift-l = ["join-with right" "mode main"];

        # Workspace
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # Modes
        alt-shift-semicolon = "mode service";
        alt-r = "mode resize";

        # Applications
        alt-b = "exec-and-forget open -a /Applications/Edge.app";
        # alt-enter = "exec-and-forget open /Applications/Ghostty.app -n";
        alt-enter = ''
            exec-and-forget osascript -e 'if application "Ghostty" is not running then
              tell application "Ghostty" to activate
            else
              tell application "Ghostty" to activate
              tell application "System Events" to tell process "Ghostty" to click menu item "New Window" of menu "File" of menu bar 1
            end if'
        '';

      };

      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"]; # reset layout
        f = [
          "layout floating tiling"
          "mode main"
        ]; # Toggle between floating and tiling layout
        backspace = ["close-all-windows-but-current" "mode main"];
      };

      mode.resize.binding = {
        h = "resize width -50";
        j = "resize height +50";
        k = "resize height -50";
        l = "resize width +50";
        enter = "mode main";
        esc = "mode main";
      };
    };
  };
}
