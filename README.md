# zetel

To install dependencies:

```bash
bun install
```

To run:

```bash
bun run start
```

To check the project:

```bash
bun run check
```

To use the Effect tsgo language service, point your editor at:

```bash
bun run effect-lsp:path
```

If your editor uses `@typescript/native-preview` automatically, patch its local
`tsgo` binary after installing dependencies:

```bash
bun run effect-lsp:patch
```

To format source files:

```bash
bun run format
```

To enter the Nix development shell:

```bash
nix develop
```

With direnv installed:

```bash
direnv allow
```

To build the app:

```bash
bun run build
```

## Pull request builds

To run the build for a pull request targeting `main`, the repository owner adds
the `run-build` label to that PR. The workflow checks out the PR head, installs
dependencies with Bun, runs checks, and builds the app.

## Versioning and releases

The app version is defined in `package.json`. The CLI reads that value.

Run the `Release` workflow from GitHub Actions and choose `patch`, `minor`, or
`major`. The workflow bumps `package.json`, builds the app with Bun, commits
the version change, creates a `vX.Y.Z` tag, and publishes a GitHub release with
the built platform packages attached.

Release packages are standalone executables for:

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

After downloading a package, extract it and run:

```bash
./zetel version
```

This project was created using `bun init` in bun v1.3.13. [Bun](https://bun.com) is a fast all-in-one JavaScript runtime.
