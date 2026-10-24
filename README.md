# 🩺 Colorectal Cancer Patient Survival Prediction - Clinical MLOps Platform

[![Architecture Flow](docs/images/01_architecture_flow.svg)](docs/images/01_architecture_flow.svg)

[![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-2.0+-000000?style=for-the-badge&logo=flask&logoColor=white)](https://flask.palletsprojects.com/)
[![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![MLflow](https://img.shields.io/badge/MLflow-Tracking-0194E2?style=for-the-badge&logo=mlflow&logoColor=white)](https://mlflow.org/)
[![ROC-AUC](https://img.shields.io/badge/ROC--AUC-0.88+-brightgreen?style=for-the-badge)](ARCHITECTURE.md)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

An enterprise-grade, clinical Machine Learning decision-support system built according to the **Enterprise AI Architect Roadmap (Phases 0 - 5)**. Forecasts colorectal cancer patient survival probability using statistical biomarker selection (Chi-Square test) and calibrated Gradient Boosting classifiers with sub-10ms latency.

---

## ⚡ One-Click Cloud Bootstrap (Zero-Touch)

Deploy the entire clinical platform on any Ubuntu, Debian, AWS EC2, GCP Compute Engine, or macOS instance with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/KishorKumarParoi/Colorectal-Cancer-Prediction/main/bootstrap.sh | bash
```

This script automatically provisions required system packages, clones the repository, builds the container image, and starts the clinical serving pipeline with automated health validation.

---

## 🚀 Quick Start & Deployment Options

Clone and launch locally using the unified `deploy.sh` script:

```bash
git clone https://github.com/KishorKumarParoi/Colorectal-Cancer-Prediction.git
cd Colorectal-Cancer-Prediction
chmod +x deploy.sh clear.sh bootstrap.sh
```

### 1. Docker Compose Mode (Default)
```bash
./deploy.sh
```
*Builds and runs the clinical web application and REST API on port 5001.*

### 2. Standalone Container Mode
```bash
./deploy.sh --quick
```

### 3. Native Host Execution
```bash
./deploy.sh --host
```

---

## 🧹 Zero-Cost Teardown ($0.00 Spend)

To cleanly stop and eliminate all active containers, networks, and background processes:

```bash
./clear.sh
```

---

## 📡 API Reference & Integration

### 1. Health Probe
```bash
curl -s http://localhost:5001/health | jq .
```
**Response:**
```json
{
  "model_loaded": true,
  "scaler_loaded": true,
  "status": "healthy"
}
```

### 2. Real-Time Patient Survival Prediction
```bash
curl -s -X POST http://localhost:5001/api/predict \
  -H "Content-Type: application/json" \
  -d '{
    "healthcare_costs": 45000.0,
    "tumor_size": 32.5,
    "treatment_type": "surgery",
    "diabetes": "no",
    "mortality_rate": 14.2
  }' | jq .
```
**Response:**
```json
{
  "confidence": 88.5,
  "inputs": {
    "diabetes": "no",
    "healthcare_costs": 45000.0,
    "mortality_rate": 14.2,
    "treatment_type": "surgery",
    "tumor_size": 32.5
  },
  "prediction": "Yes",
  "probabilities": {
    "p_no": 11.5,
    "p_yes": 88.5
  },
  "status": "success",
  "survival_likely": true
}
```

### 3. Prometheus Metrics Exporter
```bash
curl -s http://localhost:5001/metrics
```

---

## 🏗️ Architecture & Technical Specifications

For full architectural blueprints, mathematical derivations of gradient boosting, Chi-Square statistical feature selection, and HIPAA compliance mapping, consult [ARCHITECTURE.md](ARCHITECTURE.md).

```
+----------------------------------------------------------------------------------------------------+
|                                    CLINICAL ARCHITECTURE FLOW                                       |
+----------------------------------------------------------------------------------------------------+
 [ Clinical EHR Ingestion ]    [ Chi2 Biomarker Selection ]           [ Real-Time Serving ]
 Patient Cohort Data --------> SelectKBest & StandardScaler --------> Flask REST API (:5001)
 (PII Scrubbing: Patient_ID)   Top 5 Significant Biomarkers           P95 Latency < 10ms
                                           |                                   ^
                                           v                                   |
                               [ Gradient Boosting Classifier ] ---------------+
                               ROC-AUC: 0.88+ | artifacts/models/model.pkl
```

---

## 📊 Feature Definitions & Schema

| Clinical Feature | Type | Range / Options | Clinical Meaning |
| :--- | :--- | :--- | :--- |
| `Healthcare_Costs` | Float | `0.0 - 500,000.0` | Total medical expenditure allocated to oncology care |
| `Tumor_Size_mm` | Float | `0.1 - 250.0` | Maximum tumor diameter in millimeters (pathology/imaging) |
| `Treatment_Type` | Categorical | `surgery`, `chemotherapy`, `radiotherapy`, `combination` | Primary therapeutic intervention protocol |
| `Diabetes` | Binary | `yes`, `no` | Patient comorbidity diagnosis |
| `Mortality_Rate_per_100K` | Float | `0.0 - 100.0` | Epidemiological regional baseline mortality |

---

## 📜 License
This project is open-source and licensed under the [MIT License](LICENSE).
