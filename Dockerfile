FROM ubuntu:latest

COPY linux ./linux
COPY linux.sh ./
RUN ./linux.sh
 
RUN useradd -mU -G root exegete \
    && chsh -s "$(which zsh)" exegete

USER exegete
WORKDIR /home/exegete

ADD ./brew.sh brew .config/dotfiles/
RUN .config/dotfiles/brew.sh
ADD ./ .config/dotfiles/
RUN sudo chown -R exegete:exegete /home/exegete && .config/dotfiles/install.sh

CMD ["/usr/bin/zsh", "-l"]
