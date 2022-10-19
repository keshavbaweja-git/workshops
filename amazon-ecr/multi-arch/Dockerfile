FROM node:14-alpine
WORKDIR /usr/src/app
COPY package*.json index.js ./
RUN npm install
EXPOSE 3000
CMD ["node", "index.js"]