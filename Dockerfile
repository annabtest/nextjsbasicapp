# Stage 1: Build the Next.js app
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy only package.json and package-lock.json for dependency installation
COPY package.json package-lock.json ./

# Install all dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the Next.js app
RUN npm run build

# Stage 2: Create a minimal production image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy only production dependencies from the builder stage
COPY --from=builder /app/package.json /app/package-lock.json ./
RUN npm install --production

# Copy the build output and public assets from the builder stage
COPY --from=builder /app/.next /app/.next
COPY --from=builder /app/public /app/public

# Expose the port your app will run on
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "start"]