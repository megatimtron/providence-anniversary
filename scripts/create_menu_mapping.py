#!/usr/bin/env python3
"""
Menu PDF Mapping and Website Updater
Creates mapping of restaurant names to PDF files and updates website links
"""

import os
import json
import re

def create_menu_mapping():
    """Create a mapping of restaurant names to PDF files"""
    menus_dir = '/Users/timothytremaglio/Library/Mobile Documents/com~apple~CloudDocs/Desktop/provitinerary/menus'
    
    # List all PDF files
    pdf_files = [f for f in os.listdir(menus_dir) if f.endswith('.pdf')]
    
    # Manual mapping to handle exact restaurant names from the website
    mapping = {}
    
    for pdf_file in pdf_files:
        # Remove _menu.pdf and convert back to restaurant name
        restaurant_key = pdf_file.replace('_menu.pdf', '').replace('_', ' ')
        
        # Manual corrections for website matching
        restaurant_corrections = {
            "Bacaro Restaurant": "Bacaro",
            "Barlino Restaurant Week Menu": "Bar'Lino Ristorante", 
            "Bellini": "Bellini",
            "Dolce Salato": "Dolce Salato",
            "Gracie's": "Gracie's",
            "Hemenway's Restaurant": "Hemenway's Restaurant",
            "Il Massimo": "Il Massimo",
            "Mare Rooftop": "Mare Rooftop",
            "Mill's Tavern": "Mill's Tavern",
            "Moonshine Alley": "Moonshine Alley",
            "New Rivers": "New Rivers",
            "Pizzico Oyster Bar": "Pizzico Oyster Bar",
            "Troop": "Troop"
        }
        
        # Use corrected name if available, otherwise use the processed name
        final_name = restaurant_corrections.get(restaurant_key, restaurant_key)
        mapping[final_name] = f"menus/{pdf_file}"
        
        print(f"✅ Mapped: {final_name} -> {pdf_file}")
    
    # Save mapping to JSON file for reference
    with open('/Users/timothytremaglio/Library/Mobile Documents/com~apple~CloudDocs/Desktop/provitinerary/menu_mapping.json', 'w') as f:
        json.dump(mapping, f, indent=2)
    
    print(f"\n📋 Created mapping for {len(mapping)} restaurants")
    return mapping

def print_menu_summary():
    """Print a summary of available menus"""
    mapping = create_menu_mapping()
    
    print("\n🍽️  Available Restaurant Menu PDFs:")
    print("=" * 50)
    
    for restaurant, pdf_path in sorted(mapping.items()):
        print(f"• {restaurant:<25} -> {pdf_path}")
    
    print(f"\n📊 Total: {len(mapping)} menu PDFs ready for website integration")

if __name__ == "__main__":
    print("🚀 Creating menu mapping...")
    print_menu_summary()
    print("✨ Done!")
