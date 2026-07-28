# Benchmark Scripts

This directory contains benchmark scripts used to evaluate the REST API performance for the thesis experiments.

The benchmarks use the `tvsjsdock/h2load-http3` Docker image and measure different deployment configurations and HTTP protocol versions.

All benchmark results are stored in the project's `results/` directory.

---

# Prerequisites

Before running the benchmarks, ensure that:

* Docker is installed and running.
* The `tvsjsdock/h2load-http3` Docker image is available (Docker will download it automatically if required).
* The server under test is running and reachable from the client VM.
* The server address configured in the benchmark scripts matches the deployment.

The benchmark scripts are designed to be executed from their own directories.
Run each script from the directory where it is located, for example:

```bash
cd scripts/rq1
./baseline.sh
```

or:

```bash
cd scripts/rq2/h1/stresstest
./stresstest.sh
```

Do not execute scripts from another directory, since relative paths are used for locating benchmark results.

---

# RQ1 – Caddy Performance

RQ1 evaluates the performance impact of different deployment configurations while using **HTTP/1.1**.

The following configurations are tested:

| Script               | Configuration                                             |
| -------------------- | --------------------------------------------------------- |
| `baseline.sh`        | Fastify API using direct HTTP                             |
| `fastify_tls.sh`     | Fastify handling HTTPS/TLS directly                       |
| `caddy_proxy_tls.sh` | Caddy reverse proxy forwarding TLS traffic to Fastify TLS |
| `caddy_tls.sh`       | Caddy terminates TLS and forwards HTTP traffic to Fastify |

Run the benchmarks:

```bash
cd scripts/rq1

chmod +x *.sh

./baseline.sh
./fastify_tls.sh
./caddy_proxy_tls.sh
./caddy_tls.sh
```

Results are stored under:

```
results/rq1/
```

Each benchmark performs:

1. Server availability check
2. Warm-up requests
3. Measured benchmark run
4. Storage of summary and request timing data

---

# RQ2 – HTTP Protocol Comparison

RQ2 compares performance between:

* HTTP/1.1
* HTTP/2
* HTTP/3

Available benchmark scripts:

```
scripts/rq2/
├── h1/
├── h2/
└── h3/
```

Each protocol has its own benchmark script.

Run examples:

```bash
cd scripts/rq2/h1
./h1.sh
```

```bash
cd scripts/rq2/h2
./h2.sh
```

```bash
cd scripts/rq2/h3
./h3.sh
```

Results are stored under:

```
results/rq2/
```

---

# Stress Scaling Tests

Stress tests evaluate how performance changes when increasing the number of concurrent clients.

The stress tests increase concurrency using:

```
10
20
40
80
160
320
```

clients.

Example:

```bash
cd scripts/rq2/h1/stresstest

./stresstest.sh
```

The script creates:

```
results/rq2/h1/stresstest/
├── stress_scaling_summary.txt
├── client_10/
├── client_20/
├── client_40/
├── client_80/
├── client_160/
└── client_320/
```

The summary file contains the complete scaling experiment output, while each client directory contains:

```
summary.txt
requests.tsv
```

---

# Benchmark Output

Each benchmark produces two main files.

## summary.txt

Contains the `h2load` benchmark output:

* Requests per second
* Response time statistics
* Connection time
* Time to first byte
* Throughput
* HTTP status codes
* TLS information (when applicable)

## requests.tsv

Contains per-request timing information suitable for further analysis using:

* Excel
* Google Sheets
* Python
* R

---

# Modifying Benchmark Parameters

Benchmark parameters are configured inside each script.

Common parameters:

| Parameter | Description                                                   |
| --------- | ------------------------------------------------------------- |
| `-n`      | Total number of requests                                      |
| `-c`      | Number of concurrent clients                                  |
| `-t`      | Number of h2load worker threads                               |
| `-m`      | Maximum concurrent streams per connection (HTTP/2 and HTTP/3) |

Example:

```bash
h2load --h1 -n 100000 -c 80 -t 2 https://127.0.0.1:8443/
```

The warm-up workload is configured in the corresponding `common.sh` file.

---

# Notes

* Always start the server before running benchmarks.
* Run benchmarks from the correct script directory because result paths are relative to the script location.
* Use identical benchmark parameters when comparing different configurations.
* Repeat measurements if required to reduce measurement variance.
