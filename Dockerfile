FROM --platform=$BUILDPLATFORM clojure:temurin-17-tools-deps-1.11.1.1273-bullseye-slim AS builder
WORKDIR /usr/src/fluree-server

COPY deps.edn ./

RUN clojure -P && clojure -A:build -P

COPY . ./

RUN clojure -T:build uber

FROM eclipse-temurin:17-jre-jammy AS runner

WORKDIR /opt/fluree-server

COPY --from=builder /usr/src/fluree-server/target/fluree-server-*.jar ./fluree-server.jar

EXPOSE 8090

VOLUME ./data

ENTRYPOINT ["java", "-jar", "fluree-server.jar"]
CMD ["docker"]
