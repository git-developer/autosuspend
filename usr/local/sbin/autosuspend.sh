#!/bin/bash

CONFLICT_EXIT_CODE=49
AUTOSUSPEND_LOCK_FILE=/var/run/autosuspend.lock

flock -n -E "$CONFLICT_EXIT_CODE" "$AUTOSUSPEND_LOCK_FILE" "/usr/local/sbin/autosuspend.main"
exit_code="$?"
case "$exit_code" in
  "0")
  ;;
  "$CONFLICT_EXIT_CODE") >&2 echo "The autosuspend script has been called although it is already running; the second call was aborted."
  ;;
  *) >&2 echo "The autosuspend script returned exit code $exit_code, see the system log for details"
  ;;
esac
