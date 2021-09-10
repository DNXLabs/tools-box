# update-modules

This tool can help you to update multiples files inside multiples repos at once,
creating pull request to be approved later to the default branch.

## How to run

- Create files that you want to modify from upstream inside `modifications`folder.

- Open `update.sh` and set:
    - BRANCH_NAME="" # e.g update-tf-versions.
    - COMMIT_MESSAGE="" # e.g Bump TF required version to 0.13.
    - PR_TITLE="" # e.g Set minimum terraform version to 1.13.
    - PR_BODY="" # Explain why you are doing this PR.
    - From line `#65` set the files to remove from upstream.
    - From line `#68` set the new file path coming from `modifications` folder.

- Run `bash update.sh`

> On every interaction a PR will be created and if everything went OK, the script will request to press enter to move to the next PR.

## Author

Managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/tools-box/blob/master/LICENSE) for full details.