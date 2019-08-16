FROM frekele/ant

# install environment dependencies
RUN apt-get update -yq \
    && apt-get install curl gnupg -yq \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install nodejs -yq \
    && apt-get install -y git

# prepare App Inventor workspace
RUN git clone --depth 1 https://github.com/ColinTree-bot/appinventor-sources.git /usr/workspace \
    && cd /usr/workspace \
    && git submodule init \
    && git submodule update

# put it at last since it is sometimes modified
RUN npm i -g typescript \
    && npm i -g pm2

WORKDIR /usr/src

# cache node modules
COPY package*.json ./
RUN npm i

# build ts files
COPY src src
COPY tsconfig.json ./
RUN tsc

COPY . .

EXPOSE 8048
CMD [ "npm", "start" ]