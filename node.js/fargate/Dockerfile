FROM node:12
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci --only=production
COPY src/ /usr/src/app/src
RUN ls -l /usr/src/app

CMD [ "npm", "run", "start" ]
