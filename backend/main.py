import os
from datetime import datetime
from typing import Optional, List, Dict, Any
from fastapi import FastAPI, HTTPException, Query, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

from database import db
from nlp_service import nlp_service
from routing_service import routing_service
from poi_service import poi_service

app = FastAPI(
    title="AI-Based Travel Assistant API",
    description="Backend microservices for natural language travel planning, dual routing, and corridor POI discovery across Pakistan.",
    version="1.0.0"
)

# Enable CORS for Flutter mobile application
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ====================================================================
# PYDANTIC REQUEST / RESPONSE SCHEMAS
# ====================================================================

class QueryRequest(BaseModel):
    query: str = Field(..., example="Plan a 5 day scenic trip to Hunza Valley from Islamabad")

class RouteRequest(BaseModel):
    origin: str = Field(default="Islamabad", example="Islamabad")
    destination: str = Field(default="Hunza Valley", example="Hunza Valley")

class BookingCreateRequest(BaseModel):
    user_id: Optional[str] = "traveler_ali"
    package_id: str
    travel_date: str = Field(..., example="2026-10-15")
    guests_count: int = Field(default=2, ge=1)
    total_price: float = Field(..., ge=0)
    contact_phone: Optional[str] = "+923001234567"
    notes: Optional[str] = "Special request for window view room"

class ChatRequest(BaseModel):
    user_id: Optional[str] = "traveler_ali"
    message: str = Field(..., example="What is the best time to visit Hunza Valley and what should I pack?")

# ====================================================================
# API ENDPOINTS
# ====================================================================

@app.get("/")
async def root():
    return {
        "status": "online",
        "service": "AI-Based Travel Assistant Backend API",
        "version": "1.0.0",
        "timestamp": datetime.utcnow().isoformat(),
        "database": "Supabase PostgreSQL (Active / Fallback Ready)",
        "endpoints": [
            "/api/nlp/parse",
            "/api/routes/calculate",
            "/api/pois/corridor",
            "/api/packages",
            "/api/bookings",
            "/api/chat"
        ]
    }

@app.post("/api/nlp/parse")
async def parse_travel_query(req: QueryRequest):
    """
    Parses natural language travel inquiries using the SpaCy NLP pipeline.
    """
    if not req.query.strip():
        raise HTTPException(status_code=400, detail="Query text cannot be empty.")
    
    parsed = nlp_service.parse_query(req.query)
    return {
        "success": True,
        "data": parsed
    }

@app.post("/api/routes/calculate")
async def calculate_routes(req: RouteRequest):
    """
    Generates dual routes: Fastest Direct Path vs Scenic Mountain Corridor.
    """
    result = await routing_service.calculate_dual_routes(req.origin, req.destination)
    return {
        "success": True,
        "data": result
    }

@app.get("/api/pois/corridor")
async def get_corridor_attractions(
    route_type: str = Query("scenic", description="fastest or scenic"),
    category: Optional[str] = Query(None, description="lake, waterfall, pass, fort, or all")
):
    """
    Fetches categorized tourist attractions (waterfalls, lakes, mountain passes, forts) along the route corridor.
    """
    attractions = await poi_service.get_corridor_attractions(route_type, category)
    return {
        "success": True,
        "count": len(attractions),
        "data": attractions
    }

@app.get("/api/packages")
async def list_packages(region: Optional[str] = Query(None, description="north, central, south")):
    """
    Retrieves curated multi-day tour packages.
    """
    packages = await db.get_packages(region)
    return {
        "success": True,
        "count": len(packages),
        "data": packages
    }

@app.get("/api/packages/{package_id}")
async def get_package_detail(package_id: str):
    """
    Retrieves a single package's complete itinerary, pricing, and inclusions.
    """
    pkg = await db.get_package(package_id)
    if not pkg:
        raise HTTPException(status_code=404, detail="Tour package not found.")
    return {
        "success": True,
        "data": pkg
    }

@app.post("/api/bookings", status_code=status.HTTP_201_CREATED)
async def create_tour_booking(req: BookingCreateRequest):
    """
    Persists a tour booking reservation into Supabase PostgreSQL.
    """
    booking = await db.create_booking(req.model_dump())
    return {
        "success": True,
        "message": "Tour booking successfully confirmed!",
        "data": booking
    }

@app.get("/api/bookings")
async def list_user_bookings(user_id: str = Query("traveler_ali")):
    """
    Lists all bookings for a user.
    """
    bookings = await db.get_user_bookings(user_id)
    return {
        "success": True,
        "count": len(bookings),
        "data": bookings
    }

@app.post("/api/chat")
async def conversational_assistant(req: ChatRequest):
    """
    Conversational AI travel assistant providing guidance on weather, clothing, and routes.
    """
    user_msg = req.message.lower().strip()
    reply = ""

    if any(w in user_msg for w in ["hunza", "passu", "attabad"]):
        reply = "Hunza Valley is spectacular! The best time to visit is from April through October. Key attractions include the 900-year-old Altit Fort, turquoise Attabad Lake for boat rides, and the majestic Passu Cones. Would you like me to add these scenic stops to your route?"
    elif any(w in user_msg for w in ["skardu", "shangrila", "deosa"]):
        reply = "Skardu offers a magical blend of cold deserts and alpine lakes. You shouldn't miss Shangrila Resort, Lower Kachura Lake, and a desert safari across Sarfaranga. Make sure to pack warm layers even in summer!"
    elif any(w in user_msg for w in ["pack", "clothing", "wear", "weather"]):
        reply = "For Northern Pakistan, always pack in layers: a windproof jacket, sturdy hiking boots, warm fleece, sunglasses, and a power bank. Evenings in high passes like Babusar can drop near freezing."
    elif any(w in user_msg for w in ["budget", "cost", "price", "expensive"]):
        reply = "A 5-day road trip for two people to Northern Pakistan typically ranges between PKR 65,000 to PKR 95,000 including private fuel, quality hotel stays, and entry passes. We have curated all-inclusive packages starting from PKR 35,000!"
    elif any(w in user_msg for w in ["route", "fastest", "scenic", "babusar"]):
        reply = "We offer two dynamic routing strategies: the Fastest KKH Direct route (11h 30m via Besham) and the Scenic Mountain Corridor (14h 45m via Naran and Babusar Pass with 5 panoramic stops). You can toggle between them directly on the Map screen!"
    else:
        reply = f"I would love to help you plan your journey! You can ask me about top destinations across Pakistan (Hunza, Skardu, Swat, Naran), compare fastest vs scenic routes, or customize daily tour stops."

    # Save to history
    await db.save_chat_message(req.user_id, "user", req.message)
    await db.save_chat_message(req.user_id, "assistant", reply)

    return {
        "success": True,
        "reply": reply,
        "timestamp": datetime.utcnow().isoformat()
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
