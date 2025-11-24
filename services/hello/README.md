

# Stuff that didn't work
`hello.sh`
```
#!/usr/bin/env bash
set -euo pipefail

LOG=/tmp/systemd-hello.log

echo "$(date) - Hello from systemd service!" >> $LOG

while true; do
    echo "$(date) - Still running..." >> $LOG
    sleep 60
done
EOF
```

hello.service
```
[Unit]
Description=Hello World systemd POC service
After=network.target

[Service]
Type=simple
User=%u
WorkingDirectory=%h/Development/systemd-stuff/services/hello
ExecStart=%h/Development/systemd-stuff/services/hello/hello.sh
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
```

This resulted in 
```
jcc@machine~/D/s/s/hello❯ systemctl status hello.service
● hello.service - Hello World systemd POC service
     Loaded: loaded (/etc/systemd/system/hello.service; disabled; preset: enab>
     Active: activating (auto-restart) (Result: exit-code) since Sat 2025-11-2>
    Process: 210142 ExecStart=/root/Development/systemd-stuff/services/hello/h>
   Main PID: 210142 (code=exited, status=203/EXEC)
        CPU: 1ms
```

This is because the %u and %h are both pointing to root. When we copy to the `etc/systemd/system` directory, this service becomes a **system service**. Meaning that %u in this case is a service user and not a login user.

---
In order for this to work on anyone else's computer, here are the commands. Need to make sure that hello.sh is executable, then make the `/.config/systemd/user` directory. By doing it this way, we ensure that the %h in the .service file points to the `/home/user` directory

```
chmod +x hello.sh
mkdir -p ~/.config/systemd/user
cp hello.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user enable --now hello.service
systemctl --user status hello.service
```