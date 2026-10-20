<div align="center">

<img src="./assets/branding/logo.jpg" alt="WanderAI Logo" width="140" style="border-radius: 24px; box-shadow: 0 8px 32px rgba(14, 165, 233, 0.35);" />

# WanderAI Assistant

### Autonomous AI Travel Companion, Dynamic Itinerary Planner & Smart Route Navigator

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

<p align="center">
  <b>WanderAI</b> is a full-stack, AI-driven personal travel concierge and autonomous itinerary builder. Powered by a natural language processing (NLP) recommendation backend, multi-stop routing algorithms, Points of Interest (POI) clustering, and an interactive cross-platform Flutter client.
</p>

</div>

---

## 🌟 Platform Architecture

WanderAI connects modern travelers with personalized destinations, scenic attractions, and real-time smart itineraries generated on the fly.

```mermaid
graph TD
    subgraph Client Experience
        direction TB
        App[Flutter Mobile Application]
        App --> C1[Natural Language AI Travel Chatbot]
        App --> C2[Smart Itinerary Generator & Timeline]
        App --> C3[Interactive Route & Attraction Maps]
        App --> C4[Curated Destination Exploration]
        App --> C5[Trip Budgeting & Package Booking]
    end

    subgraph AI & Backend Services
        direction TB
        API[FastAPI REST Gateway / Python]
        API --> NLP[NLP Travel Recommendation Engine]
        API --> POI[Point of Interest & Attraction Matcher]
        API --> ROUTE[Multi-Stop Routing & Distance Matrix]
    end

    subgraph Data & Persistence
        DB[(Supabase / PostgreSQL Cloud Engine)]
    end

    App <-->|REST Requests & Chat Stream| API
    API <-->|Query Destination Vectors & Schema| DB
```

---

## ✈️ Intelligent Itinerary Generation Workflow

```mermaid
sequenceDiagram
    autonumber
    actor Traveler as Traveler
    participant App as WanderAI Mobile App
    participant Backend as FastAPI AI Service
    participant NLP as NLP Recommendation Engine
    participant DB as Supabase PostgreSQL

    Traveler->>App: Enter Travel Query ("5-day scenic road trip with hiking and lo-fi cafes")
    App->>Backend: Forward Intent, Budget & Travel Dates
    Backend->>NLP: Parse Semantic Constraints (Keywords, Pace, Interests)
    NLP->>DB: Query Curated Geocoded POIs & Verified Stays
    DB-->>Backend: Return Candidate Coordinates & Operating Hours
    Backend->>Backend: Run Route Optimization & Time Allocation Algorithm
    Backend-->>App: Stream Day-by-Day Interactive Itinerary
    Traveler->>App: Customize Stops & Save Trip to Profile
```

---

## ✨ Core Features

### 🤖 1. Natural Language Travel AI
- **Conversational Concierge:** Ask questions like *"What are 3 quiet sunset viewpoints along my drive?"* or *"Plan a weekend getaway under $500."*
- **Contextual Personalization:** Adapts suggestions based on user travel style (Solo Backpacker, Family, Luxury, Adventurer).

### 🗺️ 2. Dynamic Routing & Attraction Discovery
- **Multi-Stop Route Optimizer:** Automatically sequences waypoints to minimize travel fatigue and backtracking.
- **En-Route Discovery:** Highlights hidden gems, scenic lookouts, and historic landmarks directly along the active route.

### 💼 3. Comprehensive Trip Management
- **Interactive Day Cards:** Time-budgeted schedules with travel duration estimates between each activity.
- **Saved Collections:** Bookmark dream destinations and create customized bucket lists.
- **Offline Readiness:** Cached trip itineraries accessible even when venturing off the grid.

---

## 📁 Repository Structure

```
WanderAI-Assistant/
├── assets/
│   └── branding/
│       └── logo.jpg               # Official brand asset
├── backend/                       # Python FastAPI Backend
│   ├── main.py                    # API entry point & route definitions
│   ├── nlp_service.py             # Natural language intent & recommendation processor
│   ├── poi_service.py             # Point of interest clustering & ranking
│   ├── routing_service.py         # Multi-stop travel routing logic
│   ├── database.py                # Supabase PostgreSQL client integration
│   ├── schema.sql                 # Database relational schema
│   └── requirements.txt
├── lib/                           # Flutter Cross-Platform Client
│   ├── main.dart                  # Application bootstrap
│   ├── core/                      # API service, routing, auth, and theme tokens
│   ├── screens/                   # Itinerary cards, AI chat, explore, and booking views
│   └── widgets/                   # Chat bubbles, route cards, destination components
├── test/                          # Unit and widget test suite
└── README.md
```

---

## 🚀 Getting Started

### 1. Backend AI Service Setup
```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Configure environment variables
cp .env.example .env

# Run FastAPI development server
uvicorn main:app --reload --port 8000
```

### 2. Flutter Mobile Application
```bash
# In the root directory
flutter pub get

# Launch on connected mobile device or simulator
flutter run
```

---

## 🔒 Confidentiality & White-Label Notice
This repository is an open-source demonstration and portfolio showcase. All proprietary client data, commercial vendor contracts, live API tokens, and client credentials have been sanitized and decoupled.

---

## 👨‍💻 Author
**Muhammad Ali**
- GitHub: [@itismemuhammadali](https://github.com/itismemuhammadali)
- Portfolio & Engineering Showcase
