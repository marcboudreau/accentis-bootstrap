accentis-bootstrap
===

This repository contains the procedure to bootstrap all systems used by the Accentis project.

# Prerequisites

This section describes prerequisites that must be in place ahead of time since their automation is not feasible.

## GitHub.com

[GitHub.com](https://github.com/) is used as the SCM for the Accentis project.  A GitHub.com account or organization is setup.  A GitHub.com [Personal Access Token](https://github.com/settings/tokens/) from the user account (or from a user account with Owner access over the GitHub.com organization) with the following scopes will be needed:
* read:org

## Terraform Cloud

[Terraform Cloud](https://app.terraform.io/) is used to run Terraform projects.  A Terraform Cloud account has been setup.  A Terraform Cloud [ API Token](https://app.terraform.io/app/settings/tokens/) will be needed.

## Google Cloud Platform

[Google Cloud Platform](https://console.cloud.google.com/) is used to host our cloud resources.  A GCP project must be created using the [Cloud Console](https://console.cloud.google.com/).

## Workstation

The workstation used to execute this procedure must have the following components installed:

* Docker (version 19.03 or greater)
* Bash (version 3.2 or greater)

# Design

This procedure is designed around a Terraform project.  The Terraform configuration contained in this project is never intended to be destroyed, as such only permanent resources should be included in this configuration.  Permanent resources are resources that CANNOT be destroyed and rebuilt (e.g. a Cloud KMS keyring or key).  Also, care should be taken to not include resources that incur costs in this project, since they are always present even when no active development is being done on the project.

# Procedure

Once all of the above prerequisites are in place, the procedure can be executed.  The procedure is idempotent, as such if additional bootstrap setup is needed after the initial setup, this repository should be modified and the procedure re-executed.

In a nutshell, this procedure consists of executing a Bash script that will use Docker containers to run various tools with various directories from this workstation mounted as Docker volumes.  This eliminates the need to have multiple tools installed on the workstation.

## Running

To launch the procedure, launch a Bash shell in a terminal window, change to this repository's directory, and then execute the following command:

```
$ ./configure.sh <terraform_command> [ <terraform_command_argument>... ]
```

The script is interactive and will prompt the operator for some needed values, such as the various tokens mentioned in the prerequisite section.

Once all necessary input has been captured, the procedure will formulate a plan which indicates all of the modifications that need to be made to various systems.  The operator will be given a chance to review this plan and must answer `yes` to the prompt in order for the procedure to continue.

### Accentis Vault

This procedure is designed to function when the project is just getting off the ground and nothing is in place, but it is also designed to continue to function as the infrastructure is in place (in order to add resources to or update existing resources from this project).  Once Accentis Vault is setup, it can be used to retrieve many of the sensitive values that are obtained from operator by this procedure.  In order to use Accentis Vault, the following environment variables must be set appropriately:
* **ACCENTIS_VAULT_ADDR**: The address of the Accentis Vault consisting of the scheme, the FQDN, and the port number.
* **ACCENTIS_VAULT_TOKEN**: A token obtained from the Accentis Vault as a result of successfully authenticating.

# Execution State

Since this procedure is designed such that it can be run multiple times, a state file is generated to record the state of all resources after every execution.  This state file is saved to the `./state/terraform.tfstate` path under this repository's directory.  This path is ignored by git, so it will not be committed to GitHub.com.  This state file will contain sensitive data and therefore must be protected.  If this procedure is to be executed from another workstation, a copy of the state file must be saved on that workstation at the same relative path.
