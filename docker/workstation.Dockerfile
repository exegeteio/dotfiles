FROM debian:latest
ARG UID=1000
ARG GID=1000
ARG HOST_USER=exegete
ARG HOST_HOME=/home/exegete
ENV DOCKER=true
ENV DEBIAN_FRONTEND=noninteractive
ENV WORKSPACE=/workspace
RUN apt-get update && apt-get install -qqy --no-install-recommends \
        build-essential \
        curl \
        git \
        libreadline-dev \
        libssl-dev \
        ssh-client \
        sudo \
        zlib1g-dev \
        zsh

COPY docker/workstation/docker.sh /tmp/
RUN /tmp/docker.sh

# Setup local user.
RUN useradd -d ${HOST_HOME} -m -s /usr/bin/zsh -u ${UID} -g root -g ssh ${HOST_USER}
RUN echo "${HOST_USER} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${HOST_USER} \
    && chmod 0440 /etc/sudoers.d/${HOST_USER}
USER ${HOST_USER}

COPY docker/workstation/ /tmp/scripts/
RUN /tmp/scripts/compose.sh
RUN /tmp/scripts/asdf.sh

COPY --chown=${HOST_USER}:root ./ ${HOST_HOME}/.dotfiles
COPY --chown=${HOST_USER}:root docker/workstation/entry.sh /entry.sh
WORKDIR ${HOST_HOME}/.dotfiles
RUN /usr/bin/zsh ./install.sh
RUN sudo ./linux.sh
RUN /usr/bin/zsh ./brew.sh

WORKDIR ${WORKSPACE}

ENTRYPOINT ["/entry.sh"]
CMD ["/usr/bin/zsh"]
