FROM node:11.6.0-alpine as base

USER node
WORKDIR /home/node

COPY package.json yarn.lock ./
RUN yarn

COPY public public
COPY src src
RUN yarn build

FROM nginx:1.15.2-alpine as release
RUN apk add --no-cache jq

COPY --from=base /home/node/build /var/www
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]