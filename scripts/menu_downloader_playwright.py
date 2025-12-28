#!/usr/bin/env python3
"""
Restaurant Menu PDF Downloader using Playwright
Downloads and converts restaurant menus to PDF format
"""

import asyncio
import requests
import os
import csv
from playwright.async_api import async_playwright
import time
import re

def sanitize_filename(filename):
    """Sanitize filename for safe file system use"""
    # Remove invalid characters and replace spaces with underscores
    filename = re.sub(r'[<>:"/\\|?*]', '', filename)
    filename = re.sub(r'\s+', '_', filename.strip())
    return filename

def download_direct_pdf(url, filename):
    """Download a direct PDF file"""
    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        
        with open(filename, 'wb') as f:
            f.write(response.content)
        
        print(f"✅ Downloaded PDF: {filename}")
        return True
    except Exception as e:
        print(f"❌ Failed to download PDF {url}: {str(e)}")
        return False

async def convert_webpage_to_pdf(url, filename):
    """Convert a webpage to PDF using Playwright"""
    try:
        async with async_playwright() as p:
            # Launch browser in headless mode
            browser = await p.chromium.launch(headless=True)
            page = await browser.new_page()
            
            # Set viewport and user agent
            await page.set_viewport_size({"width": 1280, "height": 1024})
            
            print(f"🔄 Converting webpage to PDF: {url}")
            
            # Navigate to the page
            await page.goto(url, wait_until="networkidle", timeout=30000)
            
            # Wait for content to load
            await page.wait_for_timeout(3000)
            
            # Generate PDF with custom settings
            await page.pdf(
                path=filename,
                format="A4",
                margin={
                    "top": "0.5in",
                    "right": "0.5in", 
                    "bottom": "0.5in",
                    "left": "0.5in"
                },
                print_background=True,
                prefer_css_page_size=True
            )
            
            await browser.close()
            
        print(f"✅ Converted to PDF: {filename}")
        return True
        
    except Exception as e:
        print(f"❌ Failed to convert {url} to PDF: {str(e)}")
        return False

async def process_restaurant_menus():
    """Process all restaurant menus from the CSV file"""
    csv_file = '/Users/timothytremaglio/Library/Mobile Documents/com~apple~CloudDocs/Desktop/provitinerary/restaurants'
    menus_dir = '/Users/timothytremaglio/Library/Mobile Documents/com~apple~CloudDocs/Desktop/provitinerary/menus'
    
    # Ensure menus directory exists
    os.makedirs(menus_dir, exist_ok=True)
    
    success_count = 0
    total_count = 0
    
    try:
        with open(csv_file, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            
            for row in reader:
                restaurant_name = row['Restaurant Name'].strip()
                menu_link = row['Menu Link'].strip()
                menu_type = row['Menu Link Type'].strip()
                
                print(f"\n🍽️  Processing: {restaurant_name}")
                print(f"   Type: {menu_type}")
                print(f"   URL: {menu_link}")
                
                if menu_link == "No direct menu link found, pricing mentioned":
                    print(f"⚠️  Skipping {restaurant_name} - no direct menu link")
                    continue
                
                # Create safe filename
                safe_name = sanitize_filename(restaurant_name)
                filename = os.path.join(menus_dir, f"{safe_name}_menu.pdf")
                
                # Skip if file already exists
                if os.path.exists(filename):
                    print(f"✅ PDF already exists: {filename}")
                    success_count += 1
                    total_count += 1
                    continue
                
                total_count += 1
                
                # Check if it's a direct PDF link
                if menu_link.lower().endswith('.pdf'):
                    success = download_direct_pdf(menu_link, filename)
                else:
                    success = await convert_webpage_to_pdf(menu_link, filename)
                
                if success:
                    success_count += 1
                
                # Be nice to servers
                await asyncio.sleep(2)
        
        print(f"\n📊 Summary:")
        print(f"   Total processed: {total_count}")
        print(f"   Successful: {success_count}")
        print(f"   Failed: {total_count - success_count}")
        
    except Exception as e:
        print(f"❌ Error processing CSV file: {str(e)}")

async def main():
    print("🚀 Starting restaurant menu download process...")
    await process_restaurant_menus()
    print("✨ Done!")

if __name__ == "__main__":
    asyncio.run(main())
