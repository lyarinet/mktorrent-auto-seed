#!/bin/sh
################################################## #########################
## Copyright (C) Asif Agaria 2020 - License: GNU GPLv3   			      ##
## Please see: http://www.gnu.org/licenses/gpl.html for legal details,    ##
## rights of fair usage, the disclaimer and warranty conditions. 		  ##
################################################## #########################

# The path to where torrent files (*.torrent) are stored.
TORRENTS_PATH='/home/user/torrentdata/torrentfiles/movies/'
# The path to where Data Directory (Data) are stored.
TORRENTS_DROPBOX_PATH='/home/user/server/movies-directory/'		 


for DIRECTORY in $TORRENTS_PATH $DROPBOX_PATH; do
if [ ! -d $DIRECTORY ]; then
echo "Could not find $DIRECTORY."
fi
done

cd $TORRENTS_DROPBOX_PATH
IFS=","; for TORRENT in `find . ! -name . -prune -type d`; do
if [ -f $TORRENT.torrent ]; then
rm $TORRENT.torrent
fi
done
#for TORRENT in $TORRENTS_DROPBOX_PATH `ls -1t | head -n 2`;
ls -1t | head -n 1000 | while read TORRENT
do
	mktorrent -v -p -a http://tracker.lyarinet.com:6969/announce -o "$TORRENT.torrent" "$TORRENT"

if [ -f $TORRENTS_PATH/$TORRENT.torrent ]; then
SUM_NEW=`shasum $TORRENT.torrent | awk '{ print $1 }'`
SUM_OLD=`shasum $TORRENTS_PATH/$TORRENT.torrent | awk '{ print $1 }'`
if [ $SUM_NEW == $SUM_OLD ]; then
exit
fi
fi

mv $TORRENT.torrent $TORRENTS_PATH

done

