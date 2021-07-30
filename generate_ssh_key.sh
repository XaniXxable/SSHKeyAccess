#!/bin/bash

readonly SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
filename_for_key=$1
comment_for_key=$2
dest_username="NULL"
dest_host_password=0
KEY_DEST=$SCRIPT_DIR/keys_$filename_for_key;

mkdir -p $KEY_DEST

if [[ $filename_for_key && $comment_for_key ]]
then
    ssh-keygen -t ed25519 -f $KEY_DEST/$filename_for_key -N '' -C "$comment_for_key"
else
    echo 'Usage: ./generate_shh_key.sh filename-for-key comment-for-key';
    exit -1
fi

read -p "Enter username of the destination host.`echo $'\n> '`" dest_username
read -p "Enter ip address of the destination host.`echo $'\n> '`" dest_host
read -p "Enter password of the destination host. Or enter for default password.`echo $'\n> '`" user_input

if [ ${#user_input} != 0 ];
then
    dest_host_password=$user_input;
fi

echo 'Try to connect to' $dest_username'@'$dest_host;

ssh-copy-id -i ./$filename_for_key.pub $dest_username@$dest_host