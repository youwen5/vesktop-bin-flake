# to invoke generate_sources directly, enter nushell and run
# `use update.nu`
# `update generate_sources`

def get_latest_release [repo: string]: nothing -> string {
  try {
	http get $"https://api.github.com/repos/($repo)/releases"
	  | where prerelease == false
	  | get tag_name
	  | get 0
	  | str trim --char 'v'
  } catch { |err| $"Failed to fetch latest release, aborting: ($err.msg)" }
}

def get_nix_hash [url: string]: nothing -> string  {
  nix store prefetch-file --hash-type sha256 --json $url | from json | get hash
}

export def generate_sources []: nothing -> record {
  let tag = get_latest_release "Vencord/Vesktop"
  let prev_sources: record = open ./sources.json

  if $tag == $prev_sources.version {
	# everything up to date
	return {
	  prev_tag: $tag
	  new_tag: $tag
	}
  }

  let x86_64_url = $"https://github.com/Vencord/Vesktop/releases/download/v($tag)/vesktop-($tag).tar.gz"
  let aarch64_url = $"https://github.com/Vencord/Vesktop/releases/download/v($tag)/vesktop-($tag)-arm64.tar.gz"
  let sources = {
	version: $tag
	x86_64-linux: {
	  url:  $x86_64_url
	  hash: (get_nix_hash $x86_64_url)
	}
	aarch64-linux: {
	  url: $aarch64_url
	  hash: (get_nix_hash $aarch64_url)
	}
  }

  echo $sources | save --force "sources.json"

  return {
    new_tag: $tag
    prev_tag: $prev_sources.version
  }
}
