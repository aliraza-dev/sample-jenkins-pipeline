FROM node:18-slim AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

FROM nginx:stable-alpine AS serve
COPY --from=build /app/dist /usr/share/nginx/html
COPY --from=build /app/conf /etc/nginx/conf.d/

EXPOSE 80

RUN rm /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]