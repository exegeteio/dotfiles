FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qqy \
    && apt-get install -qqy --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      file \
      git \
      sudo \
      zsh \
    && rm -rf /var/lib/apt/lists/*
 
RUN useradd -mU -G root exegete \
    && chsh -s "$(which zsh)" exegete \
    && echo "exegete ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/exegete

USER exegete
WORKDIR /home/exegete

ADD ./ .config/dotfiles/
RUN .config/dotfiles/brew.sh
RUN .config/dotfiles/dotfiles.sh

CMD ["/usr/bin/zsh", "-l"]
