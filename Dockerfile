FROM ubuntu:xenial

RUN apt-get update && apt-get install -y aptitude curl git make gcc musl-dev linux-headers-4.10.0-22-generic \
                       gconf2 gconf-service libnotify4 libappindicator1 libxtst6 libnss3 libxss1 \
                       vim libasound2 libcanberra-gtk-module

RUN cd ~ && \
    curl -O https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz && \
    tar xvf go1.8.3.linux-amd64.tar.gz && \
    mv go /usr/local && rm go1.8.3.linux-amd64.tar.gz

RUN mkdir -p /app/go
COPY environ.sh /app/environ.sh

WORKDIR /app
RUN cat environ.sh >> ~/.bashrc 

RUN git clone https://github.com/ethereum/go-ethereum.git

COPY build.sh .
RUN /bin/bash -c "source ./build.sh"
RUN cp go-ethereum/build/bin/* /usr/local/bin/

RUN curl -L -O https://github.com/ethereum/mist/releases/download/v0.8.10/Ethereum-Wallet-linux64-0-8-10.deb
RUN curl -L -O https://github.com/ethereum/mist/releases/download/v0.8.10/Mist-linux64-0-8-10.deb

RUN dpkg -i Ethereum-Wallet-linux64-0-8-10.deb
RUN dpkg -i Mist-linux64-0-8-10.deb

RUN apt-get install -y ntp

EXPOSE 8545
EXPOSE 30303
EXPOSE 30303/udp

COPY genesis.json .
COPY clientBinaries.json .
