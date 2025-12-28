# 📁 **Providence Anniversary Website - Project Structure**

## **🏗️ Organized Directory Layout**

```
provitinerary/
├── 📄 index.html                    # Main anniversary website
├── 🔐 login.html                   # Romantic login page
├── 📖 README.md                    # Project overview & setup
├── 🛠️ .gitignore                   # Git ignore rules
│
├── 📁 assets/                      # Media & Static Assets
│   ├── 🖼️ images/                  # Photos & Graphics
│   │   ├── ugo1.jpg               # Hero background image
│   │   ├── ugo2.jpg               # Secondary image
│   │   ├── memory-video-thumbnail.jpg # Video thumbnail
│   │   └── test-photo.jpg         # Test/sample image
│   │
│   ├── 🎬 videos/                  # Video Content
│   │   ├── memory-video.mp4       # Anniversary memory video
│   │   └── kiss-boomerang.mp4     # Boomerang-style video
│   │
│   └── 🎨 icons/                   # Favicons & App Icons
│       ├── favicon.ico             # Standard favicon
│       ├── favicon.svg             # Vector favicon
│       ├── favicon-alt.svg         # Alternative vector favicon
│       ├── favicon-16x16.png       # 16x16 favicon
│       ├── favicon-32x32.png       # 32x32 favicon
│       └── apple-touch-icon.png    # iOS/Apple touch icon
│
├── 📁 docs/                        # Documentation & References
│   ├── 📋 PHASE1_COMPLETE_SONG_MEMORIES.md      # Phase 1 completion doc
│   ├── 🤖 PHASE3_COMPLETE_AI_PLAYLISTS.md       # Phase 3 completion doc
│   ├── 🗺️ ROADMAP_PLAYLIST_INTEGRATION.md       # Integration roadmap
│   ├── 🧠 gemini_improvements117               # AI improvement suggestions
│   ├── 💬 chat-formatter.html                 # Chat formatting tool
│   ├── 📜 complete_chat_messages.html          # Complete chat history
│   └── 💕 our-chat-history.html               # Processed chat history
│
├── 📁 scripts/                     # Python Automation Scripts
│   ├── 🔍 advanced_chat_ocr.py               # Advanced OCR for chat screenshots
│   ├── 📱 chat_ocr_extractor.py              # Basic chat OCR extraction
│   ├── 🎨 create_touch_icon.py               # Icon generation script
│   ├── 📋 create_menu_mapping.py             # Menu mapping creation
│   ├── 💬 focused_chat_processor.py          # Focused chat processing
│   ├── ✋ manual_chat_processor.py            # Manual chat processing
│   ├── 🍽️ menu_downloader.py                 # Menu PDF downloader
│   ├── 🎭 menu_downloader_playwright.py      # Playwright menu downloader
│   ├── 📊 process_ocr_results.py             # OCR result processing
│   ├── 🎬 process_video_ocr.py               # Video OCR processing
│   ├── 📥 regular_menu_downloader.py         # Regular menu downloader
│   ├── 🔧 simple_chat_processor.py           # Simple chat processing
│   └── 📹 video_chat_extractor.py            # Video chat extraction
│
├── 📁 menus/                       # Restaurant Menus & Data
│   ├── 📊 menu_mapping.json                  # Menu URL mappings
│   ├── 📋 restaurants                        # Restaurant list
│   ├── 📝 regularmenus.txt                   # Regular menu URLs
│   │
│   └── 📄 [Restaurant PDFs]/                 # Menu PDFs
│       ├── Gracie's_menu.pdf
│       ├── Hemenway's_Restaurant_menu.pdf
│       ├── Mill's_Tavern_menu.pdf
│       └── [30+ other restaurant menus]
│
└── 📁 .venv/                       # Python Virtual Environment
    ├── bin/                        # Python binaries
    ├── lib/                        # Python libraries
    └── pyvenv.cfg                  # Environment configuration
```

---

## **🎯 File Categories & Purposes**

### **🌐 Core Website Files**
- **`index.html`**: The main Providence Anniversary website with all features
- **`login.html`**: Romantic login page for personalized access
- **`README.md`**: Project documentation and setup instructions

### **🎨 Assets Organization**
- **`assets/images/`**: All photos, graphics, and visual content
- **`assets/videos/`**: Anniversary videos and multimedia content  
- **`assets/icons/`**: Favicons and app icons for various devices

### **📚 Documentation Hub**
- **`docs/`**: All project documentation, phase completion summaries, and reference materials
- **Phase completion docs**: Track progress through playlist builder development
- **Chat processing files**: Dating history integration tools

### **🛠️ Automation Scripts**
- **`scripts/`**: Python scripts for menu downloading, OCR processing, and content automation
- **Menu automation**: Download and process restaurant menu PDFs
- **Chat processing**: Extract and format dating history from various sources
- **Icon generation**: Create optimized favicons and touch icons

### **🍽️ Restaurant Data**
- **`menus/`**: Restaurant menu PDFs, mappings, and data files
- **30+ menu PDFs**: Complete collection of Providence Restaurant Week menus
- **Data files**: Restaurant listings, URLs, and mapping configurations

---

## **🚀 Key Features by Directory**

### **Root Level** (`/`)
- Complete romantic anniversary website
- AI-powered playlist builder (Phases 1-3)
- Restaurant Week integration
- Interactive itinerary management
- Budget calculator & planning tools

### **Assets** (`/assets/`)
- Optimized media content
- Multi-format favicon support
- High-quality anniversary photos and videos
- Responsive image assets

### **Documentation** (`/docs/`)
- Complete development history
- Phase-by-phase implementation guides
- AI improvement suggestions
- Dating history integration tools

### **Scripts** (`/scripts/`)
- OCR and text extraction automation
- Menu PDF downloading and processing
- Icon generation and optimization
- Chat history formatting tools

### **Menus** (`/menus/`)
- Comprehensive Providence Restaurant Week data
- PDF menu collection with direct download links
- Restaurant metadata and categorization

---

## **🧹 Cleanup Benefits**

### **✅ Improved Organization**
- **Clear separation** of code, assets, docs, and scripts
- **Easy navigation** for developers and collaborators
- **Logical grouping** of related files

### **✅ Better Maintainability**
- **Focused directories** for specific file types
- **Reduced root clutter** for cleaner project overview
- **Standardized structure** following best practices

### **✅ Enhanced Development**
- **Quick file location** with intuitive folder names
- **Scalable structure** for future features
- **Professional organization** for portfolio presentation

---

**🎉 The Providence Anniversary project is now beautifully organized with a clean, professional structure that makes development, maintenance, and collaboration much more efficient!**
