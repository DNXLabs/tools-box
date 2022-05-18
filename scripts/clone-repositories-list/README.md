# clone-repositories

This script clones a list of GIT repositories.

## Use case:

Used extensively to clone private repositories locally using local or CICD pipeline credentials, eliminating the need to export or store GIT credentials.

_Examples:_

- Terraform modules stored in private repositories
- Applications that uses private repositories as dependencies.

## Prerequisites

- Bash
- GIT


## How to run

- Export the required environment variables:
    - `ORG_NAME` = Organization name eg:. `export ORG_NAME=DNXLabs`
    - `VCS_URL` = Version control system eg:. `export VCS=github.com`
- From the command line run: `bash clone-repositories.sh "repo-1@1.0.1" repo-2@1.2.1" "repo-3@2.0.3"`

## Versioning

1.0.0


## Author

* **Woltter Xavier** - *Initial work* - [wvxavier](https://github.com/wvxavier)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/tools-box/blob/master/LICENSE) for full details.
