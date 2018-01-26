# NODE
FROM node:8-alpine

# LABELS
LABEL version="0.0.3"
LABEL description="Speckle Server Docker Container Image"

# CREATE DIRS
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# INSTALL - FOR RELEASE ONLY
#COPY package*.json ./
#RUN npm install
#COPY . .
#CMD ["node", "server.js"]

# Copy the entry point
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
