// Top-bar headset battery indicator. Runs tb-battery --waybar every minute and
// shows its percentage; hides itself when the headset can't be read.

import Clutter from 'gi://Clutter';
import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import St from 'gi://St';
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';

const SCRIPT = GLib.build_filenamev([GLib.get_home_dir(), '.local', 'bin', 'tb-battery']);
const INTERVAL_S = 60;

export default class HeadsetBatteryExtension extends Extension {
    enable() {
        this._button = new PanelMenu.Button(0.0, this.metadata.name, true);
        const box = new St.BoxLayout({ style_class: 'panel-status-menu-box' });
        box.add_child(new St.Icon({ icon_name: 'audio-headphones-symbolic', style_class: 'system-status-icon' }));
        this._label = new St.Label({ y_align: Clutter.ActorAlign.CENTER });
        box.add_child(this._label);
        this._button.add_child(box);
        this._button.visible = false;

        // Click to re-read immediately, e.g. after switching the headset on.
        this._button.connect('button-press-event', () => {
            this._refresh();
            return Clutter.EVENT_STOP;
        });

        Main.panel.addToStatusArea(this.uuid, this._button, 0, 'right');

        this._refresh();
        this._timerId = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, INTERVAL_S, () => {
            this._refresh();
            return GLib.SOURCE_CONTINUE;
        });
    }

    _refresh() {
        let proc;
        try {
            proc = Gio.Subprocess.new([SCRIPT, '--waybar'],
                Gio.SubprocessFlags.STDOUT_PIPE | Gio.SubprocessFlags.STDERR_SILENCE);
        } catch (e) {
            this._show(null);
            return;
        }
        proc.communicate_utf8_async(null, null, (p, res) => {
            try {
                const [, stdout] = p.communicate_utf8_finish(res);
                this._show(JSON.parse(stdout));
            } catch (e) {
                this._show(null);
            }
        });
    }

    _show(status) {
        if (!this._button)
            return; // disabled while the script was running

        if (!status || status.percentage === undefined) {
            this._button.visible = false;
            return;
        }
        const charging = status.class === 'charging';
        this._label.text = ` ${status.percentage}%${charging ? ' ⚡' : ''}`;
        // Dim a cached reading the script returns while the headset is briefly unreachable.
        this._button.opacity = status.class === 'stale' ? 128 : 255;
        this._button.visible = true;
    }

    disable() {
        if (this._timerId) {
            GLib.source_remove(this._timerId);
            this._timerId = null;
        }
        this._button?.destroy();
        this._button = null;
        this._label = null;
    }
}
