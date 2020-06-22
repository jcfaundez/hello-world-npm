FROM node:12
# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json ./
RUN npm install

COPY . .

EXPOSE 8090

CMD [ "node", "index.js" ]