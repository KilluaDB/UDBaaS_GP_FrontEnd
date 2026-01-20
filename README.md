# DBaaS – Database as a Service

A cloud-based **Database as a Service (DBaaS)** platform built using **Flutter Web**, designed to unify the management of **SQL and NoSQL databases** within a single, user-friendly interface.

This project is developed as a **Graduation Project**, focusing on clean architecture, scalable state management, and future AI integration.

---

## Project Overview

Managing databases today often requires switching between multiple tools depending on the database type (SQL / NoSQL). This fragmentation increases complexity, slows development, and creates a steep learning curve.

**DBaaS** aims to solve this problem by providing:
- A unified dashboard for database projects.
- Support for both SQL and NoSQL databases.
- Cloud-based project management.
- A foundation for AI-powered database interaction (RAG).

---

## Problem Statement

- Fragmented tools for different database technologies.
- High learning curve for traditional database systems.
- Lack of intelligent assistance in schema and query handling.
- Poor user experience for beginners and non-technical users.

---

## Proposed Solution

An integrated, cloud-based platform that:
- Manages SQL and NoSQL databases in one place.
- Simplifies project creation and management.
- Provides a clean and intuitive UI.
- Is extensible with AI (Retrieval-Augmented Generation) for natural language interaction.

---

## Frontend Architecture

- **Framework:** Flutter (Web)
- **Architecture Pattern:** MVVM (View / ViewModel / Logic separation)
- **State Management:**
  - `Cubit (flutter_bloc)` for business logic.
  - `Provider` for app-wide UI and settings state.
- **Key Layers:**
  - Presentation (Screens & Widgets).
  - ViewModel (Cubits & States).
  - Data (Models & API Integration).

---

## Implemented Features & Interface

### 1. Project Management
The platform allows users to create and organize multiple database projects. It features a responsive grid layout that handles various project states including loading, success, and deletion.

| Project Dashboard (Empty State) | Project Selection |
|---|---|
| ![Home](https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/home.png) | ![Display Project](https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/display%20project.png) |
| *Initial view when no projects are created.* | *Grid view showing active SQL and NoSQL projects.* |

### 2. Project Creation Flow
Users can easily spin up new database instances by defining the project name, database engine (SQL/NoSQL), and preferred cloud provider (AWS, GCP, etc.).

![Create Project](https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/createProject.png)



*The simplified workflow for initializing a new database project.*

### 3. Schema & Table Management
For SQL databases, the interface provides a powerful tool to define table structures, primary keys, and column types without writing complex DDL scripts.

| Table Definition | Table Overview |
|---|---|
| ![Create Table](https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/create%20table.png) | ![Display Tables](https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/display%20tables.png) |
| *Form for defining columns, data types, and constraints.* | *List view of all created tables within a project.* |

### 4. Data Manipulation (CRUD Operations)
The platform provides a spreadsheet-like interface for managing records. Users can insert, view, and update data directly through the UI.

**Adding New Records:**
![Add Rows](https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/add%20rows.png)
*Modal interface for inserting new data into specific table columns.*

**Data Visualization & Editing:**
| Viewing Rows | Inline Editing | Updated State |
|---|---|---|
| ![Display Rows](https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/display%20rows.png) | ![Edit Rows](https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/edit%20rows.png) | ![Updated Row](https://github.com/KilluaDB/UDBaaS_GP_FrontEnd/blob/main/images/updated%20row.png) |
| *Tabular view of data.* | *Direct interaction for modifying values.* | *UI feedback after successful data update.* |

---

## State Management Strategy

| Responsibility | Solution |
|---------------|----------|
| Business Logic | Cubit |
| UI State | BlocBuilder / BlocConsumer |
| App Settings | Provider |
| User Data | Provider |

This approach ensures:
- Clean separation of concerns.
- Reusable logic.
- Maintainable and scalable codebase.

---

## Tools & Technologies

- **Frontend:** Flutter (Web)
- **State Management:** flutter_bloc (Cubit), Provider
- **Databases:** PostgreSQL, MongoDB
- **Backend (Planned):** Golang, Spring Boot
- **Cloud & DevOps:** Docker, Kubernetes, AWS / GCP
- **AI (Upcoming):** RAG, LangChain, NLP

---

## Team Members

- **Frontend:** Aya Mohamed Sayed
- **Backend:** Abdallah Hany, Ali Mohamed, Hassan Hussein, Ahmed Bahy
- **Cloud:** Ahmed Bahy
- **AI:** Ali Mohamed, Abdallah Hany, Hassan Hussein

**Supervisor:** Dr. Rania Ramadan

---

## Future Work
- Visual schema designer.
- SQL & NoSQL query editor.
- CSV / JSON import.
- AI-powered query assistant (RAG).
- Versioning and recovery.
- Admin dashboard.

---

> This repository represents the **frontend implementation** of the DBaaS graduation project, focusing on clean architecture, state management, and scalability.
