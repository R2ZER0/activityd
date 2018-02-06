FROM debian:stretch

RUN apt-get update && apt-get install -y wget ca-certificates gnupg 
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get install -y libpq5 postgresql-client-10 libevent-pthreads-2.0-5
COPY ./activityd /activityd

EXPOSE 8080
ENTRYPOINT ["/activityd"]
