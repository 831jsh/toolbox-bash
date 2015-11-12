#!/bin/bash
du -sch ${1}.[!.]* ${1}* | sort -rh | mail -s "du_${1}" my@example.com
