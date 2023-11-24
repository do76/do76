echo "BKMOB V1.6public | 2023-11-24"
deviceID=publicdevice
current_date=$(date "+%Y-%m")
#current_date=2023-10
ntytodrive=rclonemain:/$deviceID/$current_date

main () {
echo "Device: $deviceID"
echo "$ntytodrive/"
echo ""
countdown

# Record the start time
C_START_TIME=$(date +%s)
START_TIME=$(TZ='Europe/Vilnius' date)
echo "START: $(TZ='Europe/Vilnius' date)"

fastbkup
#fullsync

echo ""
echo "---------------------------------------------------"
timedurationcalc
#echo "START: $START_TIME"
#echo "  END: $(TZ='Europe/Vilnius' date)"
echo ""
#read -n 1 -s -r -p "Press any key to continue"
echo " "
exit
}

countdown() {
  local i=3
  while [ $i -gt 0 ]; do
    echo -n -e "\r[$i panic quit opportunity] "
    sleep 1
    i=$((i - 1))
  done
  #echo -e "\rTime remaining: 0 seconds      "
  echo -e "\r=========================================="
}

fastbkup () {
ntypathup=$ntytodrive/fast
echo "$ntypathup"
echo "Priority =========================================="
echo "DCIM"
rclone copy DCIM/ $ntypathup/DCIM --exclude="Snapchat/**" -P
echo "PICTURES"
rclone copy Pictures/ $ntypathup/Pictures --exclude=".thumbnails/*" -P
echo "Music"
rclone copy Music/ $ntypathup/Music -P
echo "DONE: DCIM and PICTURES and Music (recorder)"

echo "---------------------------------------------------"

source_dirs=("Download/docshistory/" "Download/docs/toreview/" "Download/docs/tax/")
}

fullsync () {
ntypathup=$ntytodrive/../full
# ../full in case dont want month tied full backup (therefore storage savings)
echo "$ntypathup"
echo "FULL SLOW SYNC ===================================="
rclone copy ./ $ntypathup --exclude="Snapchat/**" --exclude=".thumbnails/**" --exclude="Android/**" -P
}

timedurationcalc () {
C_END_TIME=$(date +%s)

# Calculate duration in seconds
DURATION_SECONDS=$((C_END_TIME - C_START_TIME))

if (( DURATION_SECONDS < 60 )); then
    # If less than a minute
    DURATION_STRING="$DURATION_SECONDS seconds"
elif (( DURATION_SECONDS < 3600 )); then
    # If less than an hour
    DURATION_MINUTES=$((DURATION_SECONDS / 60))
    DURATION_STRING="$DURATION_MINUTES minute(s) and $((DURATION_SECONDS % 60)) seconds"
else
    # If an hour or more
    DURATION_HOURS=$((DURATION_SECONDS / 3600))
    DURATION_MINUTES=$(((DURATION_SECONDS % 3600) / 60))
    DURATION_STRING="$DURATION_HOURS hour(s), $DURATION_MINUTES minute(s), and $((DURATION_SECONDS % 60)) seconds"
fi

echo "Start Time: $(date -d @"$C_START_TIME" '+%Y-%m-%d %H:%M:%S')"
echo "  End Time: $(date -d @"$C_END_TIME" '+%Y-%m-%d %H:%M:%S')"
echo "  Duration: $DURATION_STRING"
}
main
