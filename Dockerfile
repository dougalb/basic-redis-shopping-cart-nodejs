FROM node:16-alpine as vue-build
WORKDIR /var/task
COPY ./client/package.json ./
RUN npm install
COPY ./client/ .
RUN npm run build

FROM node:16-alpine AS server-build
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.7.0 /lambda-adapter /opt/extensions/lambda-adapter
WORKDIR /var/task/server
COPY ./server/package.json ./
RUN npm install
COPY ./server .
COPY --from=vue-build /var/task/dist ./../client-dist
EXPOSE ${PORT}
CMD ["node", "./src/index.js"]
