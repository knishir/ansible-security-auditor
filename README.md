# 🔐 Ansible Security Auditor

A **proof-of-concept (PoC)** project for automating system security audits, monitoring, and compliance checks using **Ansible** and **systemd** integration.  
It allows administrators and DevSecOps teams to perform consistent, repeatable audits across multiple servers with minimal effort.

---

## ⚙️ Overview

The **Ansible Security Auditor** automates security checks and system status collection from multiple remote nodes.  
It leverages **Ansible playbooks** to perform tasks like:
- Checking uptime, disk usage, and system load
- Listing all active systemd services
- Generating reports in a structured format
- Storing logs centrally under `/opt/ansible/logs/`

This tool can be integrated into your **CI/CD pipeline**, **monitoring stack**, or **compliance automation** process.

---

## ✨ Features

- 🔍 Automates basic system security audits
- 🧩 Supports multi-node operations via Ansible inventory
- 🧾 Generates detailed audit logs and reports
- ⚙️ Integrates seamlessly with `systemd` and Linux service management
- 🪶 Lightweight and extensible structure — easy to customize for your environment

---

## 📂 Project Structure

```
ansible-security-auditor/
├── inventory.ini                # List of managed hosts
├── system_audit.yaml            # Main Ansible playbook
├── roles/                       # (Optional) Custom Ansible roles
├── logs/                        # Directory for generated reports and logs
├── README.md                    # Documentation
└── ansible.cfg                  # Ansible configuration file
```

> 💡 Logs and reports are typically stored in:  
> `/opt/ansible/logs/audit-report.log`

---

## 🚀 Usage Example

Follow these steps to run the **Ansible Security Auditor**:

### 1. Prepare Your Inventory

Create an inventory file named `inventory.ini` with your target hosts:
```ini
[servers]
host_1 ansible_host=192.168.1.10 ansible_user=abuzada
host_2 ansible_host=192.168.1.11 ansible_user=abuzada
```

### 2. Run the Playbook

Execute the audit playbook:
```bash
ansible-playbook -i inventory.ini system_audit.yaml
```

### 3. Check Logs

After the playbook completes, view the generated report:
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

---

## 🧠 How It Works

1. **System Information Collection**  
   The playbook gathers uptime, disk usage, and running services from each host.

2. **Centralized Logging**  
   Results are formatted and stored in `/opt/ansible/logs/audit-report.log`.

3. **Systemd Integration**  
   You can configure a `systemd` service and timer to run the audit automatically on a schedule.

4. **Scalability**  
   Simply add more nodes to `inventory.ini` — Ansible handles the rest.

---

## 🧩 Future Improvements

- Add vulnerability scanning modules (Lynis, OpenSCAP)
- Include service hardening checks
- Push results to a dashboard (e.g., Grafana or ELK)
- Implement notification hooks (Slack, email, etc.)

---

## 👨‍💻 Author

**knishir**  
Security & Infrastructure Automation Enthusiast  
📦 GitHub: [knishir](https://github.com/knishir)

---

## 📜 License

This project is open-source and available under the **MIT License**.

---
