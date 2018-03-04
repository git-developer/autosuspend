# tvheadend-autosuspend

An extension to [Tvheadend](https://tvheadend.org/) that will _suspend_ your system when it is _inactive_ and wake it right before the next scheduled recording.

**Suspend** can be configured to be one of

* `suspend`
* `hibernate`
* `hybrid-suspend` and
* `poweroff`

**Activity** means

* Tvheadend activity:  
  * Running or upcoming recordings
  * Subscriptions, e.g. live TV or EPG grabbing
  * Connected clients, e.g. Kodi or web interface
* System activity as defined in the [Ubuntu AutoSuspend](https://wiki.ubuntuusers.de/Skripte/AutoSuspend/) script, e.g.
  *  Running daemons
  *  Running applications
  *  Connected samba clients
  *  Reachable network clients
* Additional system activity is monitored
  *  Kodi activity (library update, active players)
  *  Connections to streaming services on the machine can be detected

This script is based on `systemd` and does not make use of `pm-utils`. It has been tested on Debian 8 (Jessie) with Tvheadend build 4.0.8~jessie. It should work on systems that meet the dependencies listed below.

## Prerequisites
* systemd (part of Debian 8)
* A running Tvheadend service

## Installation
1.  Copy the files from this git repository to your system.
1.  Install the dependencies
  * `rtcwake` (package util-linux, part of Debian 8) OR [`wittyPi`](http://www.uugear.com/product/wittypi2/)
 * `netstat` (package net-tools, part of Debian 8)
 * `curl`
 * [`xmlstarlet`](http://xmlstar.sourceforge.net/)
 * [`jq`](https://stedolan.github.io/jq/)
 * `bc`

On Debian based systems, dependencies may be installed using the command

    $ sudo apt-get install util-linux net-tools curl xmlstarlet jq bc

On raspberry pi platforms, the wittyPi module can be used to schedule the in-time-boot processes

## Configuration
Edit `/etc/autosuspend` according to your needs. Credentials for tvheadend are **required**, e.g.

    # User for access to the Tvheadend REST API
    TVHEADEND_USER=hts

    # Password for access to the Tvheadend REST API
    TVHEADEND_PASSWORD=hts

All other values are optional.

It is possible to work with an existing Tvheadend user, but I recommend to create a separate account to keep things clear. The following rights are required:

* Web Interface
* Admin
* Video Recorder

Details on the configuration of system activity can be found in the [Ubuntu users wiki](https://wiki.ubuntuusers.de/Skripte/AutoSuspend/) (german).

## Links
* [AutoSuspend](https://wiki.ubuntuusers.de/Skripte/AutoSuspend/)
* [Standby und Wakeup für Tvheadend - Bash-Skript für Ubuntu 14.04](http://motobiff.blogspot.de/2015/08/standby-und-wakeup-fur-tvheadend-bash.html)
* [Power-saving techniques - sleep](https://tvheadend.org/boards/5/topics/12775)
* [HowTo wakeup XBMC/TVHeadend for scheduled recording.](https://tvheadend.org/projects/tvheadend/wiki/Wakeup)
