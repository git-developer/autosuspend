#!/bin/bash
# code from https://github.com/git-developer/autosuspend

. /etc/autosuspend
. /usr/local/sbin/autosuspend.tvheadend-functions
. /usr/local/sbin/autosuspend.mediacenter-functions


logit()
{
        logger -p local0.notice -i -t autosuspend -- $*
	return 0
}

IsOnline()
{
	for i in $*; do
		ping $i -c1
		if [ "$?" == "0" ]; then
		  logit "PC $i is still active, auto suspend terminated"
		  return 1
		fi
	done
	return 0
}

IsRunning()
{
	for i in $*; do
		if [ `pgrep -c $i` -gt 0 ] ; then
			logit "$i still active, auto suspend terminated"
			return 1
		fi
	done
	return 0
}

IsDaemonActive()
{
	for i in $*; do
		if [ `pgrep -c $i` -gt 1 ] ; then
			logit "$i still active, auto suspend terminated"
			return 1
		fi
	done
	return 0
}

IsBusy()
{
        # Samba
        if [ "x$SAMBANETWORK" != "x" ]; then
                samba_status=$(/usr/bin/smbstatus -b | grep "$SAMBANETWORK")
                if [ "$samba_status" ]; then
                    logit "Connected samba clients: $samba_status"
                    logit "samba connected, auto suspend terminated"
                    return 1
                fi
        fi

	#daemons that always have one process running
	IsDaemonActive $DAEMONS
	if [ "$?" == "1" ]; then
		return 1
	fi

	#backuppc, wget, wsus, ....
	IsRunning $APPLICATIONS
	if [ "$?" == "1" ]; then
			return 1
	fi

	# Read logged users
	USERCOUNT=`who | wc -l`;
	# No Suspend if there are any users logged in
	test $USERCOUNT -gt 0 && { logit "some users still connected, auto suspend terminated"; return 1; }

	IsOnline $CLIENTS
	if [ "$?" == "1" ]; then
		return 1
	fi

        # Tvheadend
        IsTvheadendBusy
        if [ "$?" == "1" ]; then
                return 1
        fi

        # Kodi
        IsKodiBusy
        if [ "$?" == "1" ]; then
                return 1
        fi

        # Streaming
        IsStreamActive
        if [ "$?" == "1" ]; then
                return 1
        fi

        return 0
}

COUNTFILE=/var/spool/suspend_counter
OFFFILE=/var/spool/suspend_off

# turns off the auto suspend
if [ -e "$OFFFILE" ]; then
	logit "auto suspend is turned off by existence of $OFFFILE"
	exit 0
fi

if [ "$AUTO_SUSPEND" = "true" ] || [ "$AUTO_SUSPEND" = "yes" ] ; then
	IsBusy
	if [ "$?" == "0" ]; then
		# was it not busy already last time? Then suspend.
		if [ -e "$COUNTFILE" ]; then
			# only auto-suspend at night
			if [ \( "$DONT_SUSPEND_BY_DAY" != "true" -a "$DONT_SUSPEND_BY_DAY" != "yes" \) -o \( "`date +%H`" -ge "3" -a "`date +%H`" -lt "8" \) ]; then
				# notice resume-plan
				NEXTWAKE="0"
                                if [ -e /etc/autosuspend_resumeplan ]; then
					while read line; do
						if [ "`date +%s -d \"$line\"`" -gt "`date +%s`" -a  \( "`date +%s -d \"$line\"`" -lt "$NEXTWAKE" -o "$NEXTWAKE" = "0" \) ]; then
							NEXTWAKE="`date +%s -d \"$line\"`"
						fi
					done < /etc/autosuspend_resumeplan
				fi
				if [ "$NEXTWAKE" -gt "`date +%s`" ]; then
					if [ "$NEXTWAKE" -gt "`expr \"\`date +%s\`\" + 1800`" ]; then
						echo "0" > /sys/class/rtc/rtc0/wakealarm
						echo "$NEXTWAKE" > /sys/class/rtc/rtc0/wakealarm
						logit "will resume at $NEXTWAKE"
					else
						logit "do not suspend because would have been awaken within next 30 minutes"
						exit 0
					fi
				fi
				# and suspend or reboot:
				rm -f "$COUNTFILE"
				if [ "$REBOOT_ONCE_PER_WEEK" = "true" -o "$REBOOT_ONCE_PER_WEEK" = "yes" ] && [ "`echo \"scale=2; ( \`cat /proc/uptime | cut -d' ' -f1-1\` / 3600 / 24 ) >= 7\" | bc`" -gt 0 ]; then
					logit "REBOOTING THE MACHINE BECAUSE IT HAS BEEN RUNNING FOR MORE THAN A WEEK"
					shutdown -r now
				else
					logit "AUTO SUSPEND CAUSED"
                                        suspend_method=${SUSPEND_METHOD:-hibernate}
                                        logit "Suspend method: $suspend_method"
                                        SetWakeupTime
                                        case "$suspend_method" in
                                            "suspend")      systemctl suspend
                                            ;;
                                            "hibernate")    systemctl hibernate
                                            ;;
                                            "hybrid-sleep") systemctl hybrid-sleep
                                            ;;
                                            "poweroff")     systemctl poweroff
                                            ;;
                                            *) logit "Aborting because of unsupported suspend method: $suspend_method"
                                            ;;
                                        esac
				fi
			else
				logit "did not auto suspend because it is broad day"
			fi
			exit 0
		else
			# shut down next time
			touch "$COUNTFILE"
			logit "marked for suspend in next try"
			exit 0
		fi
	else
		rm -f "$COUNTFILE"
		logit "aborted"
		exit 0
	fi
fi

logit "malfunction"
exit 1
