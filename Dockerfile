FROM --platform=$BUILDPLATFORM clojure:temurin-17-tools-deps-1.11.1.1273-bullseye-slim AS builder
WORKDIR /usr/src/fluree-server

COPY deps.edn ./

RUN clojure -P && clojure -A:build -P

COPY . ./

RUN clojure -T:build uber

FROM eclipse-temurin:17-jre-jammy AS runner

RUN apt-get update && apt-get install -y dumb-init

RUN addgroup --system fluree && adduser --system --ingroup fluree fluree
RUN mkdir -p /opt/fluree-server && chown -R fluree. /opt/fluree-server
USER fluree

WORKDIR /opt/fluree-server

COPY --from=builder /usr/src/fluree-server/target/fluree-server-*.jar ./fluree-server.jar

ENV JDK_JAVA_OPTIONS "-XshowSettings:system -XX:+UseContainerSupport -XX:MaxRAMPercentage=85"

EXPOSE 8090

VOLUME ./data

ENTRYPOINT ["/usr/bin/dumb-init", "--", "java", "-jar", "fluree-server.jar"]
CMD ["docker"]
