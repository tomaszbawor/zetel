#!/usr/bin/env bun
import { BunRuntime, BunServices } from "@effect/platform-bun"
import { Console, Effect } from "effect"
import { Command, Flag } from "effect/unstable/cli"
import packageJson from "../package.json" with { type: "json" }

const appVersion = packageJson.version

// --- greet subcommand ---
const greet = Command.make(
  "greet",
  {
    name: Flag.string("name").pipe(
      Flag.withAlias("n"),
      Flag.withDescription("Name of the person to greet"),
    ),
    formal: Flag.boolean("formal").pipe(
      Flag.withAlias("f"),
      Flag.withDescription("Use a formal greeting"),
    ),
    count: Flag.integer("count").pipe(
      Flag.withAlias("c"),
      Flag.withDefault(1),
      Flag.withDescription("Number of times to repeat the greeting"),
    ),
  },
  (config) =>
    Effect.gen(function* () {
      const greeting = config.formal ? `Good day, ${config.name}` : `Hello, ${config.name}!`
      for (let i = 0; i < config.count; i++) {
        yield* Console.log(greeting)
      }
    }),
).pipe(
  Command.withDescription("Greet a person"),
  Command.withExamples([
    { command: "zetel greet --name Alice", description: "Greet Alice" },
    {
      command: "zetel greet --name Bob --formal",
      description: "Greet Bob formally",
    },
    {
      command: "zetel greet --name Dave --count 3",
      description: "Greet Dave three times",
    },
  ]),
)

// --- version subcommand ---
const version = Command.make("version", {}, () => Console.log(`zetel v${appVersion}`)).pipe(
  Command.withDescription("Print the current version"),
)

// --- root command ---
const zetel = Command.make("zetel").pipe(
  Command.withDescription("A simple CLI app built with Effect"),
  Command.withSubcommands([greet, version]),
)

// --- run ---
const program = Command.run(zetel, { version: appVersion })

BunRuntime.runMain(program.pipe(Effect.provide(BunServices.layer)))
