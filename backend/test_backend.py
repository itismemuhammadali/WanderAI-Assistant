import asyncio
from main import app
from httpx import AsyncClient, ASGITransport

async def test_all_endpoints():
    print("==================================================")
    print("TESTING AI-BASED TRAVEL ASSISTANT FASTAPI BACKEND")
    print("==================================================")

    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://testserver") as client:
        # 1. Health check
        res = await client.get("/")
        assert res.status_code == 200
        print("✓ [GET /] Root health check passed:", res.json()["service"])

        # 2. NLP Query parsing
        query_payload = {"query": "I want a 4 day scenic road trip from Islamabad to Hunza Valley"}
        res = await client.post("/api/nlp/parse", json=query_payload)
        assert res.status_code == 200
        data = res.json()["data"]
        print(f"✓ [POST /api/nlp/parse] NLP extraction passed: Destination={data['destination']}, Days={data['duration_days']}, Route={data['route_preference']}")

        # 3. Dual Route calculation
        route_payload = {"origin": "Islamabad", "destination": "Hunza Valley"}
        res = await client.post("/api/routes/calculate", json=route_payload)
        assert res.status_code == 200
        routes = res.json()["data"]["routes"]
        print(f"✓ [POST /api/routes/calculate] Dual routes generated: Fastest={routes['fastest']['distance_km']}km, Scenic={routes['scenic']['distance_km']}km ({len(routes['scenic']['waypoints'])} waypoints)")

        # 4. Corridor POIs (Waterfalls, lakes, passes)
        res = await client.get("/api/pois/corridor?route_type=scenic")
        assert res.status_code == 200
        pois = res.json()["data"]
        print(f"✓ [GET /api/pois/corridor] Retrieved {len(pois)} scenic corridor attractions (waterfalls, lakes, passes)")

        # 5. Tour Packages
        res = await client.get("/api/packages")
        assert res.status_code == 200
        pkgs = res.json()["data"]
        print(f"✓ [GET /api/packages] Retrieved {len(pkgs)} tour packages")

        # 6. Booking Creation
        booking_payload = {
            "user_id": "ali_student_311",
            "package_id": pkgs[0]["id"],
            "travel_date": "2026-10-15",
            "guests_count": 2,
            "total_price": 90000.0,
            "contact_phone": "+923001234567"
        }
        res = await client.post("/api/bookings", json=booking_payload)
        assert res.status_code == 201
        booking = res.json()["data"]
        print(f"✓ [POST /api/bookings] Booking successfully confirmed! ID={booking['id']}")

        # 7. AI Chat Assistant
        chat_payload = {"message": "What is the best route and what should I pack for Babusar pass?"}
        res = await client.post("/api/chat", json=chat_payload)
        assert res.status_code == 200
        chat_res = res.json()["reply"]
        print("✓ [POST /api/chat] AI Assistant response received:")
        print("   ", chat_res[:90], "...")

    print("==================================================")
    print("ALL 7 ENDPOINTS VERIFIED AND PASSING 100%!")
    print("==================================================")

if __name__ == "__main__":
    asyncio.run(test_all_endpoints())
