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

To build the Nix package:

```bash
nix build
```

## Pull request builds

To run the Nix build for a pull request targeting `master`, the repository owner
adds the `run-nix-build` label to that PR. The workflow checks out the PR head
and runs the flake check and package build.

## Versioning and releases

The app version is defined in `package.json`. The CLI and Nix package both read
that value.

Run the `Release` workflow from GitHub Actions and choose `patch`, `minor`, or
`major`. The workflow bumps `package.json`, builds the app with Nix, commits the
version change, creates a `vX.Y.Z` tag, and publishes a GitHub release with the
built Linux package attached.

This project was created using `bun init` in bun v1.3.13. [Bun](https://bun.com) is a fast all-in-one JavaScript runtime.
