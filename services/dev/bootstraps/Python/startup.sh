
# Start the git autoupdate
while [ "$GIT_PULL" = "true" ] ; then 
    git pull ; 
    sleep 60*60*4 # Update every 4 hours
fi

# Start SSH service
/usr/sbin/sshd -D &

# Set the entry point to run the Python script
python -u $MAIN_PY_FILE


