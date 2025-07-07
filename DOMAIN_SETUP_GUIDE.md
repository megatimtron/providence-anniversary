# 🌐 iloveugo.com Domain Setup Guide

## Option A: Point Domain to Your Raspberry Pi (FREE hosting)

### Step 1: Buy the Domain
1. Go to **Namecheap.com** or your preferred registrar
2. Search for `iloveugo.com`
3. Purchase the domain (usually $10-15/year)

### Step 2: Find Your Home IP Address
```bash
# Run this on your Mac to find your public IP
curl ifconfig.me
```

### Step 3: Configure Your Router
1. Open your router admin panel (usually http://192.168.1.1 or http://192.168.0.1)
2. Look for "Port Forwarding" or "Virtual Server"
3. Add this rule:
   - **Service Name**: Web Server
   - **External Port**: 80
   - **Internal IP**: 192.168.68.69 (your Pi's IP)
   - **Internal Port**: 80
   - **Protocol**: TCP

### Step 4: Set Up DNS Records
In your domain registrar's control panel:

**A Record:**
- **Name**: @ (or leave blank)
- **Value**: [Your public IP from Step 2]
- **TTL**: 3600

**CNAME Record:**
- **Name**: www
- **Value**: iloveugo.com
- **TTL**: 3600

### Step 5: Update Nginx on Pi
```bash
ssh timothytremaglio@192.168.68.69

# Edit nginx config
sudo nano /etc/nginx/sites-available/provitinerary
```

Change the server_name line to:
```nginx
server_name iloveugo.com www.iloveugo.com;
```

Then restart nginx:
```bash
sudo systemctl restart nginx
```

---

## Option B: Cloud Hosting (Professional Setup)

### Recommended Providers:
1. **Netlify** (FREE for static sites!)
2. **Vercel** (FREE for static sites!)
3. **GitHub Pages** (FREE)
4. **DigitalOcean** ($5/month)
5. **AWS S3 + CloudFront** ($1-3/month)

### Best Option: Netlify (FREE)

#### Step 1: Prepare Your Site
```bash
# Create a clean version without Pi-specific files
cd /Users/timothytremaglio/Downloads/provitinerary
mkdir netlify-deploy
cp index.html login.html netlify-deploy/
cp -r assets netlify-deploy/
cp -r menus netlify-deploy/
cd netlify-deploy
```

#### Step 2: Deploy to Netlify
1. Go to **netlify.com**
2. Sign up with GitHub/Google
3. Drag your `netlify-deploy` folder to Netlify
4. Your site will get a random URL like `magical-unicorn-123.netlify.app`

#### Step 3: Connect Your Domain
1. In Netlify dashboard, go to **Domain settings**
2. Click **Add custom domain**
3. Enter `iloveugo.com`
4. Netlify will give you DNS settings to configure

#### Step 4: Configure DNS
In your domain registrar, set these DNS records:
- **A Record**: @ → 75.2.60.5
- **CNAME**: www → [your-site-name].netlify.app

---

## 🎯 **Which Option Should You Choose?**

### Choose **Option A (Pi + Domain)** if:
- ✅ You want FREE hosting forever
- ✅ You like controlling your own server
- ✅ Your internet is reliable
- ✅ You don't mind router configuration

### Choose **Option B (Cloud Hosting)** if:
- ✅ You want professional reliability
- ✅ You want it to "just work"
- ✅ You don't want to configure your router
- ✅ You want global CDN speed

---

## 🚀 **Quick Start Recommendation**

**Start with Option B (Netlify)** because:
- It's FREE
- Takes 5 minutes to set up
- Professional and reliable
- You can always move to the Pi later

Would you like me to help you deploy to Netlify first?
