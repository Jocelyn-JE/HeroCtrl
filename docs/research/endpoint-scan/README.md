# GoPro endpoint scan research

This folder contains legacy research artifacts used to discover undocumented GoPro HERO3+ Wi-Fi API endpoints.

## Contents

- `scan.sh`: brute-force endpoint scanner used during reverse engineering.
- `log/`: generated scan logs (`gopro_scan.log`).
- `output`: legacy binary output artifact kept for reference.

## Why this is in `docs/`

These files are **research documentation artifacts**, not automated app tests.
Flutter tests live in the `test/` directory.

## Usage

Run from anywhere:

```bash
bash docs/research/endpoint-scan/scan.sh
```

Logs are always written to:

```text
docs/research/endpoint-scan/log/gopro_scan.log
```
