# noVNC Display Container

This Docker container starts an X server with fluxbox, makes it accessible via noVNC, and then runs the command provided to it.

The container is based on `ubuntu:24.04`.

## Usage (CLI)

First build it:

```sh
docker build . -t suchipi/novnc
```

Then run it:

```sh
docker run --rm -it -p 8080:8080 suchipi/novnc
```

Then, open <http://localhost:8080/>.

To run a program, append it to the end of the command:

```sh
docker run --rm -it -p 8080:8080 suchipi/novnc xterm
```

When run this way, the container will exit once the program you specified exits.

## Usage (As Dockerfile `FROM` base)

You can also use this container as a base image in a Dockerfile. Set up your Dockerfile as normal, then use `CMD` to specify what to run in the container (if anything).

The following example installs wine, downloads the [BGB Game Boy emulator](https://bgb.bircd.org/), and sets it as the startup command for the container:

```Dockerfile
FROM suchipi/novnc

# Install wine
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y wine wine32 unzip

# Download and unzip bgb
WORKDIR /root
RUN wget https://bgb.bircd.org/bgb.zip && \
  unzip bgb.zip

# Set bgb as the program to run when the container starts
CMD wine /root/bgb.exe
```

## Architecture

This container is built using the following software:

- [Fluxbox](http://fluxbox.org/) - the window manager for the X session
- [noVNC](https://novnc.com/info.html) - browser-based VNC client used to expose the X session to the host
- [TigerVNC](https://tigervnc.org/) - the X server and VNC server used
- [Supervisor](http://supervisord.org/) - to start Fluxbox, noVNC, and TigerVNC
- [Expect](https://www.tcl.tk/man/expect5.31/index.html) - To wait for the services to go up and execute the command you specified (if present)

## Credits

This container is based heavily on [theasp/docker-novnc](https://github.com/theasp/docker-novnc).

## License

MIT
