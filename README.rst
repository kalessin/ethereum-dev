Docker container for development with ethereum. It can also be used to run a ``geth`` node

Contains:

- geth


Build
=====

::

    docker build -t kalessin/ethereum-dev .


Run
===

Basic run command::

    docker run -ti -p 30303:30303 kalessin/ethereum-dev /bin/bash

If you want ``geth`` to save blockchain in host instead of container, use docker volumes option. I.e::

    mkdir $HOME/.ethereum
    docker run -v $HOME/.ethereum:/root/.ethereum -ti -p 30303:30303 kalessin/ethereum-dev /bin/bash

Be careful not to mix private blockchain with public one. I recommend to reserve ``$HOME/.ethereum`` for public blockchain, and for private blockchain use instead::

    mkdir $HOME/.private_ethereum
    docker run -v $HOME/.private_ethereum:/root/.ethereum -ti -p 30303:30303 kalessin/ethereum-dev /bin/bash

If you will run Mist wallet, you need to enable applications running in container to access host X server::

    XSOCK=/tmp/.X11-unix
    XAUTH=/tmp/.docker.xauth
    touch $XAUTH
    xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

Then add the following options to ``docker run`` command::

    -v $XSOCK:$XSOCK:rw -v $XAUTH:$XAUTH:rw -e DISPLAY -e XAUTHORITY=${XAUTH}

It is not the safest way to grant applications running in container access X server as root, but it is the simplest one. For more elaborated alternatives, check
`<http://wiki.ros.org/docker/Tutorials/GUI>`_

Also, you must separate Mist instance running in public blockchain, from private one. Full example for accesing public chain::

    mkdir $HOME/.config/Mist
    docker run -v $HOME/.ethereum:/root/.ethereum -v $HOME/.config/Mist:/root/.config/Mist \
           -v $XSOCK:$XSOCK:rw -v $XAUTH:$XAUTH:rw -e DISPLAY -e XAUTHORITY=${XAUTH} -ti -p 30303:30303 kalessin/ethereum-dev /bin/bash

For private chain alternative::

    mkdir -p $HOME/.private_ethereum/Mist
    docker run -v $HOME/.private_ethereum:/root/.ethereum -v $HOME/.private_ethereum/Mist:/root/.config/Mist \
           -v $XSOCK:$XSOCK:rw -v $XAUTH:$XAUTH:rw -e DISPLAY -e XAUTHORITY=${XAUTH} -ti -p 30303:30303 kalessin/ethereum-dev /bin/bash


Finally (if you will run Mist for first time for the given blockchain), once inside the container console, copy the file clientBinaries.json into the container Mist
folder. This file indicates the installed version of geth, in order to avoid Mist to try to download a new one by itself.
