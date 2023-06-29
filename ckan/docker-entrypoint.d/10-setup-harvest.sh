set -e

echo "Init Harvest database tables"
ckan harvester initdb

echo "turn on gather and fetch workers"
run_fetch () {
  until ckan harvester fetch-consumer; do
    sleep 1
  done
}
run_fetch &
ckan harvester fetch-consumer &
ckan harvester gather-consumer &

echo "check harvest job completion every 10 secs"
check_harvester () {
  while true
  do
    ckan harvester run &> /tmp/harvester_run.log
    sleep 10
  done
}

check_harvester &
