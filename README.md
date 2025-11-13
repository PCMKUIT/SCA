# 🛡️ Software Composition Analysis (SCA) Workflow

This repository provides an automated **Software Composition Analysis (SCA)** workflow designed to proactively detect vulnerable and outdated dependencies in Python and JavaScript/Node.js projects.

By leveraging industry-standard open-source tools—**pip-audit**, **npm audit**, and **osv-scanner**—this solution ensures dependency security is validated automatically within the CI/CD pipeline.

---

## 🎯 **Objective**

The primary goal is to **shift-left** dependency security, identifying and mitigating risks early by:
* Scanning dependency manifests (`requirements.txt`, `package.json`, etc.).
* Generating standardized, actionable reports with CVE details and remediation suggestions.
* Enforcing security checks via GitHub Actions **before** code is merged into main branches.

---

## 📂 **Project Structure & Components**

| Folder/File | Description |
| :--- | :--- |
| `tools/` | Contains reusable shell scripts for running local and CI-based dependency audits. |
| `report/` | Stores the output files (Markdown/JSON) from the latest vulnerability scans. |
| `.github/workflows/` | GitHub Actions pipeline (`dependency_scan.yml`) for automated SCA on Pull Requests. |
| `SECURITY_CHECKLIST.md` | A core document outlining security requirements and remediation steps for developers. |
| `.github/PULL_REQUEST_TEMPLATE.md` | Enforces the security review checklist as a mandatory step in every PR. |

---

## 🚀 **Usage**

For developers, running the scanners locally is straightforward:

### 🔹 **Local Scan (Python)**

```bash
bash tools/pip_audit.sh
