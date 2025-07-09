# 💕 Providence Anniversary Weekend Planner

A beautiful, interactive web application designed for planning the perfect romantic anniversary weekend in Providence, Rhode Island.

## 📁 **Project Structure**

```
provitinerary/
├── 📄 index.html                    # Main anniversary website
├── 🔐 login.html                   # Romantic login page  
├── 📁 assets/                      # Media & Static Assets
│   ├── 🖼️ images/                  # Photos & Graphics
│   ├── 🎬 videos/                  # Video Content
│   └── 🎨 icons/                   # Favicons & App Icons
├── 📁 docs/                        # Documentation & References
├── 📁 scripts/                     # Python Automation Scripts
└── 📁 menus/                       # Restaurant Menus & Data
```

*See [docs/PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md) for complete directory details.*

## ✨ Features

### 🎵 **AI-Powered Playlist Builder** *(Phase 3 Complete)*
- **Activity-Based Playlists**: AI generates contextual music for dining, cruising, museum visits
- **Mood-Based Generation**: Romantic, adventurous, chill, and energetic playlist creation
- **Local Providence Music**: Discover artists like The Low Anthem, Lightning Bolt, Deer Tick
- **Real-Time Collaboration**: Live partner activity feed and synchronized playlist building
- **Advanced Sharing**: Export to Spotify, YouTube Music, Apple Music; share on social media

### 💕 **Song Memories Timeline** *(Phase 1 Complete)*
- Beautiful timeline of romantic songs with personal stories
- Multi-song support with add/edit/delete functionality
- Platform linking to Spotify, YouTube, Apple Music, etc.
- LocalStorage persistence and mobile-optimized interface

### 🔐 **Romantic Login Experience**
- Beautiful themed login page with floating hearts animation
- Demo authentication system (GitHub Pages compatible)
- Guest access option for easy sharing
- Romantic entrance that sets the mood for your anniversary planning

### ⏰ **Countdown Timer**
- Real-time countdown to your special anniversary date
- Customizable date picker with persistent storage
- Beautiful animated display

### 📅 **Interactive Itinerary Management**
- Dynamic day-by-day planning with full CRUD operations
- Drag-and-drop reordering of activities
- Modal-based editing with persistent storage
- Real-time notifications and beautiful animations

### 🍽️ **Restaurant Week Integration**
- Complete Providence Restaurant Week directory
- Real menu links and pricing information
- Google Maps and Uber integration for each restaurant
- Interactive filtering and search capabilities

### 🗺️ **Interactive Map & Weather**
- Leaflet-powered map with custom markers for restaurants and attractions
- Real-time weather integration for Providence
- User-generated points of interest
- Advanced filtering by category, price, and rating

### 📸 **Photo & Video Gallery**
- Browse Providence inspiration photos
- Upload and manage your personal memories
- Drag-and-drop photo upload functionality
- Video content with custom thumbnails and play overlays

### 💰 **Budget Calculator**
- Interactive cost estimator for two people
- Select activities to see real-time budget totals
- Helps plan within your desired spending range

### 📝 **Enhanced Notes System**
- Five different note sections with tabbed interface
- Writing prompts and auto-save functionality
- Character counter and beautiful styling
- Mobile-optimized with drag-and-drop photo integration

### 📱 **Mobile-Friendly Design**
- Fully responsive for all device sizes
- Touch-friendly interactions
- Beautiful typography and romantic color scheme

## 🎨 Design Features

- **Romantic Color Palette**: Warm terracotta and cream tones
- **Beautiful Typography**: Playfair Display and Roboto fonts
- **Smooth Animations**: Hover effects and transitions
- **Accessibility**: ARIA labels, keyboard navigation, focus styles
- **Modern UI**: Glassmorphism effects and gradient backgrounds

## 🚀 Live Demo

**Two Ways to Experience the Site:**

🔐 **Romantic Login Experience**: [https://megatimtron.github.io/providence-anniversary/login.html](https://megatimtron.github.io/providence-anniversary/login.html)
- Beautiful themed login page with floating hearts
- Demo authentication (enter any username/password)
- Guest access option for easy sharing
- Perfect romantic entrance to your anniversary site

💕 **Direct Access**: [https://megatimtron.github.io/providence-anniversary](https://megatimtron.github.io/providence-anniversary)
- Skip directly to the main anniversary planner
- All features immediately available
- Great for quick planning sessions

> **Tip**: Start with the login page for the full romantic experience, or use direct access when sharing with friends and family!

## 🛠️ Technology Stack

- **HTML5**: Semantic markup structure
- **CSS3**: Custom styling with Tailwind CSS
- **JavaScript**: Interactive functionality and data management
- **Chart.js**: Beautiful data visualizations
- **Local Storage**: Persistent data storage

## 📱 Browser Support

Works perfectly on:
- ✅ Chrome/Edge (recommended)
- ✅ Safari
- ✅ Firefox
- ✅ Mobile browsers

## 🔧 Setup & Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/megatimtron/providence-anniversary.git
   ```

2. **Open the application:**
   - **For the romantic login experience**: Open `login.html` in your browser
   - **For direct access**: Open `index.html` in your browser
   - Both work offline and require no server setup!

3. **For local development with live server:**
   ```bash
   python3 -m http.server 8000
   # Then visit:
   # http://localhost:8000/login.html (romantic entrance)
   # http://localhost:8000 (direct access)
   ```

## 🚀 Deployment

### Automated CI/CD Pipeline

The site uses GitHub Actions for automated deployment to both Netlify and the Raspberry Pi:

1. **Push to main branch** - Triggers the CI/CD pipeline
2. **Build & Test** - Validates HTML, minifies JavaScript, optimizes assets
3. **Deploy to Netlify** - Automatic deployment to https://iloveugo.com
4. **Deploy to Pi** - Secure deployment to Raspberry Pi server
5. **Verification** - Automatic rollback on failure

### Manual Deployment

For manual deployment, use the included deployment script:

```bash
# Make executable (first time only)
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

The deployment script:
- Builds and optimizes the site
- Creates backups
- Deploys to both Netlify and Raspberry Pi
- Provides rollback capability
- Includes comprehensive error handling

### Required Secrets

For GitHub Actions to work, configure these repository secrets:

- `NETLIFY_AUTH_TOKEN` - Your Netlify personal access token
- `NETLIFY_SITE_ID` - Your Netlify site ID
- `PI_SSH_KEY` - SSH private key for Raspberry Pi access
- `PI_HOST` - Raspberry Pi IP address or hostname
- `PI_USER` - SSH username for Raspberry Pi

### Raspberry Pi Setup

Use the included setup script to prepare your Raspberry Pi:

```bash
# On the Raspberry Pi
chmod +x setup-pi.sh
sudo ./setup-pi.sh
```

This configures Nginx, firewall, SSL certificates, and monitoring.

## 💕 Perfect For

- **Anniversary Celebrations**: Plan your special weekend together
- **Romantic Getaways**: Explore Providence's romantic side
- **Date Planning**: Interactive tools for memorable experiences
- **Memory Keeping**: Document your special moments

## 🌟 Highlights

- **GitHub Pages Ready**: Complete client-side application with romantic login
- **No Server Required**: Pure HTML/CSS/JavaScript with demo authentication
- **Two Entry Points**: Romantic login experience or direct access
- **Offline Capable**: Works without internet after initial load
- **Data Persistence**: Your notes and settings are saved locally
- **Print Friendly**: Beautiful layout for printing itineraries

## 📝 Customization

The application is easily customizable:
- Update the `AppData` object to change destinations, activities, or dates
- Modify CSS variables to change the color scheme
- Add new sections or features as needed

## 🤝 Contributing

This is a personal project, but feel free to fork it and create your own romantic planning application!

## 💖 About

Created with love for planning the perfect anniversary weekend in Providence, Rhode Island. This application combines practical planning tools with romantic design to help couples create unforgettable memories together.

---

*Built with 💕 for an amazing anniversary weekend*
