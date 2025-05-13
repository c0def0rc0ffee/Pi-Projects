## Pi Photo Frame + Kiosk Touch Panel

* A fullscreen **photo slideshow** powered by `feh`.
* A **Home Assistant control panel** in Chromium kiosk mode.
* Touching the screen closes the photo viewer, revealing the control panel underneath. After a short while, the slideshow returns automatically.

### Requirements

#### Hardware

* Raspberry Pi (3 or newer)
* Some kind of touchscreen device or another that can be detected by `evtest`
* Network access to Home Assistant

#### Software

Install the following packages on your Raspberry Pi (Raspberry Pi OS recommended):

```bash
sudo apt update
sudo apt install -y feh chromium-browser evtest

```

Optional:

```bash
# Allow evtest to run without sudo (adjust if needed)
sudo chmod +r /dev/input/event*
```

### Files Overview

| File                   | Description                                                              |
| ---------------------- | ------------------------------------------------------------------------ |
| `auto-restart-feh.sh`  | Restarts the `feh` slideshow if it stops or is closed                    |
| `touch-to-kill-feh.sh` | Listens for touch input and kills `feh` when the screen is touched       |
| `start-kiosk.sh`       | Starts Chromium in kiosk mode and loads the Home Assistant control panel |
| `auto-manager.sh`      | Master script to start all the others automatically                      |
| `Pictures/`            | Folder containing `Holiday/` and `Others/` subfolders with your images   |

### Setup

Before beginning, create the log directory:

```bash
mkdir -p /home/pi/logs
```

1. Run evtest and look for the touchscreen device's `event%` path:

```bash
evtest
```

Look for something like:

```bash
/dev/input/event0:      ADS7846 Touchscreen
```

2. Edit `touch-to-kill-feh.sh` and update the device name line to match your touchscreen:

```bash
EVENT_PATH=$(grep -1 "ADS7846 Touchscreen" /sys/class/input/event*/device/name | awk -F: '{print $1}' | sed -E 's:.*/(event[0-9]+)/device/name$:/dev/input/\1:')
```

3. (Optional) Adjust slideshow settings in `auto-restart-feh.sh`

You can tweak the `feh` command line to change slideshow behaviour. Example:

```bash
feh --zoom fill --slideshow-delay 25 --fullscreen --hide-pointer --randomize ./Pictures/Holiday &
```

4. Make scripts executable:

```bash
chmod +x *.sh
```

5. Create folders for your images:

```bash
mkdir -p ~/Pictures/Holiday ~/Pictures/Others
```

Then add `.jpg`, `.png`, or other image files to those folders.

6. Edit the Chromium URL (optional)

In `start-kiosk.sh`, update the URL if your Home Assistant IP or panel path is different.

7. Run the whole setup:

```bash
./auto-manager.sh
```

You can also add this script to your autostart routine.

### Autostart on Boot (GUI Login)

If you're using Raspbian with auto-login enabled into the GUI, you can auto-start the slideshow system using the standard desktop startup method:

1. Ensure your script includes a delay if needed:

```bash
#!/bin/bash
sleep 120
# your commands follow...
```

2. Make the script executable:

```bash
chmod +x /home/pi/auto-manager.sh
```

3. Create the autostart directory if it doesn’t exist:

```bash
mkdir -p ~/.config/autostart
```

4. Create the `.desktop` launcher file:

```bash
nano ~/.config/autostart/auto-manager.desktop
```

Paste the following into it:

```ini
[Desktop Entry]
Type=Application
Name=Auto Manager
Exec=/home/pi/auto-manager.sh
X-GNOME-Autostart-enabled=true
```

To embed the sleep inside the `.desktop` file, wrap it properly using `bash -c` instead:

```ini
Exec=bash -c 'sleep 120; /home/pi/auto-manager.sh'
```

5. Save and reboot:

```bash
sudo reboot
```

Your script will run automatically after login. No need for `systemd` unless you want pre-login behaviour or finer control.

### Notes

* This setup assumes a Goodix or similar touchscreen. If you’re using another brand, update the name match in `touch-to-kill-feh.sh` accordingly.
* Touching the screen closes the photo viewer. After 2 minutes, the photo viewer resumes automatically.
* Logs are stored in the `/home/pi/logs/` directory.
* `auto-manager.sh` launches three key scripts in the background using `nohup`:

  * `touch-to-kill-feh.sh`: Kills `feh` when the screen is touched.
  * `auto-restart-feh.sh`: Restarts `feh` every 15 minutes if it isn’t running.
  * `start-kiosk.sh`: Launches Chromium in kiosk mode.

Make sure all scripts are executable:

```bash
chmod +x /home/pi/*.sh
mkdir -p /home/pi/logs
```

Reboot to apply changes:

```bash
sudo reboot
```

Then check that everything is running:

```bash
ps aux | grep feh
ps aux | grep chromium
```

You can also monitor logs:

```bash
tail -f /home/pi/logs/feh-killer.log
```

```bash
tail -f /home/pi/logs/feh-resurrect.log
```

```bash
tail -f /home/pi/logs/chromium.log
```

###
