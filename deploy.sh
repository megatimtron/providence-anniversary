#!/bin/bash

# 🚀 Enhanced Production Deployment Script
# This script builds, optimizes, and deploys the Providence Anniversary site

set -e  # Exit on any error

# Configuration
PROJECT_NAME="Providence Anniversary"
PI_USER="timothytremaglio"
PI_HOST="192.168.68.69"
PI_PATH="/var/www/html"
BUILD_DIR="build"
BACKUP_DIR="backup"
NETLIFY_DIR="netlify-deploy"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
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

# Check dependencies
check_dependencies() {
    log "Checking dependencies..."
    
    # Check if Node.js is installed
    if ! command -v node &> /dev/null; then
        error "Node.js is required but not installed. Please install Node.js first."
    fi
    
    # Check if required tools are installed
    if ! command -v uglifyjs &> /dev/null; then
        log "Installing uglify-js..."
        npm install -g uglify-js
    fi
    
    if ! command -v cleancss &> /dev/null; then
        log "Installing clean-css-cli..."
        npm install -g clean-css-cli
    fi
    
    success "Dependencies check complete"
}

# Build the project
build_project() {
    log "Building project..."
    
    # Clean previous build
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    
    # Copy all files to build directory
    cp index.html "$BUILD_DIR/"
    cp manifest.json "$BUILD_DIR/"
    cp sw.js "$BUILD_DIR/"
    cp -r assets/ "$BUILD_DIR/"
    cp -r menus/ "$BUILD_DIR/"
    
    # Minify JavaScript
    log "Minifying JavaScript..."
    uglifyjs assets/js/providence-app.js -c -m -o "$BUILD_DIR/assets/js/providence-app.min.js"
    
    # Update HTML to use minified JS
    sed -i.bak 's/assets\/js\/providence-app.js/assets\/js\/providence-app.min.js/g' "$BUILD_DIR/index.html"
    rm "$BUILD_DIR/index.html.bak"
    
    # Extract and minify inline CSS if needed
    log "Optimizing CSS..."
    # This would extract CSS from HTML and minify it
    
    # Optimize images (if imagemin is available)
    if command -v imagemin &> /dev/null; then
        log "Optimizing images..."
        find "$BUILD_DIR/assets/images" -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" | xargs -I {} imagemin {} --out-dir="$BUILD_DIR/assets/images"
    fi
    
    # Update cache busting version
    CACHE_VERSION=$(date +%Y%m%d%H%M%S)
    sed -i.bak "s/force-deploy-[0-9]\+/force-deploy-$CACHE_VERSION/g" "$BUILD_DIR/index.html"
    rm "$BUILD_DIR/index.html.bak"
    
    success "Build complete"
}

# Test the build
test_build() {
    log "Testing build..."
    
    # Check if required files exist
    required_files=("index.html" "manifest.json" "sw.js" "assets/js/providence-app.min.js")
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$BUILD_DIR/$file" ]; then
            error "Required file $file not found in build"
        fi
    done
    
    # Test JavaScript syntax
    node -c "$BUILD_DIR/assets/js/providence-app.min.js"
    
    # Check for broken links (basic test)
    if grep -q "src=\"\"" "$BUILD_DIR/index.html"; then
        warning "Found empty src attributes in HTML"
    fi
    
    success "Build tests passed"
}

# Deploy to Raspberry Pi
deploy_to_pi() {
    log "Deploying to Raspberry Pi..."
    
    # Check if Pi is reachable
    if ! ping -c 1 "$PI_HOST" &> /dev/null; then
        error "Cannot reach Pi at $PI_HOST. Make sure you're on the same network and Pi is running."
    fi
    
    # Create backup on Pi
    log "Creating backup on Pi..."
    ssh "$PI_USER@$PI_HOST" "
        sudo mkdir -p $PI_PATH/backup
        sudo cp -r $PI_PATH/* $PI_PATH/backup/ 2>/dev/null || true
        echo 'Backup created'
    " || error "Failed to create backup on Pi"
    
    # Upload build to Pi
    log "Uploading files to Pi..."
    scp -r "$BUILD_DIR"/* "$PI_USER@$PI_HOST:/tmp/providence-deploy/" || error "Failed to upload files"
    
    # Move files to web directory
    log "Installing files on Pi..."
    ssh "$PI_USER@$PI_HOST" "
        sudo rm -rf $PI_PATH/index.html $PI_PATH/assets $PI_PATH/manifest.json $PI_PATH/sw.js $PI_PATH/menus
        sudo cp -r /tmp/providence-deploy/* $PI_PATH/
        sudo chown -R www-data:www-data $PI_PATH/
        sudo chmod -R 755 $PI_PATH/
        rm -rf /tmp/providence-deploy
        echo 'Files installed'
    " || error "Failed to install files on Pi"
    
    # Restart web server
    log "Restarting web server..."
    ssh "$PI_USER@$PI_HOST" "
        sudo systemctl restart nginx
        sudo systemctl restart apache2 2>/dev/null || true
        echo 'Web server restarted'
    " || warning "Web server restart may have failed"
    
    # Verify deployment
    log "Verifying deployment..."
    sleep 5
    
    if curl -f "http://$PI_HOST" > /dev/null 2>&1; then
        success "Pi deployment successful! Site is accessible at http://$PI_HOST"
    else
        error "Pi deployment verification failed. Rolling back..."
        ssh "$PI_USER@$PI_HOST" "
            sudo rm -rf $PI_PATH/*
            sudo cp -r $PI_PATH/backup/* $PI_PATH/
            sudo systemctl restart nginx
        "
        error "Deployment failed and rolled back"
    fi
}

# Deploy to Netlify
deploy_to_netlify() {
    log "Preparing Netlify deployment..."
    
    # Clean previous Netlify build
    rm -rf "$NETLIFY_DIR"
    mkdir -p "$NETLIFY_DIR"
    
    # Copy build to Netlify directory
    cp -r "$BUILD_DIR"/* "$NETLIFY_DIR/"
    
    # Create _redirects file for SPA routing
    cat > "$NETLIFY_DIR/_redirects" << EOF
# Redirect rules for Providence Anniversary site
/api/* http://192.168.68.69:8080/api/:splat 200
/* /index.html 200
EOF
    
    success "Netlify deployment package ready in $NETLIFY_DIR/"
    log "To deploy:"
    log "1. Go to https://app.netlify.com"
    log "2. Drag the $NETLIFY_DIR/ folder to deploy"
    log "3. Or set up Git integration for automatic deployments"
}

# Git operations
git_commit_and_push() {
    log "Committing changes to Git..."
    
    # Check if there are changes
    if git diff --quiet && git diff --cached --quiet; then
        warning "No changes detected to commit"
        return
    fi
    
    # Add all changes
    git add .
    
    # Get commit message
    echo "Enter commit message (or press Enter for default):"
    read -r commit_msg
    if [ -z "$commit_msg" ]; then
        commit_msg="Deploy $PROJECT_NAME - $(date '+%Y-%m-%d %H:%M')"
    fi
    
    # Commit changes
    git commit -m "$commit_msg"
    
    # Push to remote
    log "Pushing to remote repository..."
    git push origin main || warning "Failed to push to remote repository"
    
    success "Git operations complete"
}

# Main deployment flow
main() {
    echo -e "${BLUE}🚀 Starting Enhanced Deployment for $PROJECT_NAME${NC}"
    echo "=================================================="
    
    # Parse command line arguments
    DEPLOY_PI=false
    DEPLOY_NETLIFY=false
    SKIP_BUILD=false
    SKIP_GIT=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --pi)
                DEPLOY_PI=true
                shift
                ;;
            --netlify)
                DEPLOY_NETLIFY=true
                shift
                ;;
            --both)
                DEPLOY_PI=true
                DEPLOY_NETLIFY=true
                shift
                ;;
            --skip-build)
                SKIP_BUILD=true
                shift
                ;;
            --skip-git)
                SKIP_GIT=true
                shift
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --pi           Deploy to Raspberry Pi only"
                echo "  --netlify      Prepare Netlify deployment only"
                echo "  --both         Deploy to both Pi and Netlify"
                echo "  --skip-build   Skip the build process"
                echo "  --skip-git     Skip Git operations"
                echo "  --help         Show this help message"
                echo ""
                echo "If no options are specified, deploys to both Pi and Netlify"
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                ;;
        esac
    done
    
    # Default to both if no specific deployment target
    if [ "$DEPLOY_PI" = false ] && [ "$DEPLOY_NETLIFY" = false ]; then
        DEPLOY_PI=true
        DEPLOY_NETLIFY=true
    fi
    
    # Check dependencies
    check_dependencies
    
    # Build project
    if [ "$SKIP_BUILD" = false ]; then
        build_project
        test_build
    fi
    
    # Deploy to Pi
    if [ "$DEPLOY_PI" = true ]; then
        deploy_to_pi
    fi
    
    # Deploy to Netlify
    if [ "$DEPLOY_NETLIFY" = true ]; then
        deploy_to_netlify
    fi
    
    # Git operations
    if [ "$SKIP_GIT" = false ]; then
        git_commit_and_push
    fi
    
    echo ""
    echo -e "${GREEN}🎉 Deployment Complete!${NC}"
    echo "================================"
    if [ "$DEPLOY_PI" = true ]; then
        echo -e "${GREEN}🍓 Pi Server: http://$PI_HOST${NC}"
    fi
    if [ "$DEPLOY_NETLIFY" = true ]; then
        echo -e "${GREEN}🌐 Netlify: Ready to deploy at https://app.netlify.com${NC}"
    fi
    echo ""
    echo -e "${BLUE}💝 Your Providence Anniversary site is ready!${NC}"
}

# Run main function with all arguments
main "$@"
