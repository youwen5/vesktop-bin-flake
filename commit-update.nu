#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

use update.nu

def commit_update []: nothing -> nothing {
  let vesktop_latest = update generate_sources

  git add -A
  let commit = git commit -m $"auto-update: ($vesktop_latest.prev_tag) -> ($vesktop_latest.new_tag)" | complete

  if ($commit.exit_code == 1) {
    print $"Latest version is ($vesktop_latest.prev_tag), no updates found"
  } else {
    print $"Performed update from ($vesktop_latest.prev_tag) -> ($vesktop_latest.new_tag)"
    nix flake update --commit-lock-file
  }
}

commit_update
