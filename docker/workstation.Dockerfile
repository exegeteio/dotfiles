FROM ubuntu:latest
ARG UID=1000
ARG GID=1000
ARG HOST_USER=exegete
ENV DOCKER=true
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends \
        build-essential \
        git \
        less \
        libssl-dev \
        ripgrep \
        ruby-build \
        ruby \
        ssh-client \
        sudo \
        tmux \
        ubuntu-server \
        zsh

COPY docker/workstation/docker.sh /tmp/
RUN /tmp/docker.sh

# MacOS home dir compatability.
RUN ln -s /home /Users
# Setup local user.
RUN useradd -m -s /usr/bin/zsh -u ${UID} -g root ${HOST_USER}
RUN echo "${HOST_USER} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${HOST_USER} \
    && chmod 0440 /etc/sudoers.d/${HOST_USER}
USER ${HOST_USER}
RUN mkdir $HOME/code $HOME/host

COPY docker/workstation /tmp/scripts
RUN /tmp/scripts/compose.sh
RUN /tmp/scripts/asdf.sh

COPY --chown=${HOST_USER}:root ./ /home/${HOST_USER}/.dotfiles
COPY --chown=${HOST_USER}:root docker/workstation/entry.sh /entry.sh
WORKDIR /home/${HOST_USER}/.dotfiles
RUN /usr/bin/zsh ./install.sh

WORKDIR /home/${HOST_USER}

ENTRYPOINT ["/entry.sh"]
CMD ["/usr/bin/zsh"]
