# DBaaS – Database as a Service

A cloud-based **Database as a Service (DBaaS)** platform built using **Flutter Web**, designed to unify the management of **SQL and NoSQL databases** within a single, user-friendly interface.

🌐 **[Try the Live Demo Here](https://canva.link/2bndapfkj12uwor)**

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

##  Project Overview
**DBaaS** simplifies the database lifecycle by abstracting the complexity of infrastructure management. Whether you're working with relational (SQL) or document-oriented (NoSQL) databases, our platform provides a unified environment for provisioning, monitoring, and data manipulation.

##  The Problem & Solution
* **Problem:** Fragmented tools for different database technologies, a steep learning curve for traditional systems, and a lack of intelligent assistance.
* **Solution:** A centralized, automated platform that handles Kubernetes orchestration, database lifecycle management, and provides an intuitive, responsive UI for developers.

---

## Frontend Architecture
Built for scalability and maintainability:
* **Framework:** Flutter (Web)
* **Pattern:** MVVM (Separation of View, ViewModel, and Data layers).
* **State Management:** `flutter_bloc` (Cubit) for business logic and `Provider` for app-wide settings.
* **API Integration:** Secure communication with our Go-based backend.

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

## 👥 Team
* **Frontend:** Aya Mohamed Sayed
* **Backend:** Abdallah Hany, Ali Mohamed, Hassan Hussein, Ahmed Bahy
* **Cloud:** Ahmed Bahy
* **AI:** Ali Mohamed, Abdallah Hany, Hassan Hussein

**Supervisor:** Dr. Rania Ramadan

---
> This repository represents the **frontend implementation** of the DBaaS graduation project, focusing on clean architecture, state management, and scalability.
