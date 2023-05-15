FROM --platform=$BUILDPLATFORM clojure:temurin-17-tools-deps-1.11.1.1273-bullseye-slim AS builder
WORKDIR /usr/src/fluree-core

COPY deps.edn ./

RUN clojure -P && clojure -A:build -P

COPY . ./

RUN clojure -T:build uber

FROM eclipse-temurin:17-jre-jammy AS runner

WORKDIR /opt/fluree-core

COPY --from=builder /usr/src/fluree-core/target/fluree-core-*.jar ./fluree-core.jar

EXPOSE 8090

VOLUME ./data

ENTRYPOINT ["java", "-jar", "fluree-core.jar"]
CMD ["docker"]
