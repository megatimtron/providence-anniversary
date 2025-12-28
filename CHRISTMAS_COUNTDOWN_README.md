# Christmas Countdown Website - Instructions

## Overview
A romantic Christmas countdown advent calendar for December 17-25, 2025. Each day unlocks automatically at midnight based on the user's local timezone.

## Files
- `christmas-countdown.html` - The complete countdown website (single file, easy to deploy)

## How to Use

### Deploy to Netlify
1. Upload `christmas-countdown.html` to your Netlify site
2. You can either:
   - Rename it to `index.html` to replace your current homepage
   - Keep it as `christmas-countdown.html` and access it at `iloveugo.com/christmas-countdown.html`
   - Create a subdomain like `christmas.iloveugo.com`

### Customize Messages
Open `christmas-countdown.html` in a text editor and find the **CONTENT DATA** section (around line 260). Edit the messages for each day:

```javascript
const adventData = [
    {
        day: 17,
        date: "December 17, 2025",
        title: "Day 1: The Beginning",
        message: "Your custom message here...",
        image: "" // Add image path when ready
    },
    // ... more days
];
```

### Add Photos
1. Create an `images` folder in your project
2. Add your photos (e.g., `day1.jpg`, `day2.jpg`)
3. Update the `image` field in the data:
   ```javascript
   {
       day: 17,
       title: "Day 1: The Beginning",
       message: "Your message...",
       image: "images/day1.jpg"  // <-- Add path here
   }
   ```

## Features

### Automatic Unlocking
- Days unlock automatically at midnight (user's local time)
- Future days show as locked "wrapped presents" with ribbons
- Past days remain accessible

### Responsive Design
- **Mobile**: Single column layout, optimized for phone viewing
- **Tablet**: 2-column grid
- **Desktop**: 3-column grid

### Interactive Elements
- Click any unlocked day to expand it full-width
- Snowfall animation in background
- Smooth hover effects
- Close button appears when expanded

### Visual Design
- Christmas colors: red, green, gold
- Locked presents: Gray with gold ribbons and lock icon
- Unlocked presents: Red/burgundy gradient with gold border
- Expanded view: Golden background with enhanced readability

## Customization Tips

### Change Colors
Find the CSS section and modify these values:
- Background: Line 12 `background: linear-gradient(...)`
- Card colors: Line 93 (unlocked) and Line 106 (locked)
- Gold accent: `#ffd700` throughout

### Adjust Animation Speed
Snowflake speed: Line 360 `animationDuration`

### Change Date Range
If you want different dates, update:
1. The `adventData` array with your dates
2. The `isDayUnlocked()` function logic (around line 335)

## Testing

### Test Before December 17
To test the functionality before the actual dates, temporarily modify the `isDayUnlocked()` function:

```javascript
function isDayUnlocked(day) {
    return true; // This unlocks ALL days for testing
}
```

**Remember to change it back before going live!**

### Test on Mobile
- Open Chrome DevTools (F12)
- Click the device toggle button
- Select "iPhone" or "iPad" to preview

## Deployment Checklist
- [ ] Customize all 9 messages with personal content
- [ ] Add photos (optional)
- [ ] Test on desktop browser
- [ ] Test on mobile device
- [ ] Verify date-locking logic is working
- [ ] Upload to Netlify
- [ ] Share the link with your girlfriend!

## Support
If you need to make changes:
1. Edit `christmas-countdown.html`
2. Save the file
3. Re-upload to Netlify (drag and drop into the deploys section)

The page automatically checks for newly unlocked days every minute, so visitors don't need to refresh manually (though a refresh works too).

---

Made with ❤️ for a special someone
