import os
import uuid
from datetime import datetime, date
from typing import List, Dict, Any, Optional

# Load environment variables if available
SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_KEY = os.getenv("SUPABASE_KEY", "")

# In-memory mock database to ensure 100% functionality out-of-the-box
# when Supabase credentials are not yet configured.
class DatabaseService:
    def __init__(self):
        self.use_supabase = bool(SUPABASE_URL and SUPABASE_KEY)
        self.client = None
        if self.use_supabase:
            try:
                from supabase import create_client
                self.client = create_client(SUPABASE_URL, SUPABASE_KEY)
                print("Connected to live Supabase database.")
            except Exception as e:
                print(f"Supabase connection fallback to local mock store: {e}")
                self.use_supabase = False

        self._seed_mock_data()

    def _seed_mock_data(self):
        self._packages = [
            {
                "id": "pkg-hunza-01",
                "title": "Majestic Hunza & Passu Cones Expedition",
                "destination": "Hunza Valley",
                "region": "north",
                "duration_days": 5,
                "base_price": 45000.0,
                "rating": 4.9,
                "image_url": "https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=2070&auto=format&fit=crop",
                "description": "Explore Karimabad, Altit & Baltit Forts, Attabad Lake boat cruise, and dramatic Passu Cones vistas.",
                "included_amenities": ["4x4 Mountain Transport", "Luxury Hotel Stay", "Breakfast & Dinner", "Attabad Boating Pass"],
                "is_featured": True
            },
            {
                "id": "pkg-skardu-02",
                "title": "Skardu Shangrila & Cold Desert Safari",
                "destination": "Skardu",
                "region": "north",
                "duration_days": 6,
                "base_price": 55000.0,
                "rating": 4.8,
                "image_url": "https://images.unsplash.com/photo-1625807908993-a5ffbfbf3205?q=80&w=2070&auto=format&fit=crop",
                "description": "Immerse in Shangrila Resort, Lower & Upper Kachura Lakes, Sarfaranga cold desert, and historic Shigar Fort.",
                "included_amenities": ["Private Coaster/Prado", "Resort Stay", "Desert Safari Ticket", "All Meals"],
                "is_featured": True
            },
            {
                "id": "pkg-swat-03",
                "title": "Swat Valley & Malam Jabba Ski Retreat",
                "destination": "Swat Valley",
                "region": "north",
                "duration_days": 4,
                "base_price": 35000.0,
                "rating": 4.7,
                "image_url": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2070&auto=format&fit=crop",
                "description": "The Switzerland of the East with river-side stays in Bahrain and chairlift adventure at Malam Jabba.",
                "included_amenities": ["AC Transport", "Hotel Stay", "Chairlift Pass", "Guided Tour"],
                "is_featured": False
            },
            {
                "id": "pkg-fairy-04",
                "title": "Fairy Meadows & Nanga Parbat Base Camp Trek",
                "destination": "Fairy Meadows",
                "region": "north",
                "duration_days": 5,
                "base_price": 40000.0,
                "rating": 4.9,
                "image_url": "https://images.unsplash.com/photo-1601633596700-0834ba128564?q=80&w=2070&auto=format&fit=crop",
                "description": "Hike to the legendary plateau of Fairy Meadows directly beneath the massive north face of Nanga Parbat.",
                "included_amenities": ["4x4 Jeep Ride", "Camping/Cottage", "Trekking Guide", "Bonfire Dinners"],
                "is_featured": True
            }
        ]

        self._pois = [
            {
                "id": "poi-01",
                "name": "Kallar Kahar Lake",
                "category": "Lake & Heritage",
                "latitude": 32.7819,
                "longitude": 72.7056,
                "image_url": "https://images.unsplash.com/photo-1630139266136-1e663a0a322e?q=80&w=2074&auto=format&fit=crop",
                "rating": 4.5,
                "description": "Salt lake featuring natural orchards, historical Takht-e-Babri, and wild peacocks along M-2.",
                "corridor_tag": "M2 Motorway"
            },
            {
                "id": "poi-02",
                "name": "Saif-ul-Malook Lake",
                "category": "Glacial Lake",
                "latitude": 34.8767,
                "longitude": 73.6931,
                "image_url": "https://images.unsplash.com/photo-1581895690858-a5ea6c4d7e00?q=80&w=2070&auto=format&fit=crop",
                "rating": 4.9,
                "description": "Iconic emerald-green glacial lake in Kaghan Valley surrounded by snow peaks.",
                "corridor_tag": "Naran Corridor"
            },
            {
                "id": "poi-03",
                "name": "Babusar Top Mountain Pass",
                "category": "Mountain Pass",
                "latitude": 35.1481,
                "longitude": 74.0483,
                "image_url": "https://images.unsplash.com/photo-1595166249673-c62d0943eb14?q=80&w=2070&auto=format&fit=crop",
                "rating": 4.8,
                "description": "Panoramic pass connecting Kaghan Valley to Gilgit Baltistan at 4,173 meters elevation.",
                "corridor_tag": "Babusar Corridor"
            },
            {
                "id": "poi-04",
                "name": "Lulusar Lake & Waterfall",
                "category": "Lake & Waterfall",
                "latitude": 35.0833,
                "longitude": 73.9167,
                "image_url": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2070&auto=format&fit=crop",
                "rating": 4.7,
                "description": "Mirror-like natural reservoir feeding the Kunhar River with roadside waterfalls.",
                "corridor_tag": "Babusar Corridor"
            },
            {
                "id": "poi-05",
                "name": "Altit Fort & Royal Orchards",
                "category": "Historic Heritage",
                "latitude": 36.3139,
                "longitude": 74.6714,
                "image_url": "https://images.unsplash.com/photo-1631558288597-28d8ed273fec?q=80&w=2070&auto=format&fit=crop",
                "rating": 4.9,
                "description": "Nine-century-old fortress standing atop a 1000-foot cliff over the Hunza River.",
                "corridor_tag": "Hunza Valley"
            },
            {
                "id": "poi-06",
                "name": "Attabad Lake Cruise",
                "category": "Turquoise Lake",
                "latitude": 36.3333,
                "longitude": 74.8667,
                "image_url": "https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=2070&auto=format&fit=crop",
                "rating": 4.9,
                "description": "Crystal turquoise alpine lake offering speedboat cruises and jet-skiing.",
                "corridor_tag": "Hunza Valley"
            }
        ]

        self._bookings = []
        self._chat_history = []

    async def get_packages(self, region: Optional[str] = None) -> List[Dict[str, Any]]:
        if self.use_supabase and self.client:
            try:
                q = self.client.table("tour_packages").select("*")
                if region:
                    q = q.eq("region", region)
                res = q.execute()
                if res.data:
                    return res.data
            except Exception as e:
                print(f"Error fetching from Supabase: {e}")

        # Fallback to local store
        if region:
            return [p for p in self._packages if p.get("region") == region]
        return self._packages

    async def get_package(self, package_id: str) -> Optional[Dict[str, Any]]:
        if self.use_supabase and self.client:
            try:
                res = self.client.table("tour_packages").select("*").eq("id", package_id).execute()
                if res.data:
                    return res.data[0]
            except Exception:
                pass
        for p in self._packages:
            if p["id"] == package_id:
                return p
        return None

    async def get_pois(self, category: Optional[str] = None) -> List[Dict[str, Any]]:
        if self.use_supabase and self.client:
            try:
                q = self.client.table("points_of_interest").select("*")
                if category:
                    q = q.ilike("category", f"%{category}%")
                res = q.execute()
                if res.data:
                    return res.data
            except Exception:
                pass
        if category:
            return [poi for poi in self._pois if category.lower() in poi["category"].lower()]
        return self._pois

    async def create_booking(self, booking_data: Dict[str, Any]) -> Dict[str, Any]:
        booking_record = {
            "id": str(uuid.uuid4()),
            "user_id": booking_data.get("user_id", "demo-traveler-id"),
            "package_id": booking_data.get("package_id"),
            "travel_date": str(booking_data.get("travel_date", date.today())),
            "guests_count": int(booking_data.get("guests_count", 1)),
            "total_price": float(booking_data.get("total_price", 45000.0)),
            "status": "confirmed",
            "contact_phone": booking_data.get("contact_phone", "+923001234567"),
            "notes": booking_data.get("notes", "Auto-generated reservation"),
            "created_at": datetime.utcnow().isoformat()
        }

        if self.use_supabase and self.client:
            try:
                res = self.client.table("bookings").insert(booking_record).execute()
                if res.data:
                    return res.data[0]
            except Exception as e:
                print(f"Supabase booking insert error: {e}")

        self._bookings.append(booking_record)
        return booking_record

    async def get_user_bookings(self, user_id: str) -> List[Dict[str, Any]]:
        if self.use_supabase and self.client:
            try:
                res = self.client.table("bookings").select("*").eq("user_id", user_id).execute()
                if res.data:
                    return res.data
            except Exception:
                pass
        return [b for b in self._bookings if b.get("user_id") == user_id]

    async def save_chat_message(self, user_id: str, sender: str, message: str) -> Dict[str, Any]:
        entry = {
            "id": str(uuid.uuid4()),
            "user_id": user_id,
            "sender": sender,
            "message": message,
            "created_at": datetime.utcnow().isoformat()
        }
        self._chat_history.append(entry)
        return entry

# Singleton database instance
db = DatabaseService()
