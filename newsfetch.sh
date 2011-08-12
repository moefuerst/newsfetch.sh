#!/bin/bash
#
# newsfetch
# 08/2011 by Moritz F. Fuerst
#
# Fetches Calibre Recipes from a specified dir, turns them into Kindle-Newspapers via "ebook-convert" 
# and sends them to your kindle e-mail adress with "calibre-smtp"
#
# Dependencies: 
# - Calibre command line tools (You have to install them via calibre options dial.) 
# - rmtrash (install via Homebrew or get it here http://www.nightproductions.net/cli.htm, 
#   moves output to finder trash instead of removing it from the file system), 
#   (or just change to rm below if you want)
#
#
# Usage: newsfetch <RECIPE>
#

RECIPES_PATH="/path/to/some/recipes"
OUTPUT_PATH="/output/dir"

KINDLE_ADDR="yourkindle@free.kindle.com"

SMTP_SERVER="smtp.mail.com"
SMTP_MAILADDR="name@mail.com"
SMTP_USER="user"
SMTP_PWD="pass"

NO_ARGS=0
E_OPTERROR=65


if [ $# -eq "$NO_ARGS" ] 
then
    echo "------------------------------------------------------------------"
	echo "Usage: `basename $0` <RECIPE>  "
	echo "------------------------------------------------------------------"
	echo "Example: `basename $0` atlantic (fetches The Atlantic) "
	echo "You can specify multiple recipes to fetch: `basename $0` atlantic time (fetches The Atlantic and Time Magazine) "
	echo "Your recipes directory is ${RECIPES_PATH}"	
	exit $E_OPTERROR
fi


for var in "$@"
do
  ebook-convert "${RECIPES_PATH}/${var}.recipe" "${OUTPUT_PATH}/${var}.mobi" --output-profile kindle
  calibre-smtp -r $SMTP_SERVER -u $SMTP_USER -p $SMTP_PWD -s "Send to Kindle" -a "${OUTPUT_PATH}/${var}.mobi" -vv $SMTP_MAILADDR $KINDLE_ADDR "Send to Kindle"
  rmtrash "${OUTPUT_PATH}/${var}.mobi" 
done

exit