# Fastify Load Testing

Benchmarking Fastify with:
- HTTP
- HTTPS
- Caddy reverse proxy

Using OpenStack server and client instance.

# Installing Caddy

This project supports two Caddy configurations:

1. **Standard Caddy** (HTTP reverse proxy with optional TLS termination)
2. **Caddy with Layer 4** (TLS passthrough)

Choose the installation that matches the benchmark configuration you want to run.

---

## Standard Caddy Installation

Install the official Caddy release:

```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
| sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
| sudo tee /etc/apt/sources.list.d/caddy-stable.list

sudo chmod o+r /usr/share/keyrings/caddy-stable-archive-keyring.gpg
sudo chmod o+r /etc/apt/sources.list.d/caddy-stable.list

sudo apt update
sudo apt install caddy
```

Verify the installation:

```bash
caddy version
```

This installation supports:

- HTTP reverse proxy
- HTTPS reverse proxy
- TLS termination
- HTTP/2
- HTTP/3

---

## Installing Caddy with Layer 4 Support

TLS passthrough requires the **Layer 4** plugin, which is **not included** in the standard Caddy package.

First, install Go:

```bash
sudo apt install golang-go
```

Install `xcaddy`:

```bash
go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
```

Ensure Go binaries are in your PATH:

```bash
export PATH="$PATH:$(go env GOPATH)/bin"
```

Build Caddy with the Layer 4 plugin:

```bash
xcaddy build \
    --with github.com/mholt/caddy-l4
```

The build produces a `caddy` executable in the current directory.

Verify that the plugin is included:

```bash
./caddy list-modules | grep layer4
```

You should see output similar to:

```text
layer4
layer4.handlers.proxy
layer4.matchers.tls
...
```

Run Caddy using the custom binary:

```bash
./caddy run --config Caddyfile
```

or replace the system binary if desired:

```bash
sudo mv ./caddy /usr/local/bin/caddy
```

---

## Which Installation Should I Use?

| Configuration | Standard Caddy | Layer 4 Caddy |
|--------------|:--------------:|:-------------:|
| HTTP reverse proxy | ✓ | ✓ |
| HTTPS with Caddy TLS termination | ✓ | ✓ |
| HTTP/2 | ✓ | ✓ |
| HTTP/3 | ✓ | ✓ |
| TLS passthrough (Fastify terminates TLS) | ✗ | ✓ |

The Layer 4 version is only required for the TLS passthrough benchmark, where Caddy forwards encrypted TCP traffic directly to the Fastify HTTPS server without terminating TLS itself.