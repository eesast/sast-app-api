# Builder stage

FROM node:11 AS builder
ENV PYTHON=/usr/bin/python2.7

# Create app directory
WORKDIR /home/node/app

# Install app devDependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./
RUN npm install

# Bundle app source
COPY . .

# Build
RUN npm run build


# Runner stage

FROM node:11
ENV NODE_ENV=production
ENV PYTHON=/usr/bin/python2.7
WORKDIR /home/node/app

# Install app dependencies
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force

# Copy build files
COPY --from=builder /home/node/app/build ./build

EXPOSE 28888

CMD npm run serve