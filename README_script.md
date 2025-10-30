# 🧩 Ansible Security Auditor (Automated Monitoring & Auditing System)

## 📘 Overview

The **Ansible Security Auditor** is a fully automated system audit and monitoring solution.  
It uses **Ansible playbooks**, **systemd services**, and a **Bash automation script** (`ansible-monitor.sh`) to perform regular audits across multiple Linux nodes.  

It checks:
- System uptime  
- Logged-in users  
- Disk usage  
- Other basic health metrics  

Each run automatically:
- Updates the Git repository  
- Executes the selected Ansible playbook  
- Stores logs in `/opt/ansible/logs`  
- Cleans up old logs  
- Can be managed via a systemd service (`ansible-monitor.service`)

---

## 📁 Directory & File Structure

```
/root/ansible-security-auditor
│
├── ansible-auditor.service       # systemd service unit file
├── ansible-auditor.timer         # optional timer for scheduled runs
├── ansible-monitor.sh            # main automation script
├── inventory.ini                 # Ansible inventory (nodes to audit)
├── LICENSE                       # license file
├── README.md                     # this documentation
├── run_audit.sh                  # standalone audit trigger (optional)
│
├── playbooks/                    # folder for all playbooks
│   ├── basic_audit.yaml          # simple audit: uptime, users, disk usage
│   └── advanced_audit.yaml       # extended audit checks
│
└── scripts/                      # helper or extended scripts
```

---

## ⚙️ Prerequisites

- Ansible installed (`ansible-playbook` command available)
- Proper SSH connectivity between control node and target nodes
- Inventory file configured correctly (`inventory.ini`)
- Script executable permissions:
  ```bash
  chmod +x ansible-monitor.sh
  ```

---

## 🚀 Running the Automation

Run the monitoring script manually:
```bash
./ansible-monitor.sh
```

### What it does:
Each execution runs through **6 automated steps:**

#### **Step 1: Initialization**
- Reads and prints key configuration:
  - Repository path
  - Playbook to run
  - Inventory file
  - Log location
  - Service name

#### **Step 2: Verify Log Directory**
- Ensures `/opt/ansible/logs` exists (creates if missing)
- Checks permissions

#### **Step 3: Validate Ansible**
- Checks if `ansible-playbook` is installed and accessible

#### **Step 4: Git Update**
- Pulls the latest changes from the remote repository

#### **Step 5: Run Ansible Playbook**
- Executes the selected playbook
- Captures output and stores it in `/opt/ansible/logs/<timestamp>.log`

#### **Step 6: Log Cleanup**
- Removes logs older than 14 days

---

## 📊 Sample Output

Example successful run:
```
PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=3    failed=0
node1                      : ok=5    changed=3    failed=0
node2                      : ok=5    changed=3    failed=0
✅ ansible-playbook executed successfully. Log saved to: /opt/ansible/logs/ansible-run-20251030_130251.log
```

---

## 🧾 Logs

- **Path:** `/opt/ansible/logs/`
- Each run creates a new log with timestamp.
- Logs older than 14 days are automatically deleted.

---

## 🔁 Integration with systemd

### 1️⃣ Create the service file:
`/etc/systemd/system/ansible-monitor.service`
```ini
[Unit]
Description=Ansible Monitoring Service
After=network.target

[Service]
ExecStart=/root/ansible-security-auditor/ansible-monitor.sh
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
```

### 2️⃣ (Optional) Add a timer for regular execution:
`/etc/systemd/system/ansible-monitor.timer`
```ini
[Unit]
Description=Run Ansible Monitor every hour

[Timer]
OnBootSec=5min
OnUnitActiveSec=1h

[Install]
WantedBy=timers.target
```

Then enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable ansible-monitor.service
sudo systemctl start ansible-monitor.service
sudo systemctl enable ansible-monitor.timer
sudo systemctl start ansible-monitor.timer
```

---

## ⚡ Git Integration

The script automatically runs:
```bash
git pull
```
before every Ansible execution to ensure you always use the latest playbooks and scripts.

To manually push updates:
```bash
git add .
git commit -m "Updated playbooks and scripts"
git push origin main
```

---

## 🧠 Troubleshooting

| Issue | Possible Cause | Solution |
|-------|----------------|-----------|
| `ERROR! the playbook could not be found` | Wrong playbook path | Update `PLAYBOOK` variable in `ansible-monitor.sh` |
| `Permission denied` | Script not executable | `chmod +x ansible-monitor.sh` |
| `ansible-playbook not found` | Ansible not installed | Install using `apt install ansible` or `yum install ansible` |
| Git errors | Remote repo misconfigured | Re-run `git remote -v` or check network connectivity |
| Log not created | Missing `/opt/ansible/logs` directory | Manually create it with correct permissions |

---

## 🧩 Customization

- Modify `basic_audit.yaml` to add or remove system checks.
- Add new playbooks to `/playbooks/` and update the `PLAYBOOK` path in the script.
- You can change the log retention period by editing:
  ```bash
  LOG_RETENTION_DAYS=14
  ```

---

## 🏁 Summary

| Feature | Description |
|----------|-------------|
| **Automation Script** | ansible-monitor.sh manages everything end-to-end |
| **Git Integration** | Ensures latest repo state |
| **Log Management** | Automatic rotation and cleanup |
| **Systemd Support** | Runs automatically as a service/timer |
| **Multi-Node Audit** | Runs on all nodes in inventory.ini |

---

**✅ With this setup, anyone can clone the repo, follow this README, and get a working multi-node audit automation in minutes.**
