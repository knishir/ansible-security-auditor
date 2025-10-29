#!/bin/bash
# ==========================================
#  Ansible Security Auditor - Run Script
# ==========================================
# Author: knishir
# Description: Automates the execution of Ansible security audit playbooks
# ==========================================

LOG_DIR="/opt/ansible/logs"
PLAYBOOK_DIR="/root/ansible-security-auditor/playbooks"
LOG_FILE="$LOG_DIR/audit_run_$(date +%Y-%m-%d_%H-%M-%S).log"

# Create log directory if missing
mkdir -p "$LOG_DIR"

echo "🚀 Starting Ansible Security Auditor..."
echo "------------------------------------------"
echo "Log file: $LOG_FILE"
echo "------------------------------------------"

# Check Ansible installation
if ! command -v ansible-playbook &> /dev/null; then
    echo "❌ Ansible is not installed. Please install it using 'dnf install ansible -y'"
    exit 1
fi

# Check if playbooks exist
if [ ! -d "$PLAYBOOK_DIR" ]; then
    echo "❌ Playbook directory not found: $PLAYBOOK_DIR"
    exit 1
fi

# Run all playbooks in order
for playbook in "$PLAYBOOK_DIR"/*.yml "$PLAYBOOK_DIR"/*.yaml;
do
    echo "🔍 Running playbook: $playbook"
    ansible-playbook "$playbook" | tee -a "$LOG_FILE"
    if [ $? -ne 0 ]; then
        echo "⚠️  Error running $playbook. Check log for details."
    else
        echo "✅ Completed: $playbook"
    fi
    echo "------------------------------------------"
done

echo "🎯 All playbooks executed. Logs saved at $LOG_FILE"
