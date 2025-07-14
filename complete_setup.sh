#!/bin/bash
# Complete setup script for Sue's Voice for Justice Blog
# Run this to finish setting up the senior-friendly blog

echo "🚀 Completing blog setup for your mom..."

# 1. Install any missing dependencies
echo "📦 Installing required packages..."
pip install -r requirements.txt

# 2. Create and apply database migrations
echo "🗄️ Setting up database..."
python manage.py makemigrations
python manage.py migrate

# 3. Create initial blog settings
echo "⚙️ Creating initial blog settings..."
python manage.py shell << 'EOF'
from blog.models import BlogSettings, Category
import os

# Create blog settings if they don't exist
if not BlogSettings.objects.exists():
    settings = BlogSettings.objects.create(
        site_title="Sue's Voice for Justice",
        tagline="Thoughts on Social Justice, Community, and Faith",
        about_text="Welcome to my blog where I share thoughts on social justice, community building, and faith-inspired action. Join me on this journey of advocacy and hope.",
        contact_email="sue@example.com"
    )
    print("✅ Blog settings created")

# Create default categories
categories = [
    {"name": "Social Justice", "description": "Posts about fighting for equality and justice"},
    {"name": "Community", "description": "Building stronger communities together"},
    {"name": "Faith", "description": "Spiritual reflections and faith-based action"},
    {"name": "Speaking Events", "description": "Updates about speaking engagements"},
]

for cat_data in categories:
    category, created = Category.objects.get_or_create(
        name=cat_data["name"],
        defaults={
            "slug": cat_data["name"].lower().replace(" ", "-"),
            "description": cat_data["description"]
        }
    )
    if created:
        print(f"✅ Created category: {category.name}")

print("✅ Initial setup complete!")
EOF

# 4. Create superuser if it doesn't exist
echo "👤 Setting up admin user..."
python manage.py shell << 'EOF'
from django.contrib.auth.models import User

if not User.objects.filter(is_superuser=True).exists():
    print("Creating admin user...")
    print("Username: admin")
    print("Password: BlogAdmin2025!")
    User.objects.create_superuser('admin', 'admin@example.com', 'BlogAdmin2025!')
    print("✅ Admin user created")
else:
    print("✅ Admin user already exists")
EOF

# 5. Collect static files
echo "📂 Setting up static files..."
mkdir -p static/admin
python manage.py collectstatic --noinput

# 6. Create media directories
echo "📸 Setting up media directories..."
mkdir -p media/blog/featured
mkdir -p media/uploads

# 7. Set proper permissions
echo "🔐 Setting permissions..."
chmod -R 755 media/
chmod -R 755 static/

echo ""
echo "🎉 Setup Complete! Your blog is ready!"
echo ""
echo "📋 Quick Start Guide for Your Mom:"
echo "=================================="
echo ""
echo "1. 🚀 Start the blog:"
echo "   python manage.py runserver 0.0.0.0:8080"
echo ""
echo "2. 🌐 View the blog:"
echo "   http://localhost:8080"
echo ""
echo "3. ✍️ Write posts (Admin Panel):"
echo "   http://localhost:8080/admin"
echo "   Username: admin"
echo "   Password: BlogAdmin2025!"
echo ""
echo "4. 📝 To write a new post:"
echo "   - Go to Admin Panel"
echo "   - Click 'Posts' → 'Add Post'"
echo "   - Fill in title and content"
echo "   - Set status to 'Published'"
echo "   - Click 'Save'"
echo ""
echo "💡 Tips for your mom:"
echo "- The admin interface uses LARGE fonts"
echo "- All buttons have clear labels with emojis"
echo "- Posts auto-save as drafts"
echo "- Images are optional and easy to upload"
echo ""
echo "🎨 The blog features:"
echo "- Beautiful spiritual/justice theme"
echo "- Mobile-friendly design"
echo "- Speaking engagement tracking"
echo "- Newsletter signup"
echo "- Social media sharing"
echo ""
echo "Ready to inspire the world! ✊💜"
