# Work browser

Shadow runs a persistent Firefox browser container for work accounts.

URLs:

```text
http://shadow:7081
https://shadow:7443
```

Persistent profile/config data lives at:

```text
/home/daviziks/dev/.services/work-browser
```

The browser is exposed only on the Tailscale firewall interface. Use the HTTPS
endpoint first when testing browser features that require a secure context,
such as microphone permissions.
