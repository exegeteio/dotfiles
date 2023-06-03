FROM ubuntu:latest

COPY linux ./linux
COPY linux.sh ./
RUN ./linux.sh
 
RUN useradd -mU -G root exegete \
    && chsh -s "$(which zsh)" exegete \
    && echo "exegete ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/exegete

USER exegete
WORKDIR /home/exegete

ADD ./brew.sh brew .config/dotfiles/
RUN .config/dotfiles/brew.sh
ADD ./ .config/dotfiles/
RUN .config/dotfiles/dotfiles.sh

CMD ["/usr/bin/zsh", "-l"]
