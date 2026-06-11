---
name: jtgp:test
description: Run a specific test or test suite and report results with real runtime output. Does not write new tests — use execute for that. Use when you want to verify a behavior, confirm a fix, or check a module without opening a formal issue. Auto-invoke when the user says "run tests", "check if tests pass", "test this", or references a specific test class or method.
---

# Skill: test

## Preconditions

Read `.jtgp/config.json`. If missing, stop and run `/jtgp:setup` first.
Load: build tool, test framework, language for terminal messages.

## What this skill does and does not do

**Does:**
- Runs an existing test or suite and captures real output
- Reports pass/fail with the specific assertion, file, and line
- Identifies the relevant module from context or your description

**Does not:**
- Write new tests (that belongs in execute, delegated to the tester agent)
- Replace the verify gate for a formal issue
- Act as a substitute for `/jtgp:resume` + execute when an issue needs rework

## Step 1 — Identify what to run

If a specific test class or method is provided, use it directly.

If only a description is provided (e.g. "check if group withdrawal simulate works"), search the codebase for the most relevant test class:
- Glob for test files related to the described feature or module
- Show the candidate(s) and ask for confirmation before running

If nothing is found, inform the user and ask them to point to the file or class.

## Step 2 — Identify the module

Determine which module/subdirectory the test belongs to.
The build command must run from inside that module's directory (not the workspace root).
Use the `build_tool` from config:

- `maven` → `mvn test -s maven-settings.xml -DforkCount=0 [-Dtest={ClassName}[#{methodName}]]`
- `gradle` → `./gradlew test [--tests "{ClassName}.{methodName}"]`
- `npm` → `npm test [-- --testNamePattern="{pattern}"]`
- `yarn` → `yarn test [{pattern}]`
- Other → use the configured build tool with equivalent flags

## Step 3 — Run and capture

Run the test command. Capture the full output.

Do NOT declare "tests should pass" or make any prediction before running.
Evidence is the actual output — not an expectation.

## Step 4 — Report

Produce a concise report:

```
Module: {module name}
Command: {exact command run}
Result: PASS (N tests) | FAIL (N failed, N passed)

Failures:
- {TestClass}#{method}: {assertion message} at line {N}
  Expected: {value}
  Actual:   {value}

Passed (if relevant to the query):
- {TestClass}#{method}
```

If all tests pass: state it plainly with the count.
If tests fail: list each failure with the specific assertion and location.

Do not suggest fixes unless asked. The job of this skill is to observe and report, not to correct.

## After reporting

If failures are found, offer the user two paths:
1. Open a formal issue with `/jtgp:spec` to fix properly
2. Ask you to investigate the failure inline (quick look, no spec)

If all pass, confirm the behavior is verified and offer nothing further unless the user asks.
