# CI Configuration Instruction

Prepare CI workflow accessible for `Kubernetes-based` `staging` and `production` environment and local `dev` environment driven by `Docker`

### Build Image Locally (Test)

```bash
make build ENV=dev
```

### Run Container Locally (Test)

```bash
make local-run
```

### Run Container Locally (Prod)

```bash
make prod-run
```

### Ready for Deployment

coming soon...

## Reference

- [Makefile Tutorial](https://makefiletutorial.com/)
