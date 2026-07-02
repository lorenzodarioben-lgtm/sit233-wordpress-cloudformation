#!/usr/bin/env bash
set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"
templates=("networking.yaml" "application.yaml")

echo "Repository root: ${repo_root}"

if ! command -v cfn-lint >/dev/null 2>&1; then
  echo "cfn-lint was not found on PATH. Install it with: python -m pip install cfn-lint" >&2
  exit 127
fi

cd "${repo_root}"

for template in "${templates[@]}"; do
  if [[ ! -f "${template}" ]]; then
    echo "Required template not found: ${template}" >&2
    exit 1
  fi
done

echo "Using cfn-lint: $(command -v cfn-lint)"
cfn-lint --version

echo "Linting CloudFormation templates..."
set +e
cfn-lint --non-zero-exit-code error -t "${templates[@]}"
lint_exit_code=$?
set -e

if [[ ${lint_exit_code} -ne 0 ]]; then
  echo "CloudFormation validation failed with cfn-lint exit code ${lint_exit_code}." >&2
  exit "${lint_exit_code}"
fi

echo "CloudFormation validation completed without error-level findings."
