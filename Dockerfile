FROM ubuntu:xenial
# COPY FROM #MAINTAINER Kyle Manna <kyle@kylemanna.com>
# https://github.com/kylemanna/docker-bitcoind
MAINTAINER changshu.li <lcs.005@163.com>

ARG USER_ID
ARG GROUP_ID

ENV HOME /bitcoin
ENV version 0.17.1

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} bitcoin \
	&& useradd -u ${USER_ID} -g bitcoin -s /bin/bash -m -d $HOME bitcoin

RUN apt update && apt install -y wget

RUN cd $HOME && wget -O bitcoin.tar.gz https://bitcoincore.org/bin/bitcoin-core-0.17.1/bitcoin-0.17.1-x86_64-linux-gnu.tar.gz \
    && tar -xzvf bitcoin.tar.gz -C /opt/ \
    && mkdir -p $HOME/.bitcoin

COPY bitcoin.conf $HOME/.bitcoin

RUN apt-get clean && rm -rf /tmp/* /var/tmp/* bitcoin-0.17.1-x86_64-linux-gnu.tar.gz
#

VOLUME ["/bitcoin"]

EXPOSE 8332 8333 18332 18333

WORKDIR /bitcoin

ENTRYPOINT ["/opt/bitcoin-0.17.1/bin/bitcoind"]

CMD ["-regtest=1"]