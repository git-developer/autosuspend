# autosuspend
Autosuspend script for [Tvheadend](https://tvheadend.org/) on Debian 8 (Jessie)

Tested with Tvheadend 4.0.8~jessie

##Prerequisites
* systemd (part of Debian 8)
* A running Tvheadend service

##Dependencies
* `rtcwake` (package util-linux, part of Debian 8)
* `netstat` (package net-tools, part of Debian 8)
* `curl`
* [`xmlstarlet`](http://xmlstar.sourceforge.net/)
* [`jq`](https://stedolan.github.io/jq/)

The dependencies may be installed using the following command

```
$ sudo apt-get install util-linux net-tools curl xmlstarlet jq
```

##Configuration
This script is derived from [AutoSuspend](https://wiki.ubuntuusers.de/Skripte/AutoSuspend/), see the documentation for details.

Edit `/etc/autosuspend` as desired. It is required to add credentials for tvheadend, e.g.

    # User for access to the Tvheadend REST API
    TVHEADEND_USER=hts

    # Password for access to the Tvheadend REST API
    TVHEADEND_PASSWORD=hts

It is possible to work with an existing user, but I recommend to create a dedicated one. The following rights are required:

* Web Interface
* Admin
* Video Recorder

##Links
* [AutoSuspend](https://wiki.ubuntuusers.de/Skripte/AutoSuspend/)
* [Standby und Wakeup für Tvheadend - Bash-Skript für Ubuntu 14.04](http://motobiff.blogspot.de/2015/08/standby-und-wakeup-fur-tvheadend-bash.html)
* [Power-saving techniques - sleep](https://tvheadend.org/boards/5/topics/12775)
* [HowTo wakeup XBMC/TVHeadend for scheduled recording.](https://tvheadend.org/projects/tvheadend/wiki/Wakeup)
