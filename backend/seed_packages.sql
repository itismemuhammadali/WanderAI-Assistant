-- Seed 25 Comprehensive Pakistan Tour Packages into Supabase
INSERT INTO tour_packages (title, destination, region, duration_days, base_price, rating, image_url, description, included_amenities, is_featured) VALUES
('Majestic Hunza & Passu Cones Expedition', 'Hunza Valley', 'north', 5, 45000.00, 4.9, 'https://images.unsplash.com/photo-1514558427911-8e293bebf18c?q=80&w=1080&auto=format&fit=crop', 'Explore Karimabad, Altit and Baltit Forts, Attabad Lake boat cruise, and dramatic Passu Cones.', '["4x4 Mountain Transport", "Luxury Hotel Stay", "Breakfast & Dinner", "Attabad Boating Pass"]'::jsonb, true),

('Skardu Shangrila & Cold Desert Safari', 'Skardu', 'north', 6, 55000.00, 4.8, 'https://images.unsplash.com/photo-1679951124125-50cc4029d727?q=80&w=1080&auto=format&fit=crop', 'Immerse in Shangrila Resort, Lower and Upper Kachura Lakes, Sarfaranga cold desert safari, and historic Shigar Fort.', '["Private Coaster/Prado", "Resort Stay", "Desert Safari Ticket", "All Meals"]'::jsonb, true),

('Swat Valley & Malam Jabba Ski Retreat', 'Swat Valley', 'north', 4, 35000.00, 4.7, 'https://images.unsplash.com/photo-1668936782695-5f7657dc793d?q=80&w=1080&auto=format&fit=crop', 'Visit the Switzerland of the East with river-side stays in Bahrain and chairlift adventure at Malam Jabba.', '["AC Transport", "Hotel Stay", "Chairlift Pass", "Guided Tour"]'::jsonb, true),

('Fairy Meadows & Nanga Parbat Base Camp Trek', 'Fairy Meadows', 'north', 5, 40000.00, 4.9, 'https://images.unsplash.com/photo-1664872763520-348c1cbbade4?q=80&w=1080&auto=format&fit=crop', 'Hike to the legendary plateau of Fairy Meadows directly beneath the north face of Nanga Parbat.', '["4x4 Jeep Ride", "Camping/Cottage", "Trekking Guide", "Bonfire Dinners"]'::jsonb, true),

('Naran Kaghan & Saif ul Malook Alpine Escape', 'Naran', 'north', 3, 28000.00, 4.8, 'https://images.unsplash.com/photo-1668061867899-02b4cfa34747?q=80&w=1080&auto=format&fit=crop', 'Witness the turquoise waters of Lake Saiful Malook, Kunhar River trout fishing, and Babusar Top vistas.', '["Deluxe Coaster", "Standard Hotel", "Jeep Safari", "Daily Breakfast"]'::jsonb, true),

('Kumrat Valley & Jahaz Banda Waterfall Trek', 'Kumrat Valley', 'north', 4, 34000.00, 4.8, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=1080&auto=format&fit=crop', 'Experience dense pine forests, rushing Panjkora River, wooden canal bridges, and Jahaz Banda high meadows.', '["Mountain Jeep", "Riverside Camping", "Campfire", "All Meals"]'::jsonb, false),

('Neelum Valley & Arang Kel Kashmir Haven', 'Neelum Valley', 'north', 5, 38000.00, 4.9, 'https://images.unsplash.com/photo-1581895690858-a5ea6c4d7e00?q=80&w=1080&auto=format&fit=crop', 'Explore the pearl of Azad Kashmir with stops at Kutton Waterfall, Sharda Peeth temple ruins, and Arang Kel cable car.', '["AC Saloon Transport", "Kashmir River Resort", "Local Guide", "Breakfast & Dinner"]'::jsonb, true),

('Ratti Gali Glacial Lake Alpine Expedition', 'Ratti Gali', 'north', 4, 32000.00, 4.8, 'https://images.unsplash.com/photo-1595166249673-c62d0943eb14?q=80&w=1080&auto=format&fit=crop', 'Ascend from Dowarian via rugged mountain jeeps to the red alpine flower-ringed Ratti Gali glacial lake.', '["4x4 Jeep Trek", "Alpine Dome Tents", "Trek Leader", "Traditional Meals"]'::jsonb, false),

('Shogran & Siri Paye Cloud Meadows', 'Shogran', 'north', 3, 26000.00, 4.7, 'https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=1080&auto=format&fit=crop', 'Horse ride through the misty pine meadows of Siri Paye elevated at 3,000 meters above Kaghan Valley.', '["AC Transport", "Shogran Pine Hotel", "Horse Riding Pass", "Daily Meals"]'::jsonb, false),

('Kalash Chilam Joshi & Chitral Heritage Tour', 'Chitral', 'north', 5, 42000.00, 4.9, 'https://images.unsplash.com/photo-1596761224566-32454a8549e3?q=80&w=1080&auto=format&fit=crop', 'Participate in the ancient animist cultural traditions, folk dances, and vibrant costumes of the Kalash people.', '["Lowari Tunnel Transport", "Traditional Guest House", "Festival Pass", "Cultural Guide"]'::jsonb, true),

('Deosai Plains Land of Giants Wildlife Safari', 'Deosai', 'north', 5, 48000.00, 4.9, 'https://images.unsplash.com/photo-1631558288597-28d8ed273fec?q=80&w=1080&auto=format&fit=crop', 'Journey through the world second highest alpine plateau, home to Himalayan brown bears and heart-shaped Sheosar Lake.', '["Rugged 4x4 Prado", "Glamping Tents", "Wildlife Ranger Guide", "All Meals"]'::jsonb, true),

('Khunjerab Pass High Altitude Silk Route Expedition', 'Khunjerab', 'north', 6, 52000.00, 4.9, 'https://images.unsplash.com/photo-1601633596700-0834ba128564?q=80&w=1080&auto=format&fit=crop', 'Drive along the highest paved international border crossing at 4,693 meters and see Himalayan ibex.', '["Luxury Coaster", "Karimabad Boutique Hotel", "National Park Entry", "Full Board Meals"]'::jsonb, true),

('Nathia Gali & Mushkpuri Peak Nature Trail', 'Galiyat', 'central', 2, 18000.00, 4.6, 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?q=80&w=1080&auto=format&fit=crop', 'Trek through moist temperate pine forests to the scenic meadow summit of Mushkpuri with Ayubia chairlift views.', '["Dedicated Van", "Galiyat Lodge Stay", "Trek Guide", "Barbecue Dinner"]'::jsonb, false),

('Lahore Walled City & Mughal Heritage Culinary Trail', 'Lahore', 'central', 3, 22000.00, 4.7, 'https://images.unsplash.com/photo-1622546758596-f1f06ba11f58?q=80&w=1080&auto=format&fit=crop', 'Step back in time at Badshahi Mosque, Lahore Fort, Wazir Khan Mosque, and feast at the famous Fort Road Food Street.', '["City Tour AC Van", "Heritage Hotel Stay", "Monuments Pass", "Traditional Desi Feasts"]'::jsonb, true),

('Islamabad Hills, Faisal Mosque & Monal Sunset Retreat', 'Islamabad', 'central', 2, 16000.00, 4.8, 'https://images.unsplash.com/photo-1608020932658-d0e19a69580b?q=80&w=1080&auto=format&fit=crop', 'Visit the architectural marvel Faisal Mosque, hike Margalla Trail 3, and enjoy a cliffside sunset dinner overlooking the city.', '["Executive Car", "Islamabad Guesthouse", "Trail Guide", "Monal Dinner Voucher"]'::jsonb, false),

('Taxila Gandhara Civilization & Ancient Stupas', 'Taxila', 'central', 2, 15000.00, 4.6, 'https://images.unsplash.com/photo-1599818818817-2384f50bb00d?q=80&w=1080&auto=format&fit=crop', 'Walk through UNESCO World Heritage ruins of Jaulian monastery, Dharmarajika stupa, and the Taxila archaeological museum.', '["Private AC Car", "Museum Passes", "Historian Guide", "Buffet Lunch"]'::jsonb, false),

('Rohtas Fort & Khewra Salt Mines Wonder Tour', 'Jhelum', 'central', 2, 19000.00, 4.7, 'https://images.unsplash.com/photo-1585255318859-f5c15f4cffa9?q=80&w=1080&auto=format&fit=crop', 'Marvel at Sher Shah Suri massive 16th century fortress and take an electric train deep inside the Khewra Salt Mine.', '["Highway Transport", "Hotel Stay", "Mine Train Ticket", "All Meals"]'::jsonb, false),

('Cholistan Desert Safari & Derawar Fort Night Camp', 'Bahawalpur', 'south', 4, 36000.00, 4.8, 'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?q=80&w=1080&auto=format&fit=crop', 'Witness the forty towering bastions of Derawar Fort and enjoy camel caravans and folk music under a star-filled desert sky.', '["4x4 Desert Jeep", "Luxury Desert Tents", "Camel Safari", "Traditional Sajji Dinner"]'::jsonb, true),

('Kund Malir Golden Beach & Hingol Rock Formations', 'Makran', 'south', 2, 24000.00, 4.8, 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1080&auto=format&fit=crop', 'Cruise along the scenic Makran Coastal Highway to view the Princess of Hope, Sphinx, and camp by the Arabian Sea.', '["AC Highway Coaster", "Beachside Camps", "Bonfire & Stargazing", "Seafood Barbecue"]'::jsonb, true),

('Churna Island Coral Reef & Deep Sea Snorkeling', 'Karachi', 'south', 2, 18000.00, 4.7, 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=1080&auto=format&fit=crop', 'Speedboat ride to Churna Island for cliff diving, snorkeling among coral reefs, and spotting sea turtles.', '["Speedboat Transfer", "Snorkeling Gear", "Underwater Photography", "Buffet Lunch"]'::jsonb, false),

('Gorakh Hill Station Murree of Sindh Star Gazing', 'Gorakh Hill', 'south', 3, 25000.00, 4.6, 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1080&auto=format&fit=crop', 'Escape to the 5,688 feet summit of the Kirthar Mountains with zero light pollution and freezing mountain breezes.', '["4x4 Mountain Jeep", "Hill Resort Rooms", "Campfire", "Traditional Balochi Meals"]'::jsonb, false),

('Ziarat Ancient Juniper Forest & Quaid Residency', 'Ziarat', 'south', 3, 28000.00, 4.7, 'https://images.unsplash.com/photo-1448375240586-882707db888b?q=80&w=1080&auto=format&fit=crop', 'Wander through one of the oldest Juniper forests on Earth and visit the historic wooden architectural Quaid-e-Azam Residency.', '["Balochistan Mountain Van", "Ziarat Pine Cottages", "Forest Permit", "All Meals"]'::jsonb, false),

('Astola Island Seven Hills Deep Sea Expedition', 'Pasni', 'south', 4, 58000.00, 4.9, 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?q=80&w=1080&auto=format&fit=crop', 'Boat expedition to Pakistan largest uninhabited island featuring crystal turquoise waters, isolated beaches, and marine life.', '["Private Pasni Trawler", "Island Expedition Camps", "Snorkel & Fishing", "Fresh Catch Dinners"]'::jsonb, true),

('Attabad Lake Water Sports & Hussaini Bridge Thrill', 'Gojal', 'north', 4, 39000.00, 4.9, 'https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=1080&auto=format&fit=crop', 'Jet ski across the turquoise expanse of Attabad Lake and cross the daring suspension bridges of upper Hunza.', '["4x4 Transport", "Lakefront Hotel", "Boating Pass", "All Meals"]'::jsonb, true),

('Kalam Ushu Forest & Mahodand Lake Jeep Trek', 'Kalam', 'north', 4, 33000.00, 4.8, 'https://images.unsplash.com/photo-1668936782695-5f7657dc793d?q=80&w=1080&auto=format&fit=crop', 'Traverse the wild Ushu pine forest and trout streams to reach the glacial jewel Mahodand Lake in upper Swat.', '["Mountain Jeep Ride", "Kalam Riverside Hotel", "Lake Boating", "Full Board Meals"]'::jsonb, true)
ON CONFLICT DO NOTHING;
