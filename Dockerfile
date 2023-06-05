FROM ubuntu:latest

COPY linux ./linux
COPY linux.sh ./
RUN ./linux.sh
 
RUN useradd -mU -G root exegete \
    && chsh -s "$(which zsh)" exegete


USER exegete

ADD ./brew.sh /tmp/
ADD ./brew /tmp/brew
WORKDIR /tmp/
RUN /tmp/brew.sh

# ADD install.sh /tmp/
# RUN /tmp/install.sh
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/exegeteio/dotfiles/main/install.sh)"

WORKDIR /home/exegete
CMD ["/usr/bin/zsh", "-l"]
