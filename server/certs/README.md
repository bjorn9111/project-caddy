## Generate local Fastify HTTPS certificate

For direct Fastify HTTPS benchmarks, generate a self-signed certificate.

Replace `IP_ADDRESS` with the IP address of the machine running Fastify:

```bash
openssl req -x509 \
-newkey rsa:4096 \
-keyout server.key \
-out server.crt \
-days 365 \
-nodes \
-subj "/CN=IP_ADDRESS"
```
For benchmarking only, a self-signed certificate is used.
Certificate validation is disabled in h2load using `-k`.
The CN should match the server address when possible.
The generated certificate is used only when running Fastify with HTTPS directly.
When running behind Caddy, Caddy manages TLS certificates itself using its own certificate authority.