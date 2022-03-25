#!/bin/sh
#
# shalla_update.sh, v 0.3 20070418
# done by kapivie at sil.at under FreeBSD
# without any warranty
#
#--------------------------------------------------
# little script (for crond)
# to fetch and modify new list from shalla.de
#--------------------------------------------------
#
# *check* paths and squidGuard-owner on your system
# try i.e. "which squid" to find out the path for squid
# try "ps aux | grep squid" to find out the owner for squidGuard
#     *needs wget*
#

squidGuardpath="/usr/local/bin/squidGuard"
squidpath="/usr/local/sbin/squid"
httpget="/usr/local/bin/wget"
tarpath="/usr/bin/tar"
chownpath="/usr/sbin/chown"

dbhome="/var/db/squidGuard"     # like in squidGuard.conf
squidGuardowner="squid:squid"

##########################################

workdir="/tmp"
shallalist="http://www.shallalist.de/Downloads/shallalist.tar.gz"


# download actual shalla's blacklist
# thanks for the " || exit 1 " hint to Rich Wales
$httpget $shallalist -O $workdir/shallalist.tar.gz || exit 1
$tarpath xzf $workdir/shallalist.tar.gz -C $workdir || exit 1

# remove entry from porn-list: "krone.at"
# (too popular in Austria to be forbidden ;-)
# grep -vx krone.at $workdir/BL/porn/domains > $workdir/domains
# cp $workdir/domains $workdir/BL/porn/

# create new local database
rm -r $dbhome
mv $workdir/BL $dbhome
$squidGuardpath -C all

$chownpath -R $squidGuardowner $dbhome

$squidpath -k reconfigure


