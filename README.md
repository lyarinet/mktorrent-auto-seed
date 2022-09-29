<h3 align="center">
<img src="https://cdn.rawgit.com/odb/official-bash-logo/master/assets/Logos/Identity/PNG/BASH_logo-transparent-bg-color.png">
</h3>

## mktorrent auto seed

## install rtorrent or mktorrent
```sh
[root@linux ~]# apt-get install rtorrent -y
```
```sh
[root@linux ~]# apt-get install mktorrent -y
```
and go to home directory or your `username` directory like 
```sh
[root@linux ~]# cd /home/username/
```
and create a file 
```sh
[root@linux ~]# nano .bash_aliases
```
and paste a code 
```sh
> alias create-torrent-movies='/home/user/torrentdata/scripts/movies.sh'
```
and change <code>user</code> to your `username`

and open terminal and type 
```sh
[root@linux ~]# source .bash_aliases
```
download mktorrent-auto-seed and move <code>torrentdata</code> directory to <code> /home/username/ </code>


Open All files on any text editor and find `user` and Change `user` to your `username`

open /home/username/.rtorrent.rc file 
```sh
[root@linux ~]# nano /home/username/.rtorrent.rc
```
change all <code>user</code> to your `username` on .rtorrent.rc 

and add a new line to your rtorrent.rc file
```sh
> import="/home/user/torrentdata/include.rc"
```
and change `user` to your `username` a line added

and block a line `schedule = watch_directory` to `#schedule = watch_directory`

and save file


```
# -- START HERE --
dht = auto
directory.default.set = /home/user/downloads/
encoding.add = UTF-8
encryption = allow_incoming,try_outgoing,enable_retry,require_RC4
execute.nothrow = chmod,777,/home/user/.config/rpc.socket
execute.nothrow = chmod,777,/home/user/.sessions
network.port_random.set = yes
network.port_range.set = 18012-19512
network.scgi.open_port = localhost:18012
network.tos.set = throughput
peer_exchange = yes
pieces.hash.on_completion.set = no
#schedule = watch_directory,5,5,load.start=/home/user/rwatch/*.torrent
session.path.set = /home/user/.sessions/
import="/home/user/torrentdata/include.rc"
throttle.global_down.max_rate.set = 0
throttle.global_up.max_rate.set = 0
throttle.max_peers.normal.set = 100
throttle.max_peers.seed.set = -1
throttle.max_uploads.global.set = 100
throttle.min_peers.normal.set = 1
throttle.min_peers.seed.set = -1
trackers.use_udp.set = yes
use_udp_trackers = yes
# -- END HERE --
```

and open a movies.sh file
```sh
[root@linux ~]# nano /home/username/torrentdata/scripts/movies.sh
```
and change `user` to your `username` if your data in `username` directory or change TORRENTS_DROPBOX_PATH data location to your data location like this
```sh
> TORRENTS_DROPBOX_PATH='/home/user/server/movies-directory/'
```
to your path location

and TORRENTS_PATH to your rtorrent watch directory change this to your (`*.torrent`) files stored your location 

and change tracker
```sh
> http://tracker.lyarinet.com:6969/announce
```
to your tracker URL


```bash markdown
#!/bin/sh
############################################################################
## Copyright (C) Asif Agaria 2020 - License: GNU GPLv3   		  ##
## Please see: http://www.gnu.org/licenses/gpl.html for legal details,    ##
## rights of fair usage, the disclaimer and warranty conditions. 	  ##
############################################################################

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
```

and open movies.rc file
```sh
[root@linux ~]# nano /home/username/torrentdata/include.d/movies.rc
```

```
# Movies Collection
schedule = watch_directory_1,5,5,"load_start=/home/user/torrentdata/torrentfiles/movies/*.torrent,d.set_directory=/home/user/server/movies-directory/"
schedule = tied_directory_1,5,5,start_tied=
schedule = untied_director_1,5,5,stop_untied=
```

and change `user` to your `username` and a (`*.torrent`) files stored

and change to your watch directory location path

> schedule = watch_directory_1,5,5,"load_start=/home/user/torrentdata/torrentfiles/movies/*.torrent,d.set_directory=/home/user/server/movies-directory/"

if you want to add more watch directory and set download to seed make like this


```
# Movies Collection
schedule = watch_directory_1,5,5,"load_start=/home/user/torrentdata/torrentfiles/movies/*.torrent,d.set_directory=/home/user/server/movies-directory/"
schedule = tied_directory_1,5,5,start_tied=
schedule = untied_director_1,5,5,stop_untied=

# games Collection
schedule = watch_directory_2,5,5,"load_start=/home/user/torrentdata/torrentfiles/games/*.torrent,d.set_directory=/home/user/server/games-directory/"
schedule = tied_directory_2,5,5,start_tied=
schedule = untied_director_2,5,5,stop_untied=
```

note most change next 

> `# games Collection`

> schedule = watch_directory_`2`,5,5,"load_start=/home/user/torrentdata/torrentfiles/games/*.torrent,d.set_directory=/home/user/server/games-directory/"

> schedule = tied_directory_`2`,5,5,start_tied=

> schedule = untied_director_`2`,5,5,stop_untied=

open terminal and type
```sh
[root@linux ~]# create-torrent-movies
```
and enter your torrent files created and move to watch directory auto seed
