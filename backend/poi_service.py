import httpx
from typing import List, Dict, Any, Optional

OVERPASS_API_URL = "https://overpass-api.de/api/interpreter"

class POIService:
    def __init__(self):
        # Comprehensive curated corridor points of interest
        self.cached_corridor_pois = [
            {
                "id": "poi_01",
                "name": "Kallar Kahar Lake",
                "category": "Lake & Wetland",
                "type": "lake",
                "latitude": 32.7819,
                "longitude": 72.7056,
                "rating": 4.5,
                "description": "Scenic salt lake in Chakwal featuring natural peacock sanctuary and historical Mughal Takht-e-Babri.",
                "image_url": "https://images.unsplash.com/photo-1630139266136-1e663a0a322e?q=80&w=2074&auto=format&fit=crop",
                "distance_from_isb_km": 125,
                "corridor": "M2 Motorway"
            },
            {
                "id": "poi_02",
                "name": "Kunhar River Cascade Waterfall",
                "category": "Waterfall",
                "type": "waterfall",
                "latitude": 34.6292,
                "longitude": 73.4739,
                "rating": 4.7,
                "description": "Gushing mountain stream with fresh trout water cafes and wooden footbridges in Kiwai.",
                "image_url": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2070&auto=format&fit=crop",
                "distance_from_isb_km": 210,
                "corridor": "Naran Corridor"
            },
            {
                "id": "poi_03",
                "name": "Saif-ul-Malook Glacial Lake",
                "category": "Lake",
                "type": "lake",
                "latitude": 34.8767,
                "longitude": 73.6931,
                "rating": 4.9,
                "description": "High-altitude turquoise lake at 3,224m flanked by the towering snow dome of Malika Parbat.",
                "image_url": "https://images.unsplash.com/photo-1581895690858-a5ea6c4d7e00?q=80&w=2070&auto=format&fit=crop",
                "distance_from_isb_km": 285,
                "corridor": "Naran Corridor"
            },
            {
                "id": "poi_04",
                "name": "Lulusar Lake & Alpine Streams",
                "category": "Lake & Waterfall",
                "type": "lake",
                "latitude": 35.0833,
                "longitude": 73.9167,
                "rating": 4.8,
                "description": "Pristine, crystal-clear mountain lake surrounded by wildflowers and cascading meltwater springs.",
                "image_url": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2070&auto=format&fit=crop",
                "distance_from_isb_km": 330,
                "corridor": "Babusar Corridor"
            },
            {
                "id": "poi_05",
                "name": "Babusar Top Mountain Pass (4,173m)",
                "category": "Mountain Pass & Viewpoint",
                "type": "pass",
                "latitude": 35.1481,
                "longitude": 74.0483,
                "rating": 4.9,
                "description": "The highest motorable point in Kaghan Valley offering panoramic views of both the Himalayas and Karakoram ranges.",
                "image_url": "https://images.unsplash.com/photo-1595166249673-c62d0943eb14?q=80&w=2070&auto=format&fit=crop",
                "distance_from_isb_km": 360,
                "corridor": "Babusar Corridor"
            },
            {
                "id": "poi_06",
                "name": "Rakaposhi Viewpoint & Glacier Stream",
                "category": "Viewpoint & Waterfall",
                "type": "viewpoint",
                "latitude": 36.1950,
                "longitude": 74.4520,
                "rating": 4.9,
                "description": "Roadside viewpoint looking directly up at the sheer 7,788m vertical rise of Mount Rakaposhi with icy glacial springs.",
                "image_url": "https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=2070&auto=format&fit=crop",
                "distance_from_isb_km": 540,
                "corridor": "Karakoram Highway"
            },
            {
                "id": "poi_07",
                "name": "Altit Fort & Queen's Garden",
                "category": "Historic Fort & Heritage",
                "type": "fort",
                "latitude": 36.3139,
                "longitude": 74.6714,
                "rating": 4.9,
                "description": "Magnificent 900-year-old fort perched above the Hunza River with restored traditional royal orchards.",
                "image_url": "https://images.unsplash.com/photo-1631558288597-28d8ed273fec?q=80&w=2070&auto=format&fit=crop",
                "distance_from_isb_km": 585,
                "corridor": "Hunza Valley"
            },
            {
                "id": "poi_08",
                "name": "Attabad Lake & Jet Ski Point",
                "category": "Lake & Water Adventure",
                "type": "lake",
                "latitude": 36.3333,
                "longitude": 74.8667,
                "rating": 4.9,
                "description": "Dramatic turquoise lake with sheer mountain walls, motorboat rides, and lakeside wooden terraces.",
                "image_url": "https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=2070&auto=format&fit=crop",
                "distance_from_isb_km": 605,
                "corridor": "Hunza Valley"
            }
        ]

    async def get_corridor_attractions(
        self,
        route_type: str = "scenic",
        category_filter: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Retrieves tourist attractions along the travel corridor filtered by route and category.
        """
        results = self.cached_corridor_pois

        if route_type == "fastest":
            # Direct route has fewer mountain pass stops
            results = [p for p in results if p.get("type") in ["lake", "fort", "viewpoint"]]

        if category_filter and category_filter != "all":
            filt = category_filter.lower()
            results = [p for p in results if filt in p.get("category", "").lower() or filt in p.get("type", "").lower()]

        return results

poi_service = POIService()
