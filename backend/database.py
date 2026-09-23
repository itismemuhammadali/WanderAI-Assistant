import os
import uuid
from datetime import datetime, date
from typing import List, Dict, Any, Optional
from dotenv import load_dotenv

load_dotenv()

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
                "image_url": "https://images.unsplash.com/photo-1514558427911-8e293bebf18c?q=80&w=1080&auto=format&fit=crop",
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
                "image_url": "https://images.unsplash.com/photo-1679951124125-50cc4029d727?q=80&w=1080&auto=format&fit=crop",
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
                "image_url": "https://images.unsplash.com/photo-1668936782695-5f7657dc793d?q=80&w=1080&auto=format&fit=crop",
                "description": "The Switzerland of the East with river-side stays in Bahrain and chairlift adventure at Malam Jabba.",
                "included_amenities": ["AC Transport", "Hotel Stay", "Chairlift Pass", "Guided Tour"],
                "is_featured": True
            },
            {
                "id": "pkg-fairy-04",
                "title": "Fairy Meadows & Nanga Parbat Base Camp Trek",
                "destination": "Fairy Meadows",
                "region": "north",
                "duration_days": 5,
                "base_price": 40000.0,
                "rating": 4.9,
                "image_url": "https://images.unsplash.com/photo-1664872763520-348c1cbbade4?q=80&w=1080&auto=format&fit=crop",
                "description": "Hike to the legendary plateau of Fairy Meadows directly beneath the massive north face of Nanga Parbat.",
                "included_amenities": ["4x4 Jeep Ride", "Camping/Cottage", "Trekking Guide", "Bonfire Dinners"],
                "is_featured": True
            },
            {
                "id": "pkg-naran-05",
                "title": "Naran Kaghan & Saif ul Malook Alpine Escape",
                "destination": "Naran",
                "region": "north",
                "duration_days": 3,
                "base_price": 28000.0,
                "rating": 4.8,
                "image_url": "https://images.unsplash.com/photo-1668061867899-02b4cfa34747?q=80&w=1080&auto=format&fit=crop",
                "description": "Witness the turquoise waters of Lake Saiful Malook, Kunhar River trout fishing, and Babusar Top vistas.",
                "included_amenities": ["Deluxe Coaster", "Standard Hotel", "Jeep Safari", "Daily Breakfast"],
                "is_featured": True
            },
            {
                "id": "pkg-kumrat-06",
                "title": "Kumrat Valley & Jahaz Banda Waterfall Trek",
                "destination": "Kumrat Valley",
                "region": "north",
                "duration_days": 4,
                "base_price": 34000.0,
                "rating": 4.8,
                "image_url": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=1080&auto=format&fit=crop",
                "description": "Dense pine forests, rushing Panjkora River, wooden bridges, and Jahaz Banda high alpine meadows.",
                "included_amenities": ["Mountain Jeep", "Riverside Camping", "Campfire", "All Meals"],
                "is_featured": False
            },
            {
                "id": "pkg-neelum-07",
                "title": "Neelum Valley & Arang Kel Kashmir Haven",
                "destination": "Neelum Valley",
                "region": "north",
                "duration_days": 5,
                "base_price": 38000.0,
                "rating": 4.9,
                "image_url": "https://images.unsplash.com/photo-1581895690858-a5ea6c4d7e00?q=80&w=1080&auto=format&fit=crop",
                "description": "The pearl of Azad Kashmir with stops at Kutton Waterfall, Sharda Peeth ruins, and Arang Kel cable car.",
                "included_amenities": ["AC Saloon Transport", "Kashmir River Resort", "Local Guide", "Breakfast & Dinner"],
                "is_featured": True
            },
            {
                "id": "pkg-ratti-08",
                "title": "Ratti Gali Glacial Lake Alpine Expedition",
                "destination": "Ratti Gali",
                "region": "north",
                "duration_days": 4,
                "base_price": 32000.0,
                "rating": 4.8,
                "image_url": "https://images.unsplash.com/photo-1595166249673-c62d0943eb14?q=80&w=1080&auto=format&fit=crop",
                "description": "Ascend from Dowarian via mountain jeeps to the red alpine wildflower encircled glacial lake.",
                "included_amenities": ["4x4 Jeep Trek", "Alpine Dome Tents", "Trek Leader", "Traditional Meals"],
                "is_featured": False
            },
            {
                "id": "pkg-shogran-09",
                "title": "Shogran & Siri Paye Cloud Meadows",
                "destination": "Shogran",
                "region": "north",
                "duration_days": 3,
                "base_price": 26000.0,
                "rating": 4.7,
                "image_url": "https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=1080&auto=format&fit=crop",
                "description": "Horse ride across the misty pine meadows of Siri Paye elevated 3,000 meters above Kaghan Valley.",
                "included_amenities": ["AC Transport", "Shogran Pine Hotel", "Horse Riding Pass", "Daily Meals"],
                "is_featured": False
            },
            {
                "id": "pkg-kalash-10",
                "title": "Kalash Chilam Joshi & Chitral Heritage Tour",
                "destination": "Chitral",
                "region": "north",
                "duration_days": 5,
                "base_price": 42000.0,
                "rating": 4.9,
                "image_url": "https://images.unsplash.com/photo-1596761224566-32454a8549e3?q=80&w=1080&auto=format&fit=crop",
                "description": "Participate in ancient cultural traditions, folk dances, and vibrant costumes of the Kalash people.",
                "included_amenities": ["Lowari Tunnel Transport", "Traditional Guest House", "Festival Pass", "Cultural Guide"],
                "is_featured": True
            },
            {
                "id": "pkg-deosai-11",
                "title": "Deosai Plains Land of Giants Wildlife Safari",
                "destination": "Deosai",
                "region": "north",
                "duration_days": 5,
                "base_price": 48000.0,
                "rating": 4.9,
                "image_url": "https://images.unsplash.com/photo-1631558288597-28d8ed273fec?q=80&w=1080&auto=format&fit=crop",
                "description": "Journey through the world second highest alpine plateau, home to Himalayan brown bears and Sheosar Lake.",
                "included_amenities": ["Rugged 4x4 Prado", "Glamping Tents", "Wildlife Ranger Guide", "All Meals"],
                "is_featured": True
            },
            {
                "id": "pkg-khunjerab-12",
                "title": "Khunjerab Pass High Altitude Silk Route Expedition",
                "destination": "Khunjerab",
                "region": "north",
                "duration_days": 6,
                "base_price": 52000.0,
                "rating": 4.9,
                "image_url": "https://images.unsplash.com/photo-1601633596700-0834ba128564?q=80&w=1080&auto=format&fit=crop",
                "description": "Drive along the highest paved international border crossing at 4,693 meters and see Himalayan ibex.",
                "included_amenities": ["Luxury Coaster", "Karimabad Boutique Hotel", "National Park Entry", "Full Board Meals"],
                "is_featured": True
            },
            {
                "id": "pkg-mushkpuri-13",
                "title": "Nathia Gali & Mushkpuri Peak Nature Trail",
                "destination": "Galiyat",
                "region": "central",
                "duration_days": 2,
                "base_price": 18000.0,
                "rating": 4.6,
                "image_url": "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?q=80&w=1080&auto=format&fit=crop",
                "description": "Trek through moist temperate pine forests to the scenic meadow summit of Mushkpuri.",
                "included_amenities": ["Dedicated Van", "Galiyat Lodge Stay", "Trek Guide", "Barbecue Dinner"],
                "is_featured": False
            },
            {
                "id": "pkg-lahore-14",
                "title": "Lahore Walled City & Mughal Heritage Culinary Trail",
                "destination": "Lahore",
                "region": "central",
                "duration_days": 3,
                "base_price": 22000.0,
                "rating": 4.7,
                "image_url": "https://images.unsplash.com/photo-1622546758596-f1f06ba11f58?q=80&w=1080&auto=format&fit=crop",
                "description": "Step back in time at Badshahi Mosque, Lahore Fort, Wazir Khan Mosque, and feast at Fort Road Food Street.",
                "included_amenities": ["City Tour AC Van", "Heritage Hotel Stay", "Monuments Pass", "Traditional Desi Feasts"],
                "is_featured": True
            },
            {
                "id": "pkg-islamabad-15",
                "title": "Islamabad Hills, Faisal Mosque & Monal Sunset Retreat",
                "destination": "Islamabad",
                "region": "central",
                "duration_days": 2,
                "base_price": 16000.0,
                "rating": 4.8,
                "image_url": "https://images.unsplash.com/photo-1608020932658-d0e19a69580b?q=80&w=1080&auto=format&fit=crop",
                "description": "Visit the architectural marvel Faisal Mosque, hike Margalla Trail 3, and enjoy sunset dinner at Monal.",
                "included_amenities": ["Executive Car", "Islamabad Guesthouse", "Trail Guide", "Monal Dinner Voucher"],
                "is_featured": False
            },
            {
                "id": "pkg-taxila-16",
                "title": "Taxila Gandhara Civilization & Ancient Stupas",
                "destination": "Taxila",
                "region": "central",
                "duration_days": 2,
                "base_price": 15000.0,
                "rating": 4.6,
                "image_url": "https://images.unsplash.com/photo-1599818818817-2384f50bb00d?q=80&w=1080&auto=format&fit=crop",
                "description": "Walk through UNESCO World Heritage ruins of Jaulian monastery, Dharmarajika stupa, and Taxila museum.",
                "included_amenities": ["Private AC Car", "Museum Passes", "Historian Guide", "Buffet Lunch"],
                "is_featured": False
            },
            {
                "id": "pkg-rohtas-17",
                "title": "Rohtas Fort & Khewra Salt Mines Wonder Tour",
                "destination": "Jhelum",
                "region": "central",
                "duration_days": 2,
                "base_price": 19000.0,
                "rating": 4.7,
                "image_url": "https://images.unsplash.com/photo-1585255318859-f5c15f4cffa9?q=80&w=1080&auto=format&fit=crop",
                "description": "Sher Shah Suri massive 16th century fortress and electric train deep inside the Khewra Salt Mine.",
                "included_amenities": ["Highway Transport", "Hotel Stay", "Mine Train Ticket", "All Meals"],
                "is_featured": False
            },
            {
                "id": "pkg-cholistan-18",
                "title": "Cholistan Desert Safari & Derawar Fort Night Camp",
                "destination": "Bahawalpur",
                "region": "south",
                "duration_days": 4,
                "base_price": 36000.0,
                "rating": 4.8,
                "image_url": "https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?q=80&w=1080&auto=format&fit=crop",
                "description": "Witness forty towering bastions of Derawar Fort and camel safaris under a starry desert sky.",
                "included_amenities": ["4x4 Desert Jeep", "Luxury Desert Tents", "Camel Safari", "Traditional Sajji Dinner"],
                "is_featured": True
            },
            {
                "id": "pkg-kundmalir-19",
                "title": "Kund Malir Golden Beach & Hingol Rock Formations",
                "destination": "Makran",
                "region": "south",
                "duration_days": 2,
                "base_price": 24000.0,
                "rating": 4.8,
                "image_url": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1080&auto=format&fit=crop",
                "description": "Cruise along Makran Coastal Highway to view the Princess of Hope, Sphinx, and Arabian Sea beaches.",
                "included_amenities": ["AC Highway Coaster", "Beachside Camps", "Bonfire & Stargazing", "Seafood Barbecue"],
                "is_featured": True
            },
            {
                "id": "pkg-churna-20",
                "title": "Churna Island Coral Reef & Deep Sea Snorkeling",
                "destination": "Karachi",
                "region": "south",
                "duration_days": 2,
                "base_price": 18000.0,
                "rating": 4.7,
                "image_url": "https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=1080&auto=format&fit=crop",
                "description": "Speedboat ride to Churna Island for cliff diving, snorkeling among coral reefs, and spotting sea turtles.",
                "included_amenities": ["Speedboat Transfer", "Snorkeling Gear", "Underwater Photography", "Buffet Lunch"],
                "is_featured": False
            },
            {
                "id": "pkg-gorakh-21",
                "title": "Gorakh Hill Station Murree of Sindh Star Gazing",
                "destination": "Gorakh Hill",
                "region": "south",
                "duration_days": 3,
                "base_price": 25000.0,
                "rating": 4.6,
                "image_url": "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1080&auto=format&fit=crop",
                "description": "Escape to the 5,688 feet summit of Kirthar Mountains with zero light pollution and freezing mountain breezes.",
                "included_amenities": ["4x4 Mountain Jeep", "Hill Resort Rooms", "Campfire", "Traditional Balochi Meals"],
                "is_featured": False
            },
            {
                "id": "pkg-ziarat-22",
                "title": "Ziarat Ancient Juniper Forest & Quaid Residency",
                "destination": "Ziarat",
                "region": "south",
                "duration_days": 3,
                "base_price": 28000.0,
                "rating": 4.7,
                "image_url": "https://images.unsplash.com/photo-1448375240586-882707db888b?q=80&w=1080&auto=format&fit=crop",
                "description": "Wander through one of the oldest Juniper forests on Earth and visit the historic Quaid Residency.",
                "included_amenities": ["Balochistan Mountain Van", "Ziarat Pine Cottages", "Forest Permit", "All Meals"],
                "is_featured": False
            },
            {
                "id": "pkg-astola-23",
                "title": "Astola Island Seven Hills Deep Sea Expedition",
                "destination": "Pasni",
                "region": "south",
                "duration_days": 4,
                "base_price": 58000.0,
                "rating": 4.9,
                "image_url": "https://images.unsplash.com/photo-1518837695005-2083093ee35b?q=80&w=1080&auto=format&fit=crop",
                "description": "Boat expedition to Pakistan largest uninhabited island featuring crystal turquoise waters and sea caves.",
                "included_amenities": ["Private Pasni Trawler", "Island Expedition Camps", "Snorkel & Fishing", "Fresh Catch Dinners"],
                "is_featured": True
            },
            {
                "id": "pkg-attabad-24",
                "title": "Attabad Lake Water Sports & Hussaini Bridge Thrill",
                "destination": "Gojal",
                "region": "north",
                "duration_days": 4,
                "base_price": 39000.0,
                "rating": 4.9,
                "image_url": "https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=1080&auto=format&fit=crop",
                "description": "Jet ski across turquoise alpine waters and cross the daring suspension bridges of upper Hunza.",
                "included_amenities": ["4x4 Transport", "Lakefront Hotel", "Boating Pass", "All Meals"],
                "is_featured": True
            },
            {
                "id": "pkg-kalam-25",
                "title": "Kalam Ushu Forest & Mahodand Lake Jeep Trek",
                "destination": "Kalam",
                "region": "north",
                "duration_days": 4,
                "base_price": 33000.0,
                "rating": 4.8,
                "image_url": "https://images.unsplash.com/photo-1668936782695-5f7657dc793d?q=80&w=1080&auto=format&fit=crop",
                "description": "Traverse the wild Ushu pine forest and trout streams to reach the glacial jewel Mahodand Lake.",
                "included_amenities": ["Mountain Jeep Ride", "Kalam Riverside Hotel", "Lake Boating", "Full Board Meals"],
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
        # Validate or default UUIDs for Supabase Postgres schema
        raw_user_id = booking_data.get("user_id")
        user_uuid = None
        if raw_user_id:
            try:
                user_uuid = str(uuid.UUID(str(raw_user_id)))
            except (ValueError, TypeError):
                user_uuid = "a0000000-0000-0000-0000-000000000001"
        else:
            user_uuid = "a0000000-0000-0000-0000-000000000001"

        raw_pkg_id = booking_data.get("package_id")
        pkg_uuid = None
        if raw_pkg_id:
            try:
                pkg_uuid = str(uuid.UUID(str(raw_pkg_id)))
            except (ValueError, TypeError):
                pkg_uuid = None

        booking_record = {
            "id": str(uuid.uuid4()),
            "user_id": user_uuid,
            "package_id": pkg_uuid,
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
