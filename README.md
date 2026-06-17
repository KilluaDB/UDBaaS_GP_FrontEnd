# DBaaS – Database as a Service

A cloud-based **Database as a Service (DBaaS)** platform built using **Flutter Web**, designed to unify the management of **SQL and NoSQL databases** within a single, user-friendly interface. <br>
<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Web-blue" alt="Flutter Web">
  <img src="https://img.shields.io/badge/Backend-Go-00ADD8" alt="Go">
  <img src="https://img.shields.io/badge/Infrastructure-Kubernetes-326CE5" alt="Kubernetes">
  <img src="https://img.shields.io/badge/Database-PostgreSQL-4169E1" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Database-MongoDB-47A248" alt="MongoDB">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</p>

<p align="center">
  🌐 <a href="https://canva.link/2bndapfkj12uwor">Try the Live Demo Here</a>
</p>

##  Project Overview
**DBaaS** simplifies the database lifecycle by abstracting the complexity of infrastructure management. Whether you're working with relational (SQL) or document-oriented (NoSQL) databases, our platform provides a unified environment for provisioning, monitoring, and data manipulation.

##  The Problem & Solution
* **Problem:** Fragmented tools for different database technologies, a steep learning curve for traditional systems, and a lack of intelligent assistance.
* **Solution:** A centralized, automated platform that handles Kubernetes orchestration, database lifecycle management, and provides an intuitive, responsive UI for developers.


---
##  System Architecture
The platform follows a clean architectural pattern that separates the user presentation from the heavy-lifting infrastructure orchestration.

<div align="center">
  <table>
    <tr>
      <td valign="top" width="50%">
        <img src="https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/systme%20arch.png" width="100%">
        <p><b>System Architecture</b></p>
        <p>Illustrates the end-to-end flow of the platform, showing how the Flutter Frontend communicates with the Go-based Control Plane. It highlights the orchestration logic where the Go API Server manages Kubernetes (K3s) resources, enabling dynamic provisioning of isolated tenant databases while leveraging Redis for state management and an AI Multi-Agent system for intelligent schema handling.</p>
      </td>
      <td valign="top" width="50%">
        <img src="https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/FE_arch.png" width="100%">
        <p><b>Frontend Architecture</b></p>
        <p>Details the client-side design, adhering to the MVVM (Model-View-ViewModel) pattern. It demonstrates how Cubit/Bloc manages the application state reactively, ensuring a clean separation between the UI Presentation Layer and the Data Layer, which facilitates seamless API interactions via Dio.</p>
      </td>
    </tr>
  </table>
</div>


## 🛠️ Tech Stack

### Frontend
- Flutter Web
- Dart
- flutter_bloc (Cubit)
- Provider
- Dio
- Mermaid.js

### Backend
- Go (Gin)
- REST APIs
- Redis
- Docker

### Infrastructure
- Kubernetes (K3s)
- PostgreSQL
- MongoDB

### AI Services
- Multi-Agent System
- RAG Pipeline
- Text-to-SQL Engine

---

###  Key Features

* **Secure Authentication:** JWT-based session management with role-based access control.
* **Unified Dashboard:** Manage SQL and NoSQL projects in one place.
* **Declarative Provisioning:** Automated database deployment on Kubernetes.
* **Table/Collection Editor:** Intuitive spreadsheet-like interface for CRUD operations.
* **Schema Visualization:** Dynamic ER-diagram generation powered by **Mermaid.js**.
* **Advanced Query Execution:** Built-in SQL and NoSQL query runners for real-time data interaction and result analysis.
* **Intelligent Text-to-SQL:** AI-powered assistance to convert natural language prompts into executable SQL queries, simplifying complex data retrieval.
* **Data Backup & Recovery:** Reliable snapshots and restoration workflows to ensure data persistence and minimize downtime.
* **Comprehensive NoSQL Operations:** Specialized tooling for document-based operations, including atomic updates, filtering, and complex aggregation queries.
---
##  Database Lifecycle Management

The platform automates the entire database lifecycle:

1. Project Creation
2. Database Provisioning
3. Schema Design
4. Data Manipulation
5. Query Execution
6. Monitoring & Metrics
7. Backup & Recovery
8. Resource Deletion
---
##  Future Roadmap
We are evolving the platform toward production-grade reliability with the following focus areas:

* **Unified Workflow Automation:** Orchestrating the full lifecycle from design to deployment.
* **Better Observability:** Expanding distributed tracing and metrics across all services.
* **Robust Testing:** Expanding end-to-end validation for schema migrations and cluster communication.
* **Smarter AI Assistance:** Advancing the RAG engine for intelligent query and schema handling.
* **Durable Provisioning Queues:** Transitioning from goroutines to Redis-backed queues (Asynq) for fault tolerance.
* **Production Hardening:** Enforcing strict compute isolation using Kubernetes Taints and Tolerations.
* **Multi-Cloud & Multi-Region:** Abstracting infrastructure to support cross-cloud deployments (AWS, GCP, Azure).

---
##  Why DBaaS?

- Reduces infrastructure complexity.
- Unifies SQL and NoSQL management.
- Provides AI-assisted database interaction.
- Enables cloud-native database provisioning.
- Simplifies database administration for developers and startups.
---
## 👥 Team
* **Frontend:** Aya Mohamed Sayed
* **Backend:** Abdallah Hany, Ali Mohamed, Hassan Hussein, Ahmed Bahy
* **AI:** Ali Mohamed, Abdallah Hany, Hassan Hussein

**Supervisor:** Dr. Rania Ramadan

---
> This repository represents the **frontend implementation** of the DBaaS graduation project, focusing on clean architecture, state management, and scalability.
