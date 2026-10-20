# lazygithub

A patch for [lazygit](https://github.com/jesseduffield/lazygit) that adds a "Pull requests" tab to the branches panel for GitHub remotes.

Each tag of this repo matches the lazygit tag its patch applies to. Tag `v0.61.1` pins the `lazygit` submodule to lazygit `v0.61.1`.

## Requirements

- `gh`, authenticated, to list pull requests
- `glow`, to render pull request descriptions

## Build from source

```sh
git clone --branch v0.61.1 https://github.com/<owner>/lazygithub
cd lazygithub
make setup patch
cd lazygit && go build
```

## Nix

The overlay patches `lazygit` from your nixpkgs. That nixpkgs must ship the lazygit version of the tag you use.

```nix
inputs.lazygithub.url = "github:<owner>/lazygithub/v0.61.1";
inputs.lazygithub.inputs.nixpkgs.follows = "nixpkgs";

nixpkgs.overlays = [ inputs.lazygithub.overlays.default ];
```

`nix run github:<owner>/lazygithub/v0.61.1` runs it with the nixpkgs locked in this repo.

## Configuration

```yaml
git:
  pullRequests:
    enabled: true
    filter: "is:open review-requested:@me"
    style: "light"
```

| Key | Values | Default |
| --- | --- | --- |
| `git.pullRequests.enabled` | `true`, `false`. `false` stops all pull request requests and leaves the tab empty | `true` |
| `git.pullRequests.filter` | A GitHub web search filter, for example `is:open review-requested:@me` | `is:open` |
| `git.pullRequests.style` | The glow style for pull request details: `dark`, `light`, `dracula`, `tokyo-night`, `pink`, `ascii`, `notty`, or a path to a JSON style file | `dark` |

## Keybindings

The keys are lazygit's defaults. Rebinding the lazygit key in the second column moves the action with it.

Pull requests tab:

| Key | lazygit key | Action |
| --- | --- | --- |
| `<space>` | `universal.select` | Check out the pull request branch |
| `<enter>` | `universal.goInto` | View the pull request commits |
| `e` | `universal.edit` | Open the description and comments in the editor |
| `p` | `universal.pull` | Refresh the pull request details |
| `f` | `branches.fastForward` | Refresh the pull request list |
| `c` | `files.commitChanges` | Add a comment |
| `C` | `files.commitChangesWithEditor` | Add a comment in the editor |
| `a` | `files.toggleStagedAll` | Review: approve or request changes |
| `m` | `universal.createRebaseOptionsMenu` | Merge, with the methods the repository allows |
| `o` | `branches.createPullRequest` | Open in the browser, after a confirmation |
| `G` | `branches.openPullRequestInBrowser` | Open in the browser |
| `<c-y>` | `branches.copyPullRequestURL` | Copy the pull request URL |

Patch view of a file in a pull request commit:

| Key | lazygit key | Action |
| --- | --- | --- |
| `c` | `files.commitChanges` | Comment on the selected lines |
| `C` | `files.commitChangesWithEditor` | Comment on the selected lines in the editor |

## Porting to a new lazygit tag

```sh
git -C lazygit fetch --tags origin
git -C lazygit checkout vX.Y.Z
make patch            # resolve conflict markers by hand
make diff
make unpatch
git add lazygit pr-tab.patch && git commit && git tag vX.Y.Z
```

Bump `nixpkgs` in `flake.nix` to a revision that ships lazygit `vX.Y.Z`.

A fix to an already tagged patch gets a new tag, for example `v0.61.1-2`.
