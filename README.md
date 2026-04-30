# 🖥️ VGPU — ManageIQ Automate Domain

The **VGPU** repository contains a ManageIQ **Automate domain** and related artifacts used for vGPU workflows. The content is maintained as code and can be synchronized with a ManageIQ environment using `rake` tasks.

---

## 🚀 Overview

### 📦 What's included
- 🧩 **Automate code** — `VGPU/`
- 🗂️ **Service dialogs** — `service_dialogs/`
- 🧷 **Custom buttons** — `custom_buttons/`

---

## ✅ Requirements

- A running **ManageIQ** environment.
- Access to the ManageIQ Rails app directory (typically `vmdb`) with `rake` available.
- Repository content present on the target system (copied or mounted).
- The filesystem paths in commands below are **examples** and may differ in your environment.

---

## ⚙️ Import to environment

Import the **Automate domain** from this repository into ManageIQ:

```bash
cd /var/www/miq/vmdb
rake evm:automate:import DOMAIN=VGPU IMPORT_DIR=/opt/manageiq/automation/vgpu OVERWRITE=true ENABLED=true
```

> This command imports only the Automate domain (`VGPU/`). Import related artifacts as needed:

### 🗂️ Service dialogs

```bash
cd /var/www/miq/vmdb
rake evm:import:service_dialogs -- --source=/opt/manageiq/automation/vgpu/service_dialogs
```

### 🧷 Custom buttons

```bash
cd /var/www/miq/vmdb
rake evm:import:custom_buttons -- --source=/opt/manageiq/automation/vgpu/custom_buttons
```

---

## 📤 Export from environment back to repository

Export the **Automate domain** from ManageIQ back into this repository:

```bash
# Export may leave old files for renamed instances/methods — clean the domain folder first.
cd /opt/manageiq/automation/vgpu
rm -rf VGPU

cd /var/www/miq/vmdb
rake evm:automate:export DOMAIN=VGPU EXPORT_DIR=/opt/manageiq/automation/vgpu
```

> The sections below show how to export related artifacts into this repository. Review and commit changes carefully.

### 🗂️ Service dialogs

```bash
rake evm:export:service_dialogs -- --directory=/opt/manageiq/automation/vgpu/service_dialogs
```

> Note: this task may export dialogs not related to this domain. Review changes and commit only what is intended.

### 🧷 Custom buttons

```bash
cd /var/www/miq/vmdb
rake evm:export:custom_buttons -- --directory=/opt/manageiq/automation/vgpu/custom_buttons
```

---

## 📄 License

This project is licensed under the MIT License. See [`LICENSE`](./LICENSE).
