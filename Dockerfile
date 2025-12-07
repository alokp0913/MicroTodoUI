# Download base images for node as stage 1 - Build
FROM node:16.17.0-alpine as build
# Set Working Directory
WORKDIR /app

# COPY package.json files from local to container build 

COPY package*.json ./

# RUN npm CI for doanload dependencies and clear old node_modules files
RUN npm ci

COPY . .
RUN npm run build


# STAGE 2 server the build artifacts from stage 1 to stage 2

# Download nginx Base image 
FROM nginx:alpine as Serve
# Delete defaul files from html folder
RUN rm -rf /usr/share/nginx/html/*
# Copy build artifacts from Stage-1 Build and serve onto nginx html dirrctory
COPY --from=build /app/build /usr/share/nginx/html

# expose the
EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
