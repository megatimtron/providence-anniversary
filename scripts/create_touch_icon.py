#!/usr/bin/env python3

from PIL import Image
import os

def create_apple_touch_icon():
    """Create an Apple touch icon from ugo1.jpg"""
    
    # Check if ugo1.jpg exists
    if not os.path.exists('ugo1.jpg'):
        print("Error: ugo1.jpg not found!")
        return
    
    try:
        # Open the original image
        with Image.open('ugo1.jpg') as img:
            print(f"Original image size: {img.size}")
            
            # Convert to RGB if necessary (removes alpha channel)
            if img.mode in ('RGBA', 'LA'):
                # Create a white background
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'RGBA':
                    background.paste(img, mask=img.split()[-1])  # Use alpha channel as mask
                else:
                    background.paste(img)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            # Resize to 180x180 for Apple touch icon
            # Use LANCZOS for high-quality resizing
            touch_icon = img.resize((180, 180), Image.Resampling.LANCZOS)
            
            # Save as apple-touch-icon.png
            touch_icon.save('apple-touch-icon.png', 'PNG', optimize=True, quality=95)
            print("✅ Created apple-touch-icon.png (180x180)")
            
            # Also create a favicon.ico with multiple sizes
            # Create different sizes for the ico file
            sizes = [(16, 16), (32, 32), (48, 48)]
            favicon_images = []
            
            for size in sizes:
                resized = img.resize(size, Image.Resampling.LANCZOS)
                favicon_images.append(resized)
            
            # Save as favicon.ico with multiple sizes
            favicon_images[0].save('favicon.ico', format='ICO', sizes=[(16, 16), (32, 32), (48, 48)])
            print("✅ Created favicon.ico with multiple sizes")
            
            # Create additional PNG favicons
            img.resize((32, 32), Image.Resampling.LANCZOS).save('favicon-32x32.png', 'PNG')
            img.resize((16, 16), Image.Resampling.LANCZOS).save('favicon-16x16.png', 'PNG')
            print("✅ Created favicon-32x32.png and favicon-16x16.png")
            
            print("🎉 All icons created successfully!")
            
    except Exception as e:
        print(f"Error processing image: {e}")

if __name__ == "__main__":
    create_apple_touch_icon()
