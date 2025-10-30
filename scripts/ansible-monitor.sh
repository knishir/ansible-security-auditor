#!/usr/bin/env bash
set -euo pipefail

# Simple error handler
on_error() {
  echo "ERROR on line $1. Exit code: $2" >&2
  exit 1
}
trap 'on_error $LINENO $?' ERR

# ===== Configuration (small, change later) =====
REPO_DIR="/root/ansible-security-auditor"
PLAYBOOK="playbooks/basic_audit.yaml"
INVENTORY="${2:-inventory.ini}"
LOG_DIR="/opt/ansible/logs"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOGFILE="${LOG_DIR}/ansible-run-${TIMESTAMP}.log"
SERVICE_NAME="ansible-monitor.service"
LOG_RETENTION_DAYS=14
# ==============================================

echo "=== ansible-monitor (step1) starting at $(date) ==="
echo "REPO_DIR: $REPO_DIR"
echo "PLAYBOOK: $PLAYBOOK"
echo "INVENTORY: $INVENTORY"
echo "LOG_DIR: $LOG_DIR"
echo "LOGFILE: $LOGFILE"
echo "SERVICE_NAME: $SERVICE_NAME"
echo "LOG_RETENTION_DAYS: $LOG_RETENTION_DAYS"
echo "=== step1 done ==="



# === Step2: Checking the log directory ===

if [ ! -d "$LOG_DIR" ]; then
  echo "Creating log directory: $LOG_DIR"
  mkdir -p "$LOG_DIR"
else
  echo "Log directory already exists: $LOG_DIR"
fi
echo "Verified log directory: $(ls -ld $LOG_DIR)"
echo "=== step2 done ==="


echo "Verified log directory: $(ls -ld $LOG_DIR)"
echo "=== step2 done ==="




# === Step3: check for ansible-playbook availability ===
if command -v ansible-playbook >/dev/null 2>&1; then
  echo "✅ ansible-playbook found at: $(command -v ansible-playbook)"
else
  echo "❌ ansible-playbook not found! Please install Ansible before running this script."
  exit 3
fi
echo "=== step3 done ==="




# === Step4: pull latest changes from Git if available ===
if [ -d "${REPO_DIR}/.git" ]; then
  echo "Found Git repository in ${REPO_DIR}. Checking for updates..."
  pushd "$REPO_DIR" >/dev/null
  if git pull --ff-only; then
    echo "✅ Repository updated successfully."
  else
    echo "⚠️  git pull failed or not a fast-forward merge. Continuing with local copy."
  fi
  popd >/dev/null
else
  echo "❌ No Git repository found in ${REPO_DIR}. Skipping git pull."
fi
echo "=== step4 done ==="



# === Step5: Run the Ansible playbook and log output ===
echo "Running ansible-playbook..."
{
  echo "=== ansible-playbook started at $(date) ==="
cd "$REPO_DIR" || { echo "❌ Failed to cd into $REPO_DIR"; exit 1; }
ansible-playbook -i "$INVENTORY" "$PLAYBOOK"
  echo "=== ansible-playbook finished at $(date) ==="
} | tee -a "$LOGFILE"

if [ ${PIPESTATUS[0]} -eq 0 ]; then
  echo "✅ ansible-playbook executed successfully. Log saved to: $LOGFILE"
else
  echo "❌ ansible-playbook failed. Check log: $LOGFILE"
fi

echo "=== step5 done ==="
