This directory contains activity scripts for autosuspend.

## Description
An *activity script* is an executable script (`chmod +x`) that outputs one or
more lines containing a timestamp and optionally a colon-separated comment. Autosuspend will respect these timestamps when preparing the next wake up.

## Syntax of output lines
`<timestamp>` or `<timestamp>:<comment>`

## Example output
```
1475272800
1475272800:Weekly backup
```

## Example commands
```shell
date --date="next Wednesday 11:28" +%s
echo $(date --date="next Saturday 11:28" +%s):Weekly backup
```
