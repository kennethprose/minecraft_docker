# Use a base image with Java Runtime Environment
FROM outdead/rcon:latest

# Install OpenJDK-8
RUN apk add openjdk17-jre

COPY rcon.yaml /rcon.yaml

# Set the working directory to /server
WORKDIR /server

# Define the entry point for the container to run the start.sh file
ENTRYPOINT ["sh", "start.sh"]