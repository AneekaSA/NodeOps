FROM node:20-alpine

WORKDIR /usr/src/app

COPY  package.json package-lock* ./

RUN npm ci --only=production 

COPY . .

EXPOSE 3000

CMD ["node", "app.js"]

