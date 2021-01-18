FROM google/dart:2.8.4 as builder

WORKDIR /aqueduct
ADD ./aqueduct /aqueduct
WORKDIR /aqueduct/aqueduct
RUN pub get
RUN pub global activate --source path .

WORKDIR /common
ADD ./common /common/
RUN pub get

WORKDIR /app
ADD ./server /app/
RUN pub get

RUN pub run aqueduct build

FROM debian as production

WORKDIR /usr/src/app

COPY --from=builder /app ./

EXPOSE 80

ENTRYPOINT ["./test_server.aot"]