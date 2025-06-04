# DigiPin Docker Compose Setup Guide

This guide will help you set up the DigiPin API using Docker Compose for both development and production environments.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose v2.0+
- Git

## Quick Start

1. **Clone the DigiPin repository:**
   ```bash
   git clone https://github.com/CEPT-VZG/digipin.git
   cd digipin
   ```

2. **Add the Docker files to your project:**
   - Copy the `docker-compose.yml` file to the root directory
   - Copy the `Dockerfile` to the root directory
   - Copy the `.env` template and customize it
   - Create `nginx/` directory and add the nginx configuration (for production)

3. **Create environment file:**
   ```bash
   cp .env.template .env
   # Edit .env file as needed
   ```

4. **Start the basic setup:**
   ```bash
   docker-compose up -d
   ```

5. **Access the API:**
   - API: http://localhost:5000
   - API Documentation: http://localhost:5000/api-docs

## Configuration Options

### Basic Setup (Development)
```bash
# Start only the DigiPin API
docker-compose up -d digipin-api
```

### Production Setup with Nginx
```bash
# Start with nginx reverse proxy
docker-compose --profile production up -d
```

### Setup with Redis Caching
```bash
# Start with Redis for caching
docker-compose --profile with-cache up -d
```

### Full Production Setup
```bash
# Start with both nginx and redis
docker-compose --profile production --profile with-cache up -d
```

## Environment Variables

Key environment variables you can configure in `.env`:

- `NODE_ENV`: Set to `production` for production deployment
- `PORT`: Port the API will run on (default: 5000)
- Additional variables as per the DigiPin application requirements

## Directory Structure

Your project should look like this:
```
digipin/
├── docker-compose.yml
├── Dockerfile
├── .env
├── nginx/
│   └── nginx.conf
├── package.json
├── (other DigiPin source files)
└── README.md
```

## API Endpoints

Once running, you can test the API:

### Encode coordinates to DigiPin
```bash
curl "http://localhost:5000/api/digipin/encode?latitude=12.9716&longitude=77.5946"
```

### Decode DigiPin to coordinates
```bash
curl "http://localhost:5000/api/digipin/decode?digipin=4P3-JK8-52C9"
```

## Management Commands

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f digipin-api
```

### Restart services
```bash
docker-compose restart digipin-api
```

### Stop services
```bash
docker-compose down
```

### Update and rebuild
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Production Considerations

1. **SSL/TLS**: For production, configure SSL certificates in the nginx configuration
2. **Environment**: Set `NODE_ENV=production` in your `.env` file
3. **Monitoring**: Consider adding monitoring services like Prometheus or health check endpoints
4. **Backup**: If using Redis, configure appropriate persistence settings
5. **Security**: Review and customize nginx security headers and rate limiting

## Troubleshooting

### Health Checks
The setup includes health checks. You can verify service health:
```bash
docker-compose ps
```

### Port Conflicts
If port 5000 is already in use, modify the port mapping in `docker-compose.yml`:
```yaml
ports:
  - "3000:5000"  # Use port 3000 instead
```

### Build Issues
If you encounter build issues, try:
```bash
docker-compose build --no-cache --force-rm
```

## Scaling

For high-traffic scenarios, you can scale the API service:
```bash
docker-compose up -d --scale digipin-api=3
```

Note: You'll need to configure nginx load balancing for multiple API instances.

## Security Notes

- The Dockerfile runs the application as a non-root user
- Nginx includes basic security headers
- Rate limiting is configured in nginx
- Consider implementing additional security measures for production deployments