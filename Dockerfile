FROM google/dart

WORKDIR /common
ADD ./common/pubspec.* /common/
RUN pub get --no-precompile
ADD ./common /common/
RUN pub get --offline --no-precompile

WORKDIR /app
ADD ./server/pubspec.* /app/
RUN pub get --no-precompile
ADD ./server /app/
RUN pub get --offline --no-precompile

EXPOSE 80

ENTRYPOINT pub run aqueduct db upgrade --connect $DATABASE_URL && pub run aqueduct serve --port 80