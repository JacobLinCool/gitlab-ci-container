FROM ubuntu:focal as node

ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR "/root/.nvm"
ENV NVM_VERSION "0.39.1"
ENV NODE_VERSION "18.7.0"
ENV NODE_PATH "$NVM_DIR/v$NODE_VERSION/lib/node_modules"
ENV PATH "$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH"
ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt update && apt -y install git-all curl make python3 gcc g++ && apt-get clean
RUN curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh" | bash && rm -rf "$NVM_DIR/.cache"
RUN npm i -g pnpm && rm -rf /root/.npm

FROM node

RUN pnpm i -g regctl
RUN curl -fsSL https://get.docker.com | sh -
RUN curl -o /bin/entry.sh https://raw.githubusercontent.com/docker-library/docker/master/docker-entrypoint.sh && chmod +x /bin/entry.sh

ENTRYPOINT ["entry.sh"]
CMD ["sh"]
