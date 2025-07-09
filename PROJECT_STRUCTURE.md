# 🏛️ Providence Anniversary App - Project Structure

## 📁 Core Files
- `index.html` - Main application with all features
- `sw.js` - Service worker for offline functionality
- `manifest.json` - PWA manifest
- `netlify.toml` - Netlify deployment configuration
- `.gitignore` - Git ignore rules

## 📁 Deployment
- `netlify-deploy/` - Production-ready package for Netlify
- `auto_sync_to_git.sh` - Automated deployment script
- `auto_deploy.sh` - Alternative deployment script
- `sync_to_pi.sh` - Direct Raspberry Pi sync script
- `cleanup_workspace.sh` - Workspace cleanup utility

## 📁 Assets
- `assets/` - Images, videos, JavaScript, and icons
- `menus/` - Restaurant menu PDFs
- `api/` - Backend API files (Flask app)

## 📁 Documentation
- `README.md` - Project overview and setup instructions
- `CURRENT_STATUS_UPDATE.md` - Current project status
- `PROVIDENCE_ANNIVERSARY_ITINERARY.txt` - Original itinerary text
- `documentation/` - Additional project documentation

## 🎯 Features
- ✅ Interactive itinerary with tabs and editing
- ✅ Photo upload and gallery for each day
- ✅ Love notes and romantic interactions
- ✅ Dating bubble notifications
- ✅ Restaurant information and menus
- ✅ Anniversary planning tools
- ✅ SoundCloud playlist integration
- ✅ Responsive design for all devices

## 🚀 Deployment Targets
- **Netlify**: https://iloveugo.com (production)
- **Raspberry Pi**: http://192.168.68.69 (local network)
- **GitHub**: Source code repository
