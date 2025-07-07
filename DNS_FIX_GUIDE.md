# 🔧 DNS Configuration for iloveugo.com → Netlify

## Quick Fix for Your DNS Verification Error

### Option 1: Use Netlify's Load Balancer (Recommended)
Set these DNS records at your domain registrar:

**A Records:**
- Name: `@` (or leave blank)
- Value: `75.2.60.5`
- TTL: 3600

**CNAME Record:**
- Name: `www`
- Value: `your-site-name.netlify.app` (replace with your actual Netlify URL)
- TTL: 3600

### Option 2: Use Netlify's Nameservers (Easier)
Instead of managing DNS records, you can use Netlify's nameservers:

1. In Netlify, go to **Domain settings** → **DNS panel**
2. Look for nameservers like:
   - `dns1.p01.nsone.net`
   - `dns2.p01.nsone.net`
   - `dns3.p01.nsone.net`
   - `dns4.p01.nsone.net`

3. At your domain registrar, change nameservers to these Netlify ones

### Step-by-Step for Common Registrars:

#### **Namecheap:**
1. Log into Namecheap
2. Go to **Domain List** → Click **Manage** next to iloveugo.com
3. Go to **Advanced DNS** tab
4. Add these records:
   - **A Record**: Host `@`, Value `75.2.60.5`
   - **CNAME**: Host `www`, Value `your-site.netlify.app`

#### **GoDaddy:**
1. Log into GoDaddy
2. Go to **My Products** → **DNS**
3. Click **Manage** next to iloveugo.com
4. Add the same A and CNAME records

### Verification Steps:
1. Wait 15-30 minutes after changing DNS
2. Go back to Netlify and click **"Retry DNS verification"**
3. Once verified, Netlify will automatically generate your SSL certificate

### Test Your Setup:
```bash
# Check if DNS is propagating (run on your Mac)
nslookup iloveugo.com
dig iloveugo.com
```

The DNS should show Netlify's IP address (75.2.60.5) when it's working correctly.

---

## ⏰ Timeline:
- **DNS changes**: 15 minutes - 4 hours to propagate
- **SSL certificate**: Automatic once DNS is verified
- **Site live**: Within 1-4 hours total

Your beautiful Providence Anniversary website will be live at https://iloveugo.com very soon! 🍓💕
