FROM openjdk:17-jdk-slim

WORKDIR /app

# Install curl for health check
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

COPY target/*.jar app.jar

EXPOSE 8888

ENV SPRING_PROFILES_ACTIVE=native

HEALTHCHECK --interval=10s --timeout=3s --start-period=30s \
  CMD curl -f http://localhost:8888/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"] 