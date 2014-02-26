# -*- coding: utf-8 -*-
from libqtile.config import Key, Click, Drag, Screen, Group, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
import socket
import subprocess
import re
import logging

HOSTNAME = socket.gethostname()
mod = "mod4"


def is_running(process):
    s = subprocess.Popen(["ps", "axw"], stdout=subprocess.PIPE)
    for x in s.stdout:
        if re.search(process, x):
            return True
    return False


def execute_once(process):
    if not is_running(process):
        return subprocess.Popen(process.split())


# @hook.subscribe.startup
# def startup():
#     lazy.spawn("xbacklight -set 10")
#     lazy.spawn("pkill -9 emacs")
#     execute_once("gnome-settings-daemon")
#     execute_once("nm-applet")


class Commands(object):
    volume = 'amixer -q sset Master %s && aplay -d default /usr/share/sounds/sound-icons/glass-water-1.wav'
    yoga_rotate = "yoga.rotate.sh"
    # Added pm-suspend in /etc/sudoers
    # https://wiki.archlinux.org/index.php/pm-utils#User_permission_method
    suspend = "sudo pm-suspend"

keys = [
    Key([mod], "Down",
        lazy.layout.down()),
    Key([mod], "Up",
        lazy.layout.up()),
    Key([mod, "shift"], "Down",
        lazy.layout.move_down()),
    Key([mod, "shift"], "Up",
        lazy.layout.move_up()),
    Key([mod, "control"], "Down",
        lazy.layout.section_down()),
    Key([mod, "control"], "Up",
        lazy.layout.section_up()),
    Key([mod], "Left",
        lazy.layout.collapse_branch()),  # for tree layout
    Key([mod], "Right",
        lazy.layout.expand_branch()),  # for tree layout
    Key([mod, "shift"], "Left",
        lazy.layout.move_left()),
    Key([mod, "shift"], "Right",
        lazy.layout.move_right()),
    Key([mod, "control"], "Left",
        lazy.layout.decrease_ratio()),
    Key([mod, "control"], "Right",
        lazy.layout.increase_ratio()),

    Key([mod], "comma", lazy.layout.increase_nmaster()),
    Key([mod], "semicolon", lazy.layout.decrease_nmaster()),

    Key([mod], "Tab", lazy.group.next_window()),
    Key([mod], "n", lazy.layout.up()),
    Key([mod, "shift"], "Tab", lazy.group.prev_window()),
    Key([mod, "shift"], "Return", lazy.layout.rotate()),
    Key([mod, "shift"], "space", lazy.layout.toggle_split()),

    Key([mod], "o", lazy.to_next_screen()),

    Key([mod], "e",      lazy.spawn("emacs")),
    Key([mod], "f",      lazy.spawn("firefox")),
    Key([mod], "g",      lazy.spawn("google-chrome")),
    Key([mod], "Return", lazy.spawn("x-terminal-emulator")),
    Key([mod], "space",  lazy.nextlayout()),
    Key([mod], "c",      lazy.window.kill()),
    Key([mod], "t",      lazy.window.disable_floating()),
    Key([mod, "shift"], "t", lazy.window.enable_floating()),
    Key([mod], "p",
        lazy.spawn("exec dmenu_run "
                   "-fn 'Consolas:size=13' -nb '#000000' -nf '#ffffff' -b")),

    Key([mod], "Left", lazy.prevgroup()),
    Key([mod], "Right", lazy.nextgroup()),
]

if HOSTNAME.startswith('yoga'):
    keys += [
        Key([], "F5", lazy.spawn(Commands.yoga_rotate)),
        Key([mod], "s", lazy.spawn(Commands.suspend)),
        Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 5")),
        Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 5")),
        Key([], "XF86AudioRaiseVolume", lazy.spawn(Commands.volume % '5dB+')),
        Key([], "XF86AudioLowerVolume", lazy.spawn(Commands.volume % '5dB-')),
        # Already active
        # Key([], "XF86AudioMute", lazy.spawn(Commands.volume % 'toggle')),
    ]



mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

border = dict(
    border_normal='#808080',
    border_width=2,
)

layouts = [
    layout.Max(),
    #layout.Slice('top', 320, wmclass='pino')
    layout.Tile(**border),
    # layout.Stack(**border),
    layout.Zoomy(),
]
floating_layout = layout.Floating(**border)

GROUPS = (('1', 'ampersand'),
          ('2', 'eacute'),
          ('3', 'quotedbl'),
          ('4', 'apostrophe'),
          ('5', 'parenleft'),
          ('6', 'minus'),
          ('7', 'egrave'),
          ('8', 'underscore'),
          )

groups = [
    Group('1', spawn='firefox-bin', layout='max',
          matches=[Match(
              wm_class=['Firefox', 'google-chrome', 'Google-chrome'])]),
    Group('2', spawn='firefox-bin', layout='max',
          matches=[Match(wm_class=["emacs", "Emacs"])]),
    Group('3', layout='max'),
    Group('4', layout='max'),
    Group('5', layout='max'),
    Group('6', layout='max'),
    Group('7', layout='max'),
    Group('8', layout='max'),
]

for name, key in GROUPS:
    keys.append(
        Key([mod], key, lazy.group[name].toscreen())
    )
    keys.append(
        Key([mod, "shift"], key, lazy.window.togroup(name))
    )
# ?????
for i in groups:
    keys.append(
        Key([mod], i.name, lazy.group[i.name].toscreen())
    )
    keys.append(
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name))
    )


THEME_PATH = "/usr/share/icons/gnome/32x32/status"

if HOSTNAME.startswith('yoga'):
    screens = [
        Screen(
            top=bar.Bar(
                [
                    widget.GroupBox(margin_x=1, margin_y=0,
                                    fontsize=21, disable_drag=True),
                    widget.Sep(),
                    widget.WindowName(fontsize=32),
                    widget.Sep(),
                    widget.BatteryIcon(battery_name="BAT1"),
                    widget.Battery(battery_name="BAT1",
                                   format="{percent:2.0%}"),
                    widget.Volume(cardid=1, theme_path=THEME_PATH),

                    widget.Sep(),
                    widget.Systray(),
                    widget.Sep(),

                    widget.CPUGraph(),
                    widget.MemoryGraph(),
                    widget.SwapGraph(foreground='C02020'),
                    widget.Sep(),
                    widget.NetGraph(interface='wlan0'),
                    widget.Sep(),
                    widget.Notify(),
                    widget.Clock('%d/%m %H:%M', fontsize=34)
                ],
                42,
            ),
        )]
else:
    screens = [
        Screen(
            top=bar.Bar(
                [
                    widget.GroupBox(margin_x=1, margin_y=0,
                                    fontsize=8, disable_drag=True),
                    widget.Sep(),
                    widget.WindowName(fontsize=16),
                    widget.Sep(),
                    #widget.Notify(),
                    widget.CPUGraph(),
                    widget.MemoryGraph(),
                    widget.Sep(),
                    widget.Clock('%d/%m %H:%M', fontsize=17)
                ],
                21,
            ),
        ),
        Screen(
            top=bar.Bar([
                widget.GroupBox(margin_x=1, margin_y=0,
                                fontsize=8, disable_drag=True),
                widget.WindowName(fontsize=16)
            ], 21),
        )
    ]

floating_layout = layout.floating.Floating(
    float_rules=[{'wmclass': x} for x in (
        'file_progress',
        'file-roller',
        'gimp',
        'florence',
        'Florence',
    )])

@hook.subscribe.client_new
def floating_dialogs(window):
    if not window.window:
        return
    win = window.window
    wm_class = win.get_wm_class() or []

    if 'Florence' in wm_class:
        logging.debug(">%s" % str(window.__dict__))
        window.floating = True
        window.width = 1200
        window.height = 400
    elif (win.get_wm_type() == 'dialog'
          or win.get_wm_transient_for() or
          (win.get_wm_window_role() == "browser"
           and 'Google-chrome' not in wm_class
           and (window._float_info['x'] != 0
                or window._float_info['y'] != 0))):
        window.floating = True
