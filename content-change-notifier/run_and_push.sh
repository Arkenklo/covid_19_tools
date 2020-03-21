#!/bin/bash
# This script exists to automatomatically run content_updates.py from cron
# Author: Robert Arkenklo robert@arkenklo.se

# Quit if any command fails
set -e

# Where is this script located?
MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Which repo do we commit output history to?
HISTORY_REPO="git@github.com:Arkenklo/covid_19_tools_content.git"

# Get latest version, and run the content-change-notifier script
cd $MYDIR
git fetch
git checkout master
./run_ubuntu.sh

# Save output history to separate git repository
if [ ! -d /tmp/covid_19_tools_content ]; then
	# Clone repo if it doesn't exist
	git clone $HISTORY_REPO /tmp/covid_19_tools_content
fi
cd /tmp/covid_19_tools_content
git pull
git reset --hard origin/master
cp $MYDIR/prev_contents.pickle ./
git add prev_contents.pickle
git commit -m "Automated scraper checkin $(date +%Y-%m-%d_%T)"
git push
cd -
