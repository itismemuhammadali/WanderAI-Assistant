# Testing Checklist - Booking Flow Implementation

## Pre-Testing Setup
- [ ] Run `flutter pub get` to ensure all dependencies are up to date
- [ ] Run `flutter clean` to clear build cache
- [ ] Run `flutter run` to build and launch the app

## Test Scenario 1: Complete Booking Flow

### Step 1: Navigate to Booking Screen
- [ ] Open app and go to Home Screen
- [ ] Click "Book a Trip" button
- [ ] Verify Booking Screen loads with:
  - [ ] Search bar with filter icon
  - [ ] "Select Destination" section
  - [ ] Trip Type options (Solo, Couple, Family, Group)
  - [ ] Travelers counter
  - [ ] Travel Mode options (Car, Bus, Flight)
  - [ ] Accommodation options (Hotel, Resort, Cottage, Camping)
  - [ ] "View Trip Options" button (disabled initially)

### Step 2: Select Destination
- [ ] Scroll down to "Select Destination" section
- [ ] Click on a destination (e.g., "Hunza Valley")
- [ ] Verify destination is highlighted with checkmark
- [ ] Verify "View Trip Options" button becomes enabled

### Step 3: Apply Filters (Optional)
- [ ] Click filter icon (tune icon) on search bar
- [ ] Verify Filters Screen opens
- [ ] Select a region (e.g., "Northern Pakistan")
- [ ] Scroll down and click "Apply Filters"
- [ ] Verify modal closes
- [ ] Verify destination list updates to show only selected region
- [ ] Select a destination from filtered list

### Step 4: Navigate to Trip Itineraries
- [ ] Click "View Trip Options" button
- [ ] Verify Trip Itineraries Screen loads with:
  - [ ] Title "Choose Your Perfect Trip"
  - [ ] Subtitle showing destination name
  - [ ] 3 itinerary cards (3 Days, 5 Days, 7 Days)

### Step 5: Explore Itinerary Options
- [ ] Verify each card shows:
  - [ ] Duration (3 Days, 5 Days, 7 Days)
  - [ ] Description
  - [ ] Highlights (tags)
  - [ ] Total price
  - [ ] "View Details" button
- [ ] Click "View Details" on 3 Days option
- [ ] Verify modal opens showing:
  - [ ] Day-by-day activities
  - [ ] Hotel options with ratings and prices
  - [ ] Included meals
- [ ] Scroll through modal and close it
- [ ] Repeat for other itineraries

### Step 6: Select Itinerary
- [ ] Click on 5 Days itinerary card
- [ ] Verify checkmark appears on selected card
- [ ] Verify "Continue to Booking" button is enabled
- [ ] Click "Continue to Booking"

### Step 7: Enter Booking Details
- [ ] Verify Booking Details Screen loads
- [ ] Verify pre-filled fields:
  - [ ] Full Name (from profile)
  - [ ] Phone (from profile)
- [ ] Fill in Emergency Phone (e.g., "03001234567")
- [ ] Click on Pickup Date field
- [ ] Verify date picker opens
- [ ] Select a future date
- [ ] Verify date is populated in field
- [ ] Fill in Pickup Location (e.g., "Islamabad")
- [ ] Fill in Trip Duration (e.g., "5 days")
- [ ] Click "Continue to Confirmation"

### Step 8: Verify Booking Confirmation
- [ ] Verify Booking Confirmation Screen loads with:
  - [ ] Success checkmark icon
  - [ ] "Booking Received!" message
  - [ ] Trip details showing:
    - [ ] Destination name
    - [ ] Selected duration (5 Days)
  - [ ] Traveler information:
    - [ ] Full Name
    - [ ] Phone
    - [ ] Emergency Phone
    - [ ] Pickup Date
    - [ ] Pickup Location
    - [ ] Trip Duration
  - [ ] Total price from selected itinerary
  - [ ] Info message about 24-hour confirmation call
- [ ] Click "Back to Home"
- [ ] Verify navigation back to Home Screen

## Test Scenario 2: Different Itinerary Selection

- [ ] Repeat Steps 1-6 but select 7 Days itinerary
- [ ] Verify price changes to 120,000
- [ ] Complete booking and verify confirmation shows 7 Days

## Test Scenario 3: Filter and Book

- [ ] Go to Booking Screen
- [ ] Click filter icon
- [ ] Select "Central Pakistan" region
- [ ] Apply filters
- [ ] Select "Lahore" destination
- [ ] Click "View Trip Options"
- [ ] Select 3 Days itinerary
- [ ] Complete booking
- [ ] Verify confirmation shows correct destination and price

## Test Scenario 4: Edge Cases

### No Destination Selected
- [ ] Go to Booking Screen
- [ ] Verify "View Trip Options" button is disabled
- [ ] Try to click it (should not respond)

### No Itinerary Selected
- [ ] Go to Booking Screen
- [ ] Select destination
- [ ] Click "View Trip Options"
- [ ] Verify "Continue to Booking" button is disabled
- [ ] Try to click it (should not respond)

### Form Validation
- [ ] Go to Booking Details Screen
- [ ] Leave Emergency Phone empty
- [ ] Try to click "Continue to Confirmation"
- [ ] Verify error message appears

## Test Scenario 5: Navigation

### Back Button Navigation
- [ ] From Trip Itineraries Screen, click back button
- [ ] Verify navigation back to Booking Screen
- [ ] From Booking Details Screen, click back button
- [ ] Verify navigation back to Trip Itineraries Screen

### Home Navigation
- [ ] From Booking Confirmation Screen, click "Back to Home"
- [ ] Verify navigation to Home Screen
- [ ] Verify bottom navigation bar is visible

## Performance Tests

- [ ] Verify Trip Itineraries Screen loads quickly
- [ ] Verify modal details load smoothly
- [ ] Verify no lag when selecting itineraries
- [ ] Verify smooth transitions between screens

## UI/UX Tests

- [ ] Verify all text is readable
- [ ] Verify buttons are easily clickable
- [ ] Verify colors match theme (teal accent)
- [ ] Verify spacing and padding are consistent
- [ ] Verify responsive layout on different screen sizes

## Data Persistence Tests

- [ ] Select destination and filters
- [ ] Go to Trip Itineraries
- [ ] Go back to Booking Screen
- [ ] Verify destination is still selected
- [ ] Verify filters are still applied

## Error Handling Tests

- [ ] Test with no internet (if applicable)
- [ ] Test with invalid date selection
- [ ] Test with special characters in text fields

## Final Verification

- [ ] All buttons navigate correctly
- [ ] All data flows through the booking process
- [ ] Confirmation screen shows correct information
- [ ] No crashes or errors during flow
- [ ] User can complete full booking journey

## Sign-Off

- [ ] All tests passed ✅
- [ ] Ready for production ✅
- [ ] No critical issues ✅
- [ ] User experience is smooth ✅

---

**Test Date**: _______________
**Tester Name**: _______________
**Notes**: _______________________________________________
