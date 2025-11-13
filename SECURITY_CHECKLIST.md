# Dependency Security Checklist
*Software Composition Analysis (SCA) — Dependency Risk Control*

**Usage:**  
Use this checklist during dependency updates, PR reviews, or release audits.  
Prioritize remediation based on CVSS severity (Critical > High > Medium > Low).

---

## 🎯 Goal
Ensure all third-party dependencies are **secure, up-to-date, verified**, and **free from known vulnerabilities** across Python, JavaScript, and other ecosystems.

---

## 🔸 Package Management Hygiene
- [ ] Dependencies are version-pinned (`==`, exact versions). (P0)  
- [ ] No usage of deprecated, unmaintained, or abandoned libraries. (P1)  
- [ ] Remove unused or redundant dependencies. (P1)  
- [ ] Maintain a lockfile (`package-lock.json`, `poetry.lock`, etc.). (P1)  
- [ ] Avoid direct GitHub/raw URLs or local tarballs unless verified. (P2)  
- [ ] Private packages hosted in trusted registries only. (P1)  
- [ ] License compliance checked (GPL, AGPL, etc.). (P3)  

---

## 🔸 Vulnerability Scanning & Monitoring
- [ ] Run `pip-audit`, `npm audit`, and/or `osv-scanner` weekly. (P1)  
- [ ] CVEs tracked and triaged by severity (Critical, High, Medium, Low). (P1)  
- [ ] CI/CD workflow integrates automated dependency scans. (P0)  
- [ ] Alerts for new CVEs in production dependencies configured (e.g., Dependabot, Snyk). (P2)  
- [ ] Scan results archived under `/report/`. (P2)  

**Testing**
- [ ] Run SCA tools on both source and container images. (P2)  
- [ ] Simulate outdated dependency to verify alert pipeline. (P3)  

---

## 🔸 Verification & Integrity
- [ ] Verify package signatures and checksums (where supported). (P1)  
- [ ] Enable provenance / SBOM (Software Bill of Materials). (P2)  
- [ ] Prefer libraries with active maintainers and frequent releases. (P2)  
- [ ] Validate 3rd-party registries via HTTPS and trusted CA. (P0)  

**Testing**
- [ ] Review SBOM and check provenance fields (P2).  
- [ ] Validate CI/CD pipeline restricts arbitrary package uploads (P0).  

---

## 🔸 Response & Remediation
- [ ] Patch Critical CVEs immediately (within 24h). (P0)  
- [ ] High severity CVEs fixed or mitigated within 7 days. (P1)  
- [ ] Medium/Low CVEs reviewed quarterly. (P3)  
- [ ] Document all CVE handling actions in `/report/` or issue tracker. (P2)  

**Testing**
- [ ] Run simulated CVE remediation workflow (e.g., test Dependabot PR). (P3)  

---

## 🔸 CI/CD & Governance
- [ ] Dependency scanning enforced as part of merge gate (P0).  
- [ ] Failed scans block merge until resolved. (P1)  
- [ ] Secret management separated from dependency files. (P0)  
- [ ] Version bump reviewed manually before merge. (P1)  
- [ ] Audit logs retained for all dependency updates. (P2)  

---

## 📘 Recommended Tools
| Ecosystem | Tool | Purpose |
|------------|------|----------|
| Python | `pip-audit`, `safety` | Detect vulnerable PyPI packages |
| JavaScript | `npm audit`, `yarn audit` | Detect vulnerable npm packages |
| Multi-language | `osv-scanner`, `OWASP Dependency-Check` | Unified CVE scanning |
| CI/CD | `Dependabot`, `Snyk`, `GitHub Security Alerts` | Continuous vulnerability alerts |

---

**Note:**  
Always validate findings manually before patching in production.  
Automated upgrades may break dependencies — review changelogs and test thoroughly.
