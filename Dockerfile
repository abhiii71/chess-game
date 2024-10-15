# Stage 1: Build Stage
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY /app/package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY /app .

# Stage 2: Production Stage
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app/package*.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/server ./server
COPY --from=build /app/front ./front
COPY --from=build /app/index.js ./index.js
COPY --from=build /app/config.js ./config.js

# Expose the port that your application will run on
EXPOSE 8080

# Command to start the application
CMD ["node", "server/server.js"]

