FROM node:8.10.0-alpine as builder
COPY package.json ./
RUN yarn install && mkdir /myangularapp && mv ./node_modules ./myangularapp
WORKDIR /myangularapp
COPY . .
RUN yarn run build --prod --build-optimizer
FROM nginx:1.13.9-alpine
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
                                  
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /myangularapp/dist /usr/share/nginx/html
COPY --from=builder /myangularapp/entrypoint.sh /usr/share/nginx/
RUN chmod +x /usr/share/nginx/entrypoint.sh
CMD ["/bin/sh", "/usr/share/nginx/entrypoint.sh"]