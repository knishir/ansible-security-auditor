# Ansible Security Auditor

A proof-of-concept (PoC) project for automating security checks, audits, and monitoring using Ansible and systemd integration.

## Features
- Automates basic system security audits
- Runs tasks across multiple nodes using Ansible
- Generates detailed audit logs and reports
- Easy integration with existing CI/CD pipelines

## Usage Example

Follow these steps to run the Ansible Security Auditor:

### 1. Prepare Your Inventory
Create an inventory file (`inventory.ini`) with your target hosts:
```ini
[servers]
host_1 ansible_host=192.168.1.10 ansible_user=abuzada
host_2 ansible_host=192.168.1.11 ansible_user=abuzada
```

### 2. Run the Playbook
Execute the main playbook:
```bash
ansible-playbook -i inventory.ini system_audit.yaml
```

### 3. Check Logs
After the playbook finishes, logs and reports will be saved under:
```bash
/opt/ansible/logs/audit-report.log
```

You can view it using:
```bash
sudo cat /opt/ansible/logs/audit-report.log
```

### 4. Example Output
```text
========== SYSTEM AUDIT REPORT ==========
🕒 Uptime:  2 days, 5 hours
💾 Disk Usage: 45% used
⚙️  Running Services: sshd, firewalld, systemd-journald, ...
========================================
```

## Author
knishir
