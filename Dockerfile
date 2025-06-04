# Use Node.js 18 LTS as base image
FROM node:18-alpine

# Set working directory
WORKDIR /usr/src/app

# Install curl and git for health checks and cloning
RUN apk add --no-cache curl git

# Clone the DigiPin repository
RUN git clone https://github.com/CEPT-VZG/digipin.git . && \
    rm -rf .git

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Create a non-root user to run the application
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Change ownership of the application directory
RUN chown -R nodejs:nodejs /usr/src/app

# Switch to non-root user
USER nodejs

# Expose the port the app runs on
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Start the application
CMD ["npm", "start"]