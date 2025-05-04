# Ride-Sharing Database System

A comprehensive SQL-based backend system designed to support a ride-sharing platform with full functionality for user management, vehicle tracking, ride lifecycle, payments, feedback, and analytics.

---

## 📁 Project Structure

- **DDL.sql** – Schema definitions for all tables.
- **DML.sql** – Sample data inserts for testing core functionality.
- **DQL.sql** – Example queries for analytical and operational use-cases.
- **ERD.png** – Entity-Relationship Diagram illustrating the schema.
- **tables.png** – Visual layout of all tables and key relationships.

---

## 📌 Core Features

### 1. User Management
- **Rider Registration:** Unique email, optional phone, preferred pickup location.
- **Driver Registration:** Includes rating and customer base defaults.
- **Profile Updates:** Email uniqueness enforced; history can be audited.

### 2. Vehicle Management
- **Car Registration:** Cars linked to drivers; unique car numbers.
- **Insurance Details:** Supports multiple policies over time, flag expired ones.

### 3. Ride Management
- **Request Ride:** Links rider, driver, and car; estimates stored.
- **Ride Lifecycle:** Tracks start/end time and status transitions.
- **GPS Tracking:** Stores timestamped latitude/longitude per ride.

### 4. Financial Operations
- **Bank Cards:** Stores masked card numbers; expiry validated.
- **Receipts:** Calculates total from fare and tip.
- **Revenue Reports:** Summarized by driver/month.

### 5. Feedback and Support
- **Ratings & Reviews:** Enforces 1–5 rating scale; no duplicates.
- **Complaints:** Filed by riders against drivers.
- **Support Tickets:** Tracks ticket status from open to resolved.

### 6. Reporting & Analytics
- **Popular Routes & Demand:** Extracted from GPS and ride data.
- **Driver Availability:** Identifies idle drivers.
- **Financial Summaries:** Monthly/quarterly revenue reports.

---

## 🧩 Schema Highlights

- Relational integrity via foreign keys
- Composite keys for time-bound insurance tracking
- Constraints (e.g., email uniqueness, rating bounds)
- Default values and validation logic to ensure data quality

---

## 📷 Visuals

- **ERD.png**: Complete database structure with relationships
- **tables.png**: Table-wise breakdown for quick reference

---


## 🛠️ Technologies

- **PostgreSQL** 


---

