# 🛡️ Ansible Security Auditor

A proof-of-concept (PoC) project that automates Linux system audits and security checks using **Ansible** and **systemd**.

It collects data like uptime, disk usage, running services, open ports, failed SSH logins, firewall status, and more — automatically every day.

---

## 🚀 Features

- ✅ Automated daily audits via `systemd.timer`
- 📋 Collects key system health and security data
- 🧠 Central log storage under `/opt/ansible/logs/`
- 🪄 Works with multiple nodes via SSH and Ansible inventory
- 🔐 Detects failed login attempts and open ports

---

## 🧱 Directory Structure

```
/opt/ansible/
├── inventory.ini          # Target hosts list
├── playbooks/
│   └── audit_system.yaml  # Main audit playbook
├── logs/
│   ├── audit-report.log   # Detailed audit output
│   └── audit-systemd.log  # Log from systemd job
└── systemd/
    ├── ansible-audit.service
    └── ansible-audit.timer
```

---

## ⚙️ Setup Instructions

### 1️⃣ Clone this repository
```bash
git clone https://github.com/knishir/ansible-security-auditor.git
cd ansible-security-auditor
```

### 2️⃣ Install Ansible
```bash
sudo dnf install ansible -y
```

### 3️⃣ Create directories
```bash
sudo mkdir -p /opt/ansible/playbooks /opt/ansible/logs
sudo chown -R root:root /opt/ansible
sudo chmod -R 755 /opt/ansible
```

### 4️⃣ Add your inventory file
Example:
```ini
[servers]
server1 ansible_host=192.168.1.10 ansible_user=root
```

Save it as `/opt/ansible/inventory.ini`

### 5️⃣ Run the audit manually
```bash
ansible-playbook -i /opt/ansible/inventory.ini /opt/ansible/playbooks/audit_system.yaml
```

### 6️⃣ Automate the audit with systemd
Enable the timer:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now ansible-audit.timer
```

Check status:
```bash
systemctl list-timers | grep ansible-audit
```

---

## 📊 Output Example

```
========== SYSTEM AUDIT REPORT ==========
🕒 Uptime:  12:05:01 up 3 days,  load average: 0.02, 0.01, 0.00
💾 Disk Usage: Filesystem      Size  Used Avail Use% Mounted on
⚙️ Running Services: sshd, systemd-journald, ...
🧠 CPU & Memory: top output
🔐 SSH Status: active
🚫 Failed Logins: None
🧱 Firewall: running
🌐 Open Ports: 22, 80, 443
========================================
```

---

## 👨‍💻 Author

**Nishir Karmakar (@knishir)**  
Built as part of a security automation PoC project using Ansible + systemd.

---

## 🧰 Future Enhancements

- Integration with Prometheus for visual dashboards  
- Email/Slack alerts for audit anomalies  
- Remote node scanning with tags  
- Log rotation and archiving

---

⭐ **If you find this project helpful, give it a star on GitHub!**
