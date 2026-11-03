#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="./docs/example-library/meltano-run/integration-test.log"

# Custom validations for the `meltano-run` guide/test.

# test that the job's extract-load block completed (the dbt steps were dropped: dbt 1.3 does not run on Python 3.12)
grep "Block run completed.           block_type=ExtractLoadBlocks err=None set_number=0 success=True" $LOG_FILE

# we could also run psql statements
# check for the existance of files
# etc
source "$(git rev-parse --show-toplevel)/integration/commons.sh"
cd "${TEST_DOCS_DIR}"
meltano state list | grep "dev:tap-gitlab-to-target-postgres"
meltano state get dev:tap-gitlab-to-target-postgres | grep "singer_state"
