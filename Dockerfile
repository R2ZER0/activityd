FROM ubuntu:xenial 

RUN apt-get update && apt-get install -y wget ca-certificates gnupg 
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get install -y libevent-dev libpq-dev libssl-dev libc6-dev gcc libcurl3
RUN wget --quiet http://downloads.dlang.org/releases/2.x/2.078.1/dmd_2.078.1-0_amd64.deb && dpkg -i ./dmd_*.deb
RUN mkdir /app
WORKDIR /app
COPY *.json /app/
COPY source /app/source
RUN dub build --build=release

EXPOSE 8080
ENTRYPOINT ["/app/activityd"]
