import re
from typing import Dict, Any, List

class NLPService:
    def __init__(self):
        self.nlp = None
        try:
            import spacy
            # Attempt to load small English model if installed
            self.nlp = spacy.load("en_core_web_sm")
            print("Loaded SpaCy en_core_web_sm model successfully.")
        except Exception:
            print("SpaCy model not installed locally. Utilizing high-performance rule-based NER engine.")

        # Known Pakistani cities and tourist destinations
        self.destinations = [
            "hunza", "hunza valley", "skardu", "swat", "swat valley",
            "fairy meadows", "naran", "kaghan", "naran kaghan", "neelum",
            "neelum valley", "kumrat", "kumrat valley", "chitral", "kalash",
            "gilgit", "lahore", "islamabad", "rawalpindi", "karachi", "peshawar",
            "murree", "ayubia", "nathia gali", "malam jabba"
        ]

        self.origins = ["islamabad", "rawalpindi", "lahore", "karachi", "peshawar", "faisalabad", "multan"]

    def parse_query(self, text: str) -> Dict[str, Any]:
        """
        Extracts origin, destination, duration, route preference, and tags from natural language.
        """
        clean_text = text.lower().strip()

        # 1. Extract Destination
        extracted_destination = "Hunza Valley"
        for d in sorted(self.destinations, key=len, reverse=True):
            if re.search(r'\b' + re.escape(d) + r'\b', clean_text):
                extracted_destination = d.title()
                break

        # 2. Extract Origin
        extracted_origin = "Islamabad"
        origin_match = re.search(r'\b(?:from|leaving)\s+([a-zA-Z\s]+?)(?:\s+(?:to|for|heading)|\b)', clean_text)
        if origin_match:
            cand = origin_match.group(1).strip().lower()
            for o in self.origins:
                if o in cand:
                    extracted_origin = o.title()
                    break
        else:
            for o in self.origins:
                if re.search(r'\bfrom\s+' + re.escape(o) + r'\b', clean_text):
                    extracted_origin = o.title()
                    break

        # 3. Extract Duration in Days
        duration_days = 5
        duration_match = re.search(r'(\d+)\s*(?:-|to)?\s*(?:day|days|night|nights)', clean_text)
        if duration_match:
            duration_days = int(duration_match.group(1))
        elif "weekend" in clean_text:
            duration_days = 2
        elif "week" in clean_text:
            duration_days = 7

        # 4. Extract Route Preference
        route_preference = "scenic"
        if any(w in clean_text for w in ["fast", "fastest", "quick", "direct", "express", "shortest", "flight"]):
            route_preference = "fastest"
        elif any(w in clean_text for w in ["scenic", "view", "pass", "relaxing", "nature", "attractions", "stops"]):
            route_preference = "scenic"

        # 5. Extract Category and Mood Tags
        tags = []
        if any(w in clean_text for w in ["mountain", "hiking", "trek", "peaks", "passu"]):
            tags.append("Mountains")
        if any(w in clean_text for w in ["lake", "river", "waterfall", "water"]):
            tags.append("Lakes & Waterfalls")
        if any(w in clean_text for w in ["history", "fort", "heritage", "ancient", "culture"]):
            tags.append("Cultural Heritage")
        if any(w in clean_text for w in ["adventure", "safari", "jeep", "ski"]):
            tags.append("Adventure")
        if not tags:
            tags = ["Scenic Landscapes", "Relaxation"]

        # 6. Budget calculation estimate
        base_rate_per_day = 8000
        if "luxury" in clean_text or "resort" in clean_text or "5 star" in clean_text:
            base_rate_per_day = 14000
        elif "budget" in clean_text or "cheap" in clean_text or "backpack" in clean_text:
            base_rate_per_day = 4500

        estimated_budget = base_rate_per_day * duration_days

        return {
            "query": text,
            "origin": extracted_origin,
            "destination": extracted_destination,
            "duration_days": duration_days,
            "route_preference": route_preference,
            "tags": tags,
            "estimated_budget_pkr": estimated_budget,
            "parsed_success": True
        }

nlp_service = NLPService()
