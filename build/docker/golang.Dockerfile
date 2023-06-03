FROM golang:buster
ENV DOCKER=1

RUN apt-get update \
    && apt-get install -qqy \
      tmux \
      rbenv \
      sudo \
      vim \
      zsh \
    && rm -rf /var/lib/apt/lists/*

ARG HOST_USER
ARG HOST_HOME

RUN mkdir -p $(dirname $HOST_HOME) && useradd $HOST_USER -mg root -d $HOST_HOME
USER $HOST_USER
WORKDIR $HOST_HOME

CMD ["tmux"]
