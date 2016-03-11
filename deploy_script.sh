#!/bin/bash

RESTART_TYPE = $1

echo "Navigating to ejabberd directory"
cd  /apps/ejabberd-15.04/

if [ "$RESTART_TYPE" = "hard" ]; then

    echo "Moving files to app ebin directory"
    sudo mv /home/hk15052/*.beam /apps/ejabberd-15.04/lib/ejabberd-15.04/ebin/
    echo "Hard restarting ejabberd"
    sudo ./bin/ejabberdctl restart
    tail -f logs/ejabberd.log &
    tailpid=$!
    sleep 20
    kill $tailpid
elif [ "RESTART_TYPE" = "soft" ]; then
    echo "Soft restarting ejabberd. TODO "
else
    echo "Restart type not defined."
fi

echo "exiting remote terminal session"
exit
