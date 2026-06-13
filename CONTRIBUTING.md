# Contributing to IdleGuard

Thank you for your interest in contributing to IdleGuard! We welcome bug reports, feature requests, documentation improvements, and code contributions.

## How to Contribute

1. **Fork** the repository on GitHub.
2. **Clone** your fork locally.
3. Create a new branch for your changes: `git checkout -b feature/your-feature-name`
4. Make your changes.
5. Test thoroughly (especially in dry-run mode).
6. Commit with clear messages.
7. Push to your fork and open a **Pull Request**.

## Development Setup

```bash
git clone https://github.com/yourusername/idle-guard.git
cd idle-guard
python -m venv .venv
source .venv/bin/activate
pip install -e .
```

## Code Style

- Follow PEP 8.
- Use type hints where reasonable.
- Add docstrings to functions and classes.
- Keep the CLI output user-friendly with Rich.

## Adding New Features

- **New cloud provider**: Create a new scanner module following the pattern in `aws_scanner.py`.
- **New resource type**: Extend the existing scanner.
- **Notifications**: Extend the `Notifier` class.
- Always add examples and update the README.

## Testing

Currently minimal tests. When adding features, please include unit tests in a `tests/` directory using `pytest`.

Run:
```bash
pytest
```

## Questions?

Open an issue with the `question` label or start a discussion.

We appreciate every contribution — from fixing a typo in the README to major architectural improvements!

Thank you! 🚀