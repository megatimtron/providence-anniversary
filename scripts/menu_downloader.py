#!/usr/bin/env python3
"""
Restaurant Menu PDF Downloader
Downloads and converts restaurant menus to PDF format
"""

import requests
import os
import csv
from weasyprint import HTML, CSS
from urllib.parse import urljoin, urlparse
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

def convert_webpage_to_pdf(url, filename):
    """Convert a webpage to PDF using WeasyPrint"""
    try:
        # Custom CSS for better PDF formatting
        pdf_css = CSS(string='''
            @page {
                size: A4;
                margin: 1cm;
            }
            body {
                font-family: Arial, sans-serif;
                line-height: 1.4;
                font-size: 12px;
            }
            .menu-item {
                margin-bottom: 10px;
            }
            .price {
                font-weight: bold;
            }
            nav, header, footer, .navigation, .navbar, .header, .footer {
                display: none !important;
            }
            .menu-section {
                page-break-inside: avoid;
            }
        ''')
        
        print(f"🔄 Converting webpage to PDF: {url}")
        
        # Create HTML object and write to PDF
        html = HTML(url=url)
        html.write_pdf(filename, stylesheets=[pdf_css])
        
        print(f"✅ Converted to PDF: {filename}")
        return True
        
    except Exception as e:
        print(f"❌ Failed to convert {url} to PDF: {str(e)}")
        return False

def process_restaurant_menus():
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
                    success = convert_webpage_to_pdf(menu_link, filename)
                
                if success:
                    success_count += 1
                
                # Be nice to servers
                time.sleep(2)
        
        print(f"\n📊 Summary:")
        print(f"   Total processed: {total_count}")
        print(f"   Successful: {success_count}")
        print(f"   Failed: {total_count - success_count}")
        
    except Exception as e:
        print(f"❌ Error processing CSV file: {str(e)}")

if __name__ == "__main__":
    print("🚀 Starting restaurant menu download process...")
    process_restaurant_menus()
    print("✨ Done!")
