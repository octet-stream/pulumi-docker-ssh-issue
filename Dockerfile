FROM node:20-alpine

RUN npm i -g pnpm@8

RUN mkdir -p /usr/opt/pulumi-docker-ssh-issue

COPY package.json /usr/opt/pulumi-docker-ssh-issue/
COPY pnpm-lock.yaml /usr/opt/pulumi-docker-ssh-issue/

WORKDIR /usr/opt/pulumi-docker-ssh-issue
RUN pnpm i --frozen-lockfile

COPY . /usr/opt/pulumi-docker-ssh-issue/

EXPOSE 3030/tcp
CMD ["pnpm", "run", "start"]
