#!/bin/bash
set -e
if [[ ! -e /var/log/nginx/error.log ]]; then
        # The Nginx log forwarder might be sleeping and waiting
        # until the error log becomes available. We restart it in
        # 1 second so that it picks up the new log file quickly.
        (sleep 1 && sv restart /etc/service/nginx-log-forwarder)
fi

/sbin/setuser app /bin/bash -l -c 'cd /home/app/webapp && ./bin/setup'

if [ -z $PASSENGER_APP_ENV ]
then
    export PASSENGER_APP_ENV=development
fi

if [[ $PASSENGER_APP_ENV == "production" ]] || [[ $PASSENGER_APP_ENV == "staging" ]]
then
  /sbin/setuser app /bin/bash -l -c 'cd /home/app/webapp && bundle exec rake db:migrate'
fi

exec /usr/sbin/nginx
