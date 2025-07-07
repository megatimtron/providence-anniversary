# 🍓 Simple Manual Deployment - Providence Anniversary Website

## 🚀 **Easy Deployment (Manual Password)**

Since automatic passwords don't work in your terminal, use these scripts that prompt for password manually:

### **First Time Setup:**
```bash
./deploy_manual.sh
```

### **Quick Updates:**
```bash
./quick_deploy_manual.sh
```

---

## 📋 **Step-by-Step:**

### **1. Run the deployment script:**
```bash
./deploy_manual.sh
```

### **2. Enter password when prompted:**
You'll be asked 3 times for your password: `Fratesi7!`
- **First time:** Setting up nginx web server
- **Second time:** Copying website files  
- **Third time:** Final configuration

### **3. Watch the progress:**
The script will show:
- ✅ Pi connection test
- 🔧 Setting up nginx
- 📁 Copying files
- 🔐 Setting permissions
- 🧪 Testing website

### **4. Visit your website:**
```
http://192.168.68.69
```

---

## 💡 **Why This Works Better:**

- ✅ **Manual password entry** - just like your regular terminal
- ✅ **No sshpass needed** - uses standard SSH
- ✅ **Clear prompts** - you know when to enter password
- ✅ **Same functionality** - sets up everything perfectly
- ✅ **Beautiful output** - colored progress messages

---

## 🔄 **For Future Updates:**

After the first setup, just use:
```bash
./quick_deploy_manual.sh
```
This only asks for password once and updates everything quickly!

---

## 🎯 **What You'll Get:**

Your beautiful Providence Anniversary website with:
- 💕 Original romantic colors (reverted from high contrast)
- 🎮 All buttons working perfectly
- 🗺️ Interactive map functionality
- 📱 Mobile-optimized design
- 🍽️ Restaurant recommendations
- 📅 Trip planning tools
- 🎵 Music memories section

---

## ✨ **Ready to Deploy?**

Just run:
```bash
./deploy_manual.sh
```

Enter your password when prompted, and in a few minutes you'll have your romantic Providence website running on your Pi! 💕🍓
