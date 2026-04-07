# Route Interchange Testing Guide

## How to Test Different Route Combinations

### Access the App
1. Open the app
2. Tap "Login with OTP" → Enter any valid phone (e.g., 9876543210)
3. You'll be on the Home Screen

---

## Test Cases by Route Type

### ✅ Test 1: Direct Route (Same Line)

**Test:** Churchgate (WR) → Borivali (WR)

**Steps:**
1. Home screen loads with default route
2. Look for "Journey Summary"
3. Should show two dropdowns for source and destination
4. Verify "Find Trains" button is visible

**Expected Result:**
- Route Selection Screen shows 1 route
- Says "Direct route via WR"
- No interchange badge visible
- Fare: ~₹25
- Time: ~15 min
- Route 1 shows blue checkmark (selected)

**How it looks:**
```
Route 1
Direct route via WR
⏱ ~15 min    ₹25.00
```

---

### 🔄 Test 2: Single Interchange (WR to CR)

**Test:** Borivali (WR) → Thane (CR)

**Steps:**
1. Home screen source: Borivali (WR)
2. Change destination to: Thane (CR)
3. Click "Find Trains"

**Expected Result:**
- Route Selection shows 1 route
- Says "WR → Change at Dadar → CR"
- Orange badge shows "Change at Dadar"
- Fare: ~₹50
- Time: ~18 min

**How it looks:**
```
Route 1
WR → Change at Dadar → CR
ⓘ Change at Dadar
⏱ ~18 min    ₹50.00
```

---

### 🔄 Test 3: Single Interchange (CR to HL)

**Test:** Thane (CR) → Panvel (HL)

**Steps:**
1. Home screen source: Thane (CR)
2. Change destination to: Panvel (HL)
3. Click "Find Trains"

**Expected Result:**
- Shows multiple routes (might show Kurla and Chembur alternatives)
- Primary route: "CR → Change at Kurla → HL"
- Secondary route: "CR → Change at Chembur → HL"
- Both show orange interchange badges

**How it looks:**
```
Route 1                    (or Route 1 & Route 2)
CR → Change at Kurla → HL
ⓘ Change at Kurla
⏱ ~22 min    ₹55.00

Route 2
CR → Change at Chembur → HL
ⓘ Change at Chembur
⏱ ~20 min    ₹52.00
```

---

### 🔄 Test 4: Single Interchange (WR to HL)

**Test:** Churchgate (WR) → Seawoods (HL)

**Steps:**
1. Home screen source: Churchgate (WR)
2. Change destination to: Seawoods (HL)
3. Click "Find Trains"

**Expected Result:**
- Route says: "WR → Change at Bandra → HL"
- Orange badge: "Change at Bandra"
- Fare: ~₹58
- Time: ~25 min

**How it looks:**
```
Route 1
WR → Change at Bandra → HL
ⓘ Change at Bandra
⏱ ~25 min    ₹58.00
```

---

### 🔄 Test 5: Single Interchange (CR to THL)

**Test:** CSMT (CR) → Panvel (THL)

**Steps:**
1. Home screen source: CSMT (CR)
2. Change destination to: Panvel (THL)
3. Click "Find Trains"

**Expected Result:**
- Route says: "CR → Change at Thane → THL"
- Orange badge: "Change at Thane"
- Fare: ~₹60
- Time: ~28 min

**How it looks:**
```
Route 1
CR → Change at Thane → THL
ⓘ Change at Thane
⏱ ~28 min    ₹60.00
```

---

### 🔄 Test 6: Multiple Interchange Points (HL to THL)

**Test:** CSMT (HL) → Kharghar (THL)

**Steps:**
1. Home screen source: CSMT (HL)
2. Change destination to: Kharghar (THL)
3. Click "Find Trains"

**Expected Result:**
- Shows multiple routes (Panvel, Vashi, Sanpada)
- Primary: "HL → Change at Panvel → THL"
- Secondary options available
- Each with orange badge

**How it looks:**
```
Route 1                    (or Route 1, 2, 3)
HL → Change at Panvel → THL
ⓘ Change at Panvel
⏱ ~35 min    ₹68.00

Route 2
HL → Change at Vashi → THL
ⓘ Change at Vashi
⏱ ~36 min    ₹68.50
```

---

## Comprehensive Test Matrix

| Test # | From | To | Expected Interchange | Route Type |
|--------|------|----|--------------------|-----------|
| 1 | Churchgate (WR) | Borivali (WR) | None | Direct |
| 2 | Borivali (WR) | Thane (CR) | Dadar | WR→CR |
| 3 | Thane (CR) | Panvel (HL) | Kurla | CR→HL |
| 4 | Churchgate (WR) | Seawoods (HL) | Bandra | WR→HL |
| 5 | CSMT (CR) | Panvel (THL) | Thane | CR→THL |
| 6 | CSMT (HL) | Kharghar (THL) | Panvel | HL→THL |
| 7 | Marine Lines (WR) | CSMT (CR) | Dadar | WR→CR |
| 8 | Byculla (CR) | Chembur (HL) | Chembur | CR→HL |
| 9 | Dadar (WR) | Vashi (THL) | Bandra→Panvel | WR→HL→THL |

---

## UI Verification Checklist

For each test route, verify:

- ✅ Route Selection Screen opens
- ✅ Journey Summary card shows source & destination
- ✅ Available Routes section is visible
- ✅ Route cards display correctly
- ✅ For direct routes: "Direct route via [LINE]" shown
- ✅ For interchange: Line change info shown (e.g., "WR → Change at X → CR")
- ✅ Orange "Change at" badge appears for interchange routes
- ✅ Time estimate shows (e.g., "~18 min")
- ✅ Fare estimate shows (e.g., "₹50.00")
- ✅ Can select/deselect routes with radio button
- ✅ Selected route shows blue circle/checkmark
- ✅ "Proceed to Payment" button is functional

---

## Payment Screen Integration

After selecting a route:

1. Route card is highlighted with blue border
2. Tap "Proceed to Payment"
3. Payment Screen should show:
   - Selected route info in summary
   - Route description (e.g., "WR → Change at Dadar → CR")
   - Correct fare amount
   - Ticket class and type from home screen

---

## Edge Cases to Test

### Test 7: Reverse Route (Same Route, Different Direction)
**Test:** Thane (CR) → Borivali (WR)

**Expected:**
- System calculates: CR → WR (reverse of CR to WR path)
- Shows: "CR → Change at Dadar → WR"
- May show same fare or reverse calculation

---

### Test 8: Very Far Stations
**Test:** Churchgate (WR) → Panvel (THL)

**Expected:**
- One or more routes shown
- Higher fare (for long distance with multiple changes)
- Longer time estimate

---

### Test 9: Same Station Different Lines
**Test:** Dadar (WR) → Dadar (CR)

**Expected:**
- System recognizes Dadar is on both lines
- Shows change at Dadar
- Very short journey time (~5 min)
- Lower fare

---

## Debugging Tips

### If route doesn't show:
1. Check station names have correct line code (WR/CR/HL/THL)
2. Verify interchange station is in the lineConnections map
3. Check console for errors

### If fare looks wrong:
1. Review _calculateFare() logic
2. Check baseFarePerStation constant
3. Verify interchangeFee is added

### If time looks wrong:
1. Review _calculateTime() logic
2. Check timePerSegment and interchangeTime values
3. Verify waiting time is included

---

## Sample Test Flow

```
User starts app
         ↓
Enter phone number: 9876543210
         ↓
Land on Home Screen
    [Source: Churchgate (WR)]
    [Destination: Borivali (WR)]
    [Class: Second Class]
    [Type: Single]
         ↓
Click "Find Trains"
         ↓
Route Selection Opens
    See: "Direct route via WR"
    Time: ~15 min
    Fare: ₹25.00
         ↓
Tap on route (auto-selected)
         ↓
Click "Proceed to Payment"
         ↓
Payment Screen Shows
    Journey: Churchgate → Borivali
    Route: Direct route via WR
    Fare: ₹25.00
    Ticket: Second Class, Single
```

---

## Success Criteria

✅ All tests pass when:
- Direct routes show "Direct route via [LINE]"
- Single interchange shows "LINE1 → Change at STATION → LINE2"
- Orange badge shows for interchanges
- Times and fares are reasonable
- UI renders without errors
- Payment screen receives correct route info
- User can complete booking flow

---

**Note:** This is a comprehensive testing guide covering all supported routes in the Mumbai Local Train system.
