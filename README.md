# Digipin API Docker Helper

A Docker-based setup utility for integrating with India's Digipin geospatial addressing system API.

## About Digipin

Digipin is India's nationwide geo-coded addressing system developed by the Department of Posts in collaboration with IIT Hyderabad and NRSC, ISRO. It provides precise location identification by dividing India into approximately 4m x 4m grids, with each grid assigned a unique 10-character alphanumeric code based on latitude and longitude coordinates.

## Key Features of Digipin:
- **Precision**: Identifies locations within 4m x 4m accuracy
- **Coverage**: Works across all Indian regions including rural, remote, and urban areas
- **Privacy-Focused**: No personal data storage, only geographic coordinates
- **Offline Capability**: Functions without internet connectivity once generated
- **Open Source**: Programming logic available in public domain
- **Coordinates Coverage**: Longitude 63.5-99.5°E, Latitude 2.5-38.5°N

## What This Docker Helper Provides

This repository simplifies the setup and deployment of applications that integrate with the Digipin API by providing:

- **Containerized Environment**: Pre-configured Docker setup for Digipin API integration
- **Easy Configuration**: Environment variables and configuration templates
- **Development Ready**: Local development environment with hot-reload capabilities
- **Production Deployment**: Optimized production-ready containers
- **API Documentation**: Integrated API documentation and examples
- **Health Checks**: Built-in monitoring and health check endpoints

## Use Cases

Perfect for applications requiring:
- **Delivery Services**: Precise location-based delivery in India
- **Emergency Services**: Quick location identification for first responders
- **Government Services**: Efficient service delivery with accurate addressing
- **Logistics**: Improved supply chain management with precise coordinates
- **Rural Development**: Addressing solutions for areas without traditional addresses
- **Navigation Systems**: Integration with mapping and navigation applications

## Quick Start

1. **Clone this repository:**
   ```bash
   git clone git@github.com:alfa-intellitech/digipin-api-docker.git
   ```

2. **cd digipin-api-docker folder:**
   ```bash
   cd digipin-api-docker
   ```

3. **Create environment file:**
   ```bash
   cp .env.example .env
   # Edit .env file as needed
   ```

4. **Start the setup:**
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

Your project directory should look like this:
```
digipin-api-docker/
├── docker-compose.yml
├── Dockerfile
├── .env
├── nginx/
│   └── nginx.conf
└── logs/ (created automatically)
```

Note: The DigiPin source code is automatically cloned during the Docker build process.

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