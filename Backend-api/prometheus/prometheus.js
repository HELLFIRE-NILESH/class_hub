import promClient from 'prom-client';

const register = new promClient.Registry();

promClient.collectDefaultMetrics({ register });

const httpRequestsTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests made.',
  labelNames: ['method', 'status_code', 'route'],
});
register.registerMetric(httpRequestsTotal);

const httpRequestDurationMicroseconds = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Histogram of HTTP request durations in seconds.',
  labelNames: ['method', 'status_code', 'route'],
  buckets: [10, 100, 200, 500, 1000]  
});
register.registerMetric(httpRequestDurationMicroseconds);

const prometheusMiddleware = (req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    httpRequestDurationMicroseconds.labels(req.method, res.statusCode, req.path).observe(duration);
    httpRequestsTotal.labels(req.method, res.statusCode, req.path).inc();
  });

  next();
};

const metricsRoute = async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
};

export { prometheusMiddleware, metricsRoute };
