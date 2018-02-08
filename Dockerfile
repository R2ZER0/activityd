FROM ubuntu:xenial AS base
RUN apt-get update && apt-get install -y wget ca-certificates gnupg \ 
 && sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
 && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && apt-get update

FROM base AS build
RUN apt-get install -y libevent-dev libpq-dev libssl-dev libc6-dev gcc libcurl3
RUN wget --quiet http://downloads.dlang.org/releases/2.x/2.078.1/dmd_2.078.1-0_amd64.deb && dpkg -i ./dmd_*.deb
RUN mkdir /app
WORKDIR /app
COPY *.json /app/
COPY source /app/source
RUN dub build --build=release --compiler=dmd

FROM base AS release
RUN apt-get install -y libpq5 libevent-2.0.5 libevent-pthreads-2.0.5 \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s /usr/lib/x86_64-linux-gnu/libpq.so.5 /usr/lib/x86_64-linux-gnu/libpq.so
COPY --from=build /app/activityd /activityd 

EXPOSE 8080
ENTRYPOINT ["/activityd"]
