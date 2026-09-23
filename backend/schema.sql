-- ====================================================================
-- AI-BASED TRAVEL ASSISTANT SYSTEM
-- Production Relational Schema for PostgreSQL / Supabase
-- ====================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(50) DEFAULT 'traveler' CHECK (role IN ('traveler', 'admin')),
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. TOUR PACKAGES TABLE
CREATE TABLE IF NOT EXISTS tour_packages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL DEFAULT 'north',
    duration_days INTEGER NOT NULL CHECK (duration_days > 0),
    base_price NUMERIC(10, 2) NOT NULL CHECK (base_price >= 0),
    rating NUMERIC(3, 2) DEFAULT 4.8 CHECK (rating >= 1.0 AND rating <= 5.0),
    image_url TEXT NOT NULL,
    description TEXT NOT NULL,
    included_amenities JSONB DEFAULT '["Transport", "Hotel", "Guided Tours", "Breakfast"]'::jsonb,
    is_featured BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. BOOKINGS TABLE
CREATE TABLE IF NOT EXISTS bookings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    package_id UUID REFERENCES tour_packages(id) ON DELETE SET NULL,
    travel_date DATE NOT NULL,
    guests_count INTEGER NOT NULL DEFAULT 1 CHECK (guests_count > 0),
    total_price NUMERIC(10, 2) NOT NULL CHECK (total_price >= 0),
    status VARCHAR(50) DEFAULT 'confirmed' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
    contact_phone VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. ITINERARIES TABLE
CREATE TABLE IF NOT EXISTS itineraries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    total_distance_km NUMERIC(8, 2),
    duration_days INTEGER NOT NULL DEFAULT 3,
    route_type VARCHAR(50) DEFAULT 'scenic' CHECK (route_type IN ('fastest', 'scenic', 'balanced')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. ITINERARY STOPS TABLE
CREATE TABLE IF NOT EXISTS itinerary_stops (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    itinerary_id UUID REFERENCES itineraries(id) ON DELETE CASCADE,
    stop_order INTEGER NOT NULL,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    planned_arrival TIMESTAMP WITH TIME ZONE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. POINTS OF INTEREST (POIs) TABLE
CREATE TABLE IF NOT EXISTS points_of_interest (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    category VARCHAR(100) NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    image_url TEXT,
    rating NUMERIC(3, 2) DEFAULT 4.7,
    description TEXT,
    corridor_tag VARCHAR(100) DEFAULT 'Karakoram Highway',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. AI CHAT LOGS TABLE
CREATE TABLE IF NOT EXISTS ai_chat_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    sender VARCHAR(20) NOT NULL CHECK (sender IN ('user', 'assistant')),
    message TEXT NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_packages_region ON tour_packages(region);
CREATE INDEX IF NOT EXISTS idx_bookings_user ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_stops_itinerary ON itinerary_stops(itinerary_id, stop_order);
CREATE INDEX IF NOT EXISTS idx_poi_coords ON points_of_interest(latitude, longitude);

-- ====================================================================
-- SEED DATA: TOUR PACKAGES & POIs
-- ====================================================================

INSERT INTO tour_packages (title, destination, region, duration_days, base_price, rating, image_url, description, included_amenities) VALUES
('Majestic Hunza & Passu Cones Expedition', 'Hunza Valley', 'north', 5, 45000.00, 4.9, 'https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=2070&auto=format&fit=crop', 'Explore Karimabad, Altit and Baltit Forts, Attabad Lake boat cruise, and the dramatic Passu Cones.', '["4x4 Mountain Transport", "Luxury Hotel Stay", "Breakfast & Dinner", "Attabad Boating Pass"]')
ON CONFLICT DO NOTHING;

INSERT INTO tour_packages (title, destination, region, duration_days, base_price, rating, image_url, description, included_amenities) VALUES
('Skardu Shangrila & Cold Desert Safari', 'Skardu', 'north', 6, 55000.00, 4.8, 'https://images.unsplash.com/photo-1625807908993-a5ffbfbf3205?q=80&w=2070&auto=format&fit=crop', 'Immerse yourself in Shangrila Resort, Lower and Upper Kachura Lakes, Sarfaranga cold desert safari, and Shigar Fort.', '["Private Coaster/Prado", "Resort Stay", "Desert Safari Ticket", "All Meals"]')
ON CONFLICT DO NOTHING;

INSERT INTO tour_packages (title, destination, region, duration_days, base_price, rating, image_url, description, included_amenities) VALUES
('Swat Valley & Malam Jabba Ski Retreat', 'Swat Valley', 'north', 4, 35000.00, 4.7, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2070&auto=format&fit=crop', 'Visit the Switzerland of the East with river-side stays in Bahrain and chairlift adventure at Malam Jabba.', '["AC Transport", "Hotel Stay", "Chairlift Pass", "Guided Tour"]')
ON CONFLICT DO NOTHING;

INSERT INTO tour_packages (title, destination, region, duration_days, base_price, rating, image_url, description, included_amenities) VALUES
('Fairy Meadows & Nanga Parbat Base Camp Trek', 'Fairy Meadows', 'north', 5, 40000.00, 4.9, 'https://images.unsplash.com/photo-1601633596700-0834ba128564?q=80&w=2070&auto=format&fit=crop', 'Hike to the legendary lush plateau of Fairy Meadows directly beneath the massive north face of Nanga Parbat.', '["4x4 Jeep Ride", "Camping/Cottage", "Trekking Guide", "Bonfire Dinners"]')
ON CONFLICT DO NOTHING;

-- Seed Corridor POIs
INSERT INTO points_of_interest (name, category, latitude, longitude, image_url, rating, description, corridor_tag) VALUES
('Kallar Kahar Lake', 'Lake & Heritage', 32.7819, 72.7056, 'https://images.unsplash.com/photo-1630139266136-1e663a0a322e?q=80&w=2074&auto=format&fit=crop', 4.5, 'Salt lake featuring natural orchards, historical Takht-e-Babri, and wild peacocks along M-2.', 'M2 Motorway'),
('Saif-ul-Malook Lake', 'Glacial Lake', 34.8767, 73.6931, 'https://images.unsplash.com/photo-1581895690858-a5ea6c4d7e00?q=80&w=2070&auto=format&fit=crop', 4.9, 'Iconic emerald-green glacial lake in Kaghan Valley surrounded by snow peaks.', 'Naran Corridor'),
('Babusar Top Mountain Pass', 'High Mountain Pass', 35.1481, 74.0483, 'https://images.unsplash.com/photo-1595166249673-c62d0943eb14?q=80&w=2070&auto=format&fit=crop', 4.8, 'Panoramic pass connecting Kaghan Valley to Gilgit Baltistan at 4,173 meters elevation.', 'Babusar Corridor'),
('Lulusar Lake & Waterfall', 'Lake & Waterfall', 35.0833, 73.9167, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2070&auto=format&fit=crop', 4.7, 'Mirror-like natural reservoir feeding the Kunhar River with roadside waterfalls.', 'Babusar Corridor'),
('Altit Fort & Royal Orchards', 'Historic Heritage', 36.3139, 74.6714, 'https://images.unsplash.com/photo-1631558288597-28d8ed273fec?q=80&w=2070&auto=format&fit=crop', 4.9, 'Nine-century-old fortress standing atop a 1000-foot cliff over the Hunza River.', 'Hunza Valley'),
('Attabad Lake Cruise', 'Turquoise Lake', 36.3333, 74.8667, 'https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=2070&auto=format&fit=crop', 4.9, 'Crystal turquoise alpine lake offering speedboat cruises and jet-skiing.', 'Hunza Valley')
ON CONFLICT DO NOTHING;
