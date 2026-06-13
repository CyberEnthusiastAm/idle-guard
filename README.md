# 🛑 IdleGuard

**Automated detection and stopping of idle cloud resources** (starting with AWS EC2 development VMs) to reduce unnecessary cloud spend.

Stop paying for dev/test VMs that are left running overnight, weekends, or during holidays.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/CyberEnthusiastAm/idle-guard/pulls)

## Why IdleGuard?

Many teams spin up development and test instances that get forgotten. IdleGuard helps by:

- Detecting instances with very low CPU utilization over a configurable period
- Respecting tags so you never accidentally stop production workloads
- Supporting dry-run mode for safe testing
- Sending notifications (Slack supported out of the box)
- Being easy to schedule via cron, Docker, or serverless (Lambda + EventBridge)

**Typical savings**: Teams often see 30-70% reduction in non-production EC2 costs.

## Features

- ✅ **Smart idle detection** using CloudWatch CPU metrics
- ✅ **Tag-based filtering** (include only dev/test, exclude prod)
- ✅ **Safety first**: Dry-run by default, recent launch protection, exclude tags
- ✅ **Multi-region support**
- ✅ **Notifications**: Slack webhooks (easily extendable to email/SNS/Teams)
- ✅ **Beautiful CLI** powered by Rich
- ✅ **Docker ready** + cron example
- ✅ **Extensible architecture** (easy to add Azure, GCP, RDS, etc.)
- ✅ **Open source** (MIT) – contributions welcome!

## Quick Start

### 1. Installation

```bash
git clone https://github.com/CyberEnthusiastAm/idle-guard.git
cd idle-guard

# Recommended: virtual environment
python -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\activate on Windows

pip install -e .
```

Or install directly from source after cloning.

### 2. Configure AWS Credentials

IdleGuard uses the standard boto3 credential chain:
- `~/.aws/credentials`
- Environment variables (`AWS_ACCESS_KEY_ID`, etc.)
- IAM roles (recommended for production/cron runs)

Make sure your IAM user/role has at minimum:
- `ec2:DescribeInstances`
- `ec2:StopInstances`
- `cloudwatch:GetMetricStatistics`

### 3. Create Configuration

```bash
cp examples/config.yaml.example ~/.idle-guard/config.yaml
# Edit the file with your regions, thresholds, and Slack webhook (optional)
```

### 4. Run a Scan (Dry Run - Safe)

```bash
idle-guard scan --config ~/.idle-guard/config.yaml
```

This will show you exactly which instances would be stopped without doing anything.

### 5. Actually Stop Idle Instances (with confirmation)

```bash
idle-guard stop --config ~/.idle-guard/config.yaml --no-dry-run
```

Add `--force` to skip the confirmation prompt (use carefully!).

## Configuration

See `examples/config.yaml.example` for all options.

Key settings:

| Section              | Key                          | Description                                      | Default     |
|----------------------|------------------------------|--------------------------------------------------|-------------|
| `idle_detection`     | `cpu_threshold_percent`      | CPU % below which instance is idle               | 5.0         |
| `idle_detection`     | `idle_period_minutes`        | Time window to average CPU                       | 60          |
| `idle_detection`     | `min_uptime_minutes`         | Grace period after launch                        | 30          |
| `actions`            | `dry_run`                    | Safe mode (true = never stop)                    | true        |
| `notifications`      | `slack_webhook_url`          | Your Slack incoming webhook                      | null        |

Environment variable overrides are also supported (prefixed `IDLEGUARD_`).

## Scheduling

### Using Cron (Recommended for simplicity)

See `scripts/cron_example.sh` for a ready-to-use script.

Example crontab entry (every night at 10 PM):

```cron
0 22 * * * /home/user/idle-guard/scripts/cron_example.sh >> /var/log/idle-guard.log 2>&1
```

### Docker

```bash
docker build -t idle-guard .
docker run --rm \
  -v ~/.aws:/root/.aws:ro \
  -v ~/.idle-guard/config.yaml:/app/config.yaml:ro \
  idle-guard scan --config /app/config.yaml
```

### Serverless (Future)

The architecture is designed to be easy to wrap in an AWS Lambda function triggered by EventBridge on a schedule.

## Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   CLI (click)   │────▶│  AWSIdleScanner  │────▶│   CloudWatch    │
│   + Rich UI     │     │  (boto3)         │     │   + EC2 API     │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                               │
                               ▼
                        ┌──────────────┐
                        │  Notifier    │
                        │  (Slack)     │
                        └──────────────┘
```

**Core flow**:
1. Load config (YAML + env)
2. For each region: List running EC2 instances matching include tags
3. Skip excluded tags + recently launched instances
4. Query CloudWatch for average CPU over period
5. If below threshold → mark as idle
6. (Optional) Stop the instance
7. Notify via Slack if configured

## Extending IdleGuard

- **Add new clouds** (Azure, GCP): Create `azure_scanner.py` / `gcp_scanner.py` following the same interface.
- **New resources**: RDS, EKS node groups, etc. — add methods to scanner.
- **Better detection**: Combine CPU + network bytes + custom application metrics.
- **Advanced notifications**: Add email via SES, PagerDuty, or Microsoft Teams.
- **Web UI / Dashboard**: Future contribution welcome!

Pull requests that improve multi-cloud support or add new resource types are especially appreciated.

## Development

```bash
pip install -e ".[dev]"  # if dev extras added later
pytest tests/           # (add tests!)
black idle_guard/
ruff check idle_guard/
```

## Roadmap

- [ ] Multi-cloud support (Azure + GCP)
- [ ] Support for more resource types (RDS, ElastiCache, etc.)
- [ ] Web dashboard (FastAPI + nice UI)
- [ ] Cost estimation of savings
- [ ] Terraform module for deployment
- [ ] GitHub Actions example workflow

## Contributing

We welcome contributions of all kinds!

1. Fork the repo
2. Create a feature branch
3. Make your changes + add tests if possible
4. Open a Pull Request

Please follow the existing code style and add documentation for new features.

## License

MIT License — see [LICENSE](LICENSE) file.

## Disclaimer

This tool can stop real cloud resources. Always test thoroughly in dry-run mode first. The authors are not responsible for any unexpected costs or stopped workloads. Use at your own risk and with proper tagging discipline.

---

Made with ❤️ by IT engineer who hate wasting money on idle VMs.

**Star this repo** if you find it useful! ⭐

Questions? Open an issue or discussion.
