#!/usr/bin/env bash

set -ex

# Check Zig
zig version
zls --version

# Check JavaScript
volta --version
node --version
npm --version
gitmoji --version
tsx --version
