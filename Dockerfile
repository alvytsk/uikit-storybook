# Stage 1: Development (for running npm commands)
FROM node:20-alpine AS development

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the source code
COPY . .

# Expose port 3000 for development server
EXPOSE 3000

CMD ["npm", "run", "dev"]

# Stage 2: Build the application (production)
FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=development /app /app
RUN npm run build

# Stage 3: Serve the application
FROM nginx:alpine AS production
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]