ARG IMG_VERSION=1
FROM node:12
ENV IMG_VERSION=$IMG_VERSION
# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json ./
RUN npm install

COPY . .

EXPOSE 8090

CMD [ "node", "index.js" ]