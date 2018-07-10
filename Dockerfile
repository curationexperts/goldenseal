FROM registry.gitlab.com/notch8/washington-goldenseal/base:latest

ADD https://time.is/just build-time
COPY ops/nginx.sh /etc/service/nginx/run
COPY ops/webapp.conf /etc/nginx/sites-enabled/webapp.conf
COPY ops/env.conf /etc/nginx/main.d/env.conf

COPY . $APP_HOME

RUN unzip ops/fits-1.0.5.zip -d /opt
RUN chmod a+x /opt/fits-1.0.5/fits.sh
ENV PATH="/opt/fits-1.0.5:${PATH}"

RUN bundle check || bundle install
RUN chown -R app:app ./jetty

CMD ["/sbin/my_init"]
