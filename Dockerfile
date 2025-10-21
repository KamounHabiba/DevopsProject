# ---------- Stage 1: Build the application ----------
FROM maven:3.9.9-eclipse-temurin-21 AS builder

# Set working directory inside the container
WORKDIR /app

# Copy pom.xml and download dependencies (for better caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the rest of the source code
COPY src ./src

# Build the Spring Boot jar (skip tests for faster build)
RUN mvn clean package -DskipTests

# ---------- Stage 2: Run the application ----------
FROM eclipse-temurin:21-jdk

# Set working directory
WORKDIR /app

# Copy the built jar from the previous stage
COPY --from=builder /app/target/*.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
