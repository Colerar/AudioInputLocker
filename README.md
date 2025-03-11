# AudioInputLocker

Lock input audio device to selected.

## Usage

```shell
# List available input audio devices
> ail ls
61  - WeMeet Audio Device
90  - Loopback Audio
140 - MacBook Pro Microphone
# Lock
> ail lock 140
Running
Locking to `MacBook Pro Microphone`
Input Device Changed!
Current input device is `Loopback Audio`, instead of selected `MacBook Pro Microphone`, locking...
```

### Run as Daemon

Create a `me.colerar.ail.plist` and
put it into `~/Library/LaunchAgents`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>me.colerar.ail</string>
    <key>ProgramArguments</key>
    <array>
        <string>/path/to/ail lock <ID></string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

You can reboot your machine or run:

```bash
launchctl load -w ~/Library/LaunchAgents/me.colerar.ail.plist
```

to make it work immediately.

## Build

Requirements:

- Obviously, macOS and `Xcode.app`

```shell
./build.sh
```

Universal binary (`arm64` and `x86_64`) will be generated at `.build/ail`.

## License

Distributed under the terms of [the MIT License](LICENSE).

