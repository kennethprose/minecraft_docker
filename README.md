# Minecraft Docker

[![Docker Pulls](https://badgen.net/docker/pulls/roseatoni/minecraft_docker?icon=docker&label=pulls)](https://hub.docker.com/r/roseatoni/minecraft_docker)
[![Image Size](https://badgen.net/docker/size/roseatoni/minecraft_docker?icon=docker&label=size)](https://hub.docker.com/r/roseatoni/minecraft_docker)

This project aims to benefit from the low overhead of containerization, while not making any sacrifices when hosting your own Minecraft server.

Instead of incorporating the Minecraft server files, config files, etc. in the docker image directly, I wanted an image that would map everything to an external directory. This not only makes it significantly easier to get existing servers ported over to docker, but it allows you full control over the Minecraft files, including installing Fabric, Forge, mods, etc.

I used a docker [base image created by gorcon](https://github.com/gorcon/rcon-cli). I found it was easier to add Minecraft to a RCON image than it was to add RCON to a Minecraft image. Thanks to gorcon for their work.

## Prerequisites

---

1. You must have a start.sh file in your Minecraft server directory. This is what docker will be looking for to start up the container. This will also allow you to have custom server launch parameters. An example start.sh file would look something like this:

```sh
#!/bin/bash
java -Xmx8G -Xms8G -jar server.jar nogui
```

2. It is highly recommended to enable [RCON](https://developer.valvesoftware.com/wiki/Source_RCON_Protocol) on your server. You will need to do this to send any commands to the server such as whitelisting or kicking players. In the server.properties file, make sure the following settings are as follows:

```
rcon.port=25575
enable-rcon=true
rcon.password=minecraftrcon
```

NOTE: The RCON password is hardcoded in the rcon.yaml config file I created, to make the process of connecting more seamless. While this would normally be ill-advised, this should not be a concern in this instance as we are not exposing the RCON port outside of the docker container. All connections are being made internally.

If you would still feel more comfortable creating your own password, simply change the rcon.yaml file and rebuild the docker image.

## Deployment

---

The Docker image is [available on Docker Hub](https://hub.docker.com/r/roseatoni/minecraft_docker). Pull the container using the following command:

```
docker pull roseatoni/minecraft_docker
```

The port that Minecraft uses needs to be mapped to the docker container. Unless you changed the port number in the Minecraft server.properties file, you should use the default of 25565:

```
-p 25565:25565
```

Lastly, you need to map the location of your minecraft server files. The files need to be mapped to the /server directory in the docker container:

```
-v /Path/To/Your/Files:/server
```

So, a complete docker run command would look something like this:

```
docker run -d -p 25565:25565 -v /Path/To/Your/Files:/server roseatoni/minecraft_docker:latest
```

## Using RCON

---

I bundled RCON and Minecraft into the same docker container to simplify the installation and connection processes. As a result, you need to enter the console of your docker container to use RCON. You can connect to your container and enter a shell with the following:

```
docker exec -it [NAME_OF_CONTAINER] sh
```

It will start you in the /server directory, but RCON is located in the root directory, so run:

```
cd /
```

Since I created a custom rcon.yaml file, and you set your server.properties files to the correct values, starting the connection to the server is as easy as:

```
./rcon
```
