FROM registry.gitlab.com/notch8/washington-goldenseal/base:latest

ADD https://time.is/just build-time
COPY ops/webapp.conf /etc/nginx/sites-enabled/webapp.conf
COPY ops/env.conf /etc/nginx/main.d/env.conf

COPY . $APP_HOME
RUN bundle check || bundle install

CMD ["/sbin/my_init"]
