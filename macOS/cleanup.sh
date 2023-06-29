#!/usr/bin/env bash

set -e

cd "$HOME" || exit 1

rm -rf  .cache .lesshst .ssh/known_hosts* .zsh_history .viminfo .TranslationPlugin/caches .wget-hsts
