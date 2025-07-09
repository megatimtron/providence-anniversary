#!/bin/bash

# 🔧 Complete Automation Setup Script for Providence Anniversary Site
# This script sets up full CI/CD automation for iloveugo.com

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOMAIN="iloveugo.com"
PROJECT_NAME="Providence Anniversary"

# Logging functions
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

# Header
echo -e "${BLUE}🚀 Setting up Complete Automation for ${PROJECT_NAME}${NC}"
echo -e "${BLUE}🌐 Domain: ${DOMAIN}${NC}"
echo ""

# Step 1: Check if we have a GitHub repository
log "Checking GitHub repository setup..."
if ! git remote get-url origin > /dev/null 2>&1; then
    warning "No GitHub remote found. Please create a GitHub repository first."
    echo ""
    echo -e "${YELLOW}To create a GitHub repository:${NC}"
    echo "1. Go to https://github.com/new"
    echo "2. Repository name: providence-anniversary"
    echo "3. Make it public (for free GitHub Actions)"
    echo "4. DON'T initialize with README (we already have files)"
    echo "5. Create repository"
    echo ""
    read -p "Enter your GitHub repository URL (e.g., https://github.com/username/providence-anniversary.git): " GITHUB_URL
    
    if [ -z "$GITHUB_URL" ]; then
        error "GitHub URL is required"
    fi
    
    git remote add origin "$GITHUB_URL"
    success "GitHub remote added"
fi

# Step 2: Check GitHub CLI installation
log "Checking GitHub CLI..."
if ! command -v gh &> /dev/null; then
    warning "GitHub CLI not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install gh
        else
            error "Please install Homebrew first: https://brew.sh/"
        fi
    else
        error "Please install GitHub CLI: https://cli.github.com/"
    fi
fi

# Step 3: GitHub Authentication
log "Checking GitHub authentication..."
if ! gh auth status > /dev/null 2>&1; then
    warning "Not authenticated with GitHub. Please authenticate..."
    gh auth login
fi

# Step 4: Create Netlify account and get tokens
log "Setting up Netlify integration..."
echo ""
echo -e "${YELLOW}📋 Netlify Setup Instructions:${NC}"
echo "1. Go to https://app.netlify.com/signup"
echo "2. Sign up or log in"
echo "3. Go to User Settings → Applications → Personal Access Tokens"
echo "4. Generate a new token with full access"
echo "5. Copy the token"
echo ""
read -p "Enter your Netlify Auth Token: " NETLIFY_AUTH_TOKEN

if [ -z "$NETLIFY_AUTH_TOKEN" ]; then
    error "Netlify Auth Token is required"
fi

echo ""
echo -e "${YELLOW}🌐 Create Netlify Site:${NC}"
echo "1. Go to https://app.netlify.com/sites"
echo "2. Click 'Add new site' → 'Deploy manually'"
echo "3. Drag any folder (we'll replace it with automation)"
echo "4. After deployment, go to Site Settings → General"
echo "5. Find 'Site information' → 'App ID'"
echo "6. Copy the Site ID"
echo ""
read -p "Enter your Netlify Site ID: " NETLIFY_SITE_ID

if [ -z "$NETLIFY_SITE_ID" ]; then
    error "Netlify Site ID is required"
fi

# Step 5: Configure custom domain
echo ""
echo -e "${YELLOW}🌐 Custom Domain Setup:${NC}"
echo "1. In Netlify, go to Site Settings → Domain management"
echo "2. Click 'Add custom domain'"
echo "3. Enter: $DOMAIN"
echo "4. Follow DNS configuration instructions"
echo "5. SSL will be automatically configured"
echo ""
read -p "Press Enter when domain is configured..."

# Step 6: Set up Pi server (optional)
log "Setting up Pi server integration..."
echo ""
echo -e "${YELLOW}🍓 Raspberry Pi Setup (Optional):${NC}"
echo "If you want to deploy to your Pi (192.168.68.69), we need SSH access."
echo ""
read -p "Do you want to set up Pi deployment? (y/N): " SETUP_PI

if [[ $SETUP_PI =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}SSH Key Setup:${NC}"
    echo "1. Generate SSH key: ssh-keygen -t rsa -b 4096 -C 'github-actions'"
    echo "2. Copy public key to Pi: ssh-copy-id timothytremaglio@192.168.68.69"
    echo "3. Test connection: ssh timothytremaglio@192.168.68.69"
    echo ""
    read -p "Enter path to private key (default: ~/.ssh/id_rsa): " SSH_KEY_PATH
    
    SSH_KEY_PATH=${SSH_KEY_PATH:-~/.ssh/id_rsa}
    
    if [ ! -f "$SSH_KEY_PATH" ]; then
        error "SSH key not found at $SSH_KEY_PATH"
    fi
    
    PI_SSH_KEY=$(cat "$SSH_KEY_PATH")
    PI_HOST="192.168.68.69"
    PI_USER="timothytremaglio"
else
    PI_SSH_KEY=""
    PI_HOST=""
    PI_USER=""
fi

# Step 7: Set GitHub secrets
log "Setting up GitHub secrets..."

# Set Netlify secrets
gh secret set NETLIFY_AUTH_TOKEN --body "$NETLIFY_AUTH_TOKEN"
gh secret set NETLIFY_SITE_ID --body "$NETLIFY_SITE_ID"
success "Netlify secrets configured"

# Set Pi secrets if enabled
if [[ $SETUP_PI =~ ^[Yy]$ ]]; then
    gh secret set PI_SSH_KEY --body "$PI_SSH_KEY"
    gh secret set PI_HOST --body "$PI_HOST"
    gh secret set PI_USER --body "$PI_USER"
    success "Pi secrets configured"
fi

# Step 8: Update deployment workflow if Pi is disabled
if [[ ! $SETUP_PI =~ ^[Yy]$ ]]; then
    log "Updating workflow to disable Pi deployment..."
    sed -i.bak 's/needs: \[deploy-netlify, deploy-pi\]/needs: [deploy-netlify]/' .github/workflows/deploy.yml
    sed -i.bak '/deploy-pi:/,/^$/d' .github/workflows/deploy.yml
    success "Workflow updated for Netlify-only deployment"
fi

# Step 9: Create a test deployment
log "Creating test deployment..."
git add .
git commit -m "Setup automation: Configure CI/CD pipeline for $DOMAIN" || true
git push origin main

success "🎉 Automation setup complete!"
echo ""
echo -e "${GREEN}🚀 Your automated deployment is now active!${NC}"
echo ""
echo -e "${BLUE}📋 What happens now:${NC}"
echo "• Every push to 'main' branch triggers automatic deployment"
echo "• Site builds, optimizes, and deploys to Netlify"
if [[ $SETUP_PI =~ ^[Yy]$ ]]; then
    echo "• Also deploys to your Raspberry Pi"
fi
echo "• Automatic rollback if deployment fails"
echo "• Build status notifications"
echo ""
echo -e "${BLUE}🌐 Your sites:${NC}"
echo "• Production: https://$DOMAIN"
echo "• Netlify: https://$NETLIFY_SITE_ID.netlify.app"
if [[ $SETUP_PI =~ ^[Yy]$ ]]; then
    echo "• Pi: http://$PI_HOST"
fi
echo ""
echo -e "${BLUE}📝 To deploy changes:${NC}"
echo "1. Make your changes"
echo "2. git add ."
echo "3. git commit -m 'Your changes'"
echo "4. git push origin main"
echo "5. ✨ Automatic deployment!"
echo ""
echo -e "${GREEN}🎊 No more drag and drop - everything is automated!${NC}"
