# DermaLens

DermaLens is a comprehensive healthcare platform designed for skin disease detection and management. It leverages deep learning for image-based classification and integrated AI chat for clinical support. The project is structured with a high-performance Python backend and a cross-platform Flutter frontend.

## Key Features

### Dermatological Analysis
- **Image-Based Prediction**: Utilizes a PyTorch-based convolutional neural network to identify various skin conditions from uploaded or captured images.
- **Probability Assessment**: Provides confidence scores for predicted conditions to aid clinical decision-making.
- **Scan History**: maintains a persistent repository of user scans for tracking condition progression over time.

### AI Clinical Support
- **RAG-Powered Chat**: Features a Retrieval-Augmented Generation (RAG) chatbot integrated with LangChain and Groq LLMs for providing context-aware dermatological information.
- **Medical Recommendations**: Generates automated suggestions based on scan results and diagnostic criteria.

### User Management and Security
- **Authentication**: Secure user registration and login powered by Supabase.
- **Profile Management**: Personalized user profiles including diagnostic history and health metrics.
- **Data Persistence**: Robust state management and data synchronization between the mobile client and cloud database.

### Reporting and Accessibility
- **PDF Report Generation**: Ability to generate and export professional clinical reports for scan results.
- **Multi-Platform UI**: A premium, responsive mobile interface built with Flutter, optimized for both iOS and Android.

### Performance Optimization
- **Redis Caching**: Implements a high-performance caching layer using Redis to store frequently accessed data.
- **Recommendation Caching**: Caches dermatological recommendations to reduce LLM latency and API costs.
- **Profile Caching**: Utilizes short-lived cache entries for user profile data to ensure rapid UI transitions and reduced database load.
- **Session Management**: Optimized data retrieval patterns to maintain high availability and responsiveness.

## Technology Stack

### Backend
- **Framework**: FastAPI (Python)
- **Machine Learning**: PyTorch, Torchvision, Pillow
- **AI/LLM**: LangChain, Groq, Sentence-Transformers
- **Database**: Supabase (PostgreSQL)
- **Caching**: Redis
- **Containerization**: Docker, Docker Compose

### Frontend
- **Framework**: Flutter (Dart)
- **Architecture**: Clean Architecture with MVVM Pattern
- **State Management**: Provider
- **Animations**: Lottie
- **Networking**: Http

## Project Structure

```text
DermaLens/
├── dermalens_backend/         # FastAPI Application
│   ├── app/
│   │   ├── core/              # Configuration and security
│   │   ├── database/          # Database connection logic
│   │   ├── models/            # SQLAlchemy/Pydantic models
│   │   ├── routes/            # API endpoints
│   │   ├── services/          # Business logic (Prediction, Chat, RAG)
│   │   └── schemas/           # Data validation schemas
│   ├── docker/                # Environment-specific Docker configurations
│   └── main.py                # Application entry point
├── dermalens_frontend/        # Flutter Application
│   ├── lib/
│   │   ├── core/              # Shared utilities and themes
│   │   ├── data/              # Repositories and data sources
│   │   ├── domain/            # Entities and use cases
│   │   ├── presentation/      # UI components and ViewModels
│   │   └── main.dart          # App entry point
└── docker-compose.yml         # Multi-container orchestration
```

## Getting Started

### Prerequisites
- Python 3.11+
- Flutter SDK
- Docker and Docker Compose
- Supabase Account and API Keys

### Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd dermalens_backend
   ```
2. Create a `.env` file and populate it with required environment variables (Supabase URL, Key, Groq API Key).
3. Build and run the services using Docker Compose:
   ```bash
   docker-compose up --build
   ```

### Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd dermalens_frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## License
This project is proprietary. All rights reserved.
