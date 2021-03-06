FROM alpine:latest AS app-src
RUN apk add --no-cache git
RUN mkdir /app-src
WORKDIR /app-src
RUN git clone --depth=1 https://github.com/kyleratti/a-centralized-mirror.git .

FROM alpine:latest
RUN apk add --no-cache curl
RUN mkdir /scripts
COPY --from=app-src /app-src/scripts/acm-crontab.sh /scripts/acm-crontab.sh
RUN chmod +x /scripts/acm-crontab.sh
#RUN touch /var/log/acm-crontab.log
#RUN crond --help
#RUN ln -sf /proc/$$/fd/1 /var/log/acm-crontab.log
#RUN chmod 0777 /var/log/acm-crontab.log
RUN echo "* * * * * /bin/sh /scripts/acm-crontab.sh" > /var/spool/cron/crontabs/root
#CMD "echo '* * * * * /scripts/acm-crontab.sh' | crontab - && crond -f -L /var/log/acm-crontab.log"
CMD crond -f -l 2
