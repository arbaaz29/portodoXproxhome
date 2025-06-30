FROM hugomods/hugo AS builder

WORKDIR /usr/src/app

COPY . .

RUN hugo

FROM nginx:mainline-alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /usr/src/app/public /usr/share/nginx/html

EXPOSE 80