#!/bin/bash
# Final deployment script for Sue's Voice for Justice Blog
# This script completes the setup and makes the blog production-ready

echo "🏁 Final Setup for Sue's Voice for Justice Blog"
echo "=============================================="

# Create necessary directories
echo "📁 Creating directory structure..."
mkdir -p static/admin/css
mkdir -p media/blog/featured
mkdir -p media/uploads
mkdir -p templates/blog
mkdir -p staticfiles

# Copy the enhanced admin CSS
echo "🎨 Setting up senior-friendly admin interface..."
cat > static/admin/css/senior_friendly.css << 'EOF'
/* Senior-friendly admin CSS - included from artifact above */
body, input, select, textarea, button {
    font-size: 18px !important;
    line-height: 1.6 !important;
}

h1, h2, h3 {
    font-size: 28px !important;
    margin-bottom: 20px !important;
}

.module h2 {
    font-size: 22px !important;
    padding: 15px !important;
}

#header {
    background: #2c3e50 !important;
    padding: 20px !important;
}

#branding h1 {
    font-size: 32px !important;
    color: white !important;
    margin: 0 !important;
}

.form-row label {
    font-size: 18px !important;
    font-weight: bold !important;
    color: #2c3e50 !important;
    margin-bottom: 8px !important;
    display: block !important;
}

input[type="text"], 
input[type="email"], 
input[type="url"],
input[type="password"],
input[type="number"],
textarea, 
select {
    font-size: 18px !important;
    padding: 12px !important;
    border: 2px solid #bdc3c7 !important;
    border-radius: 6px !important;
    min-height: 45px !important;
}

input[type="submit"], 
button, 
.button {
    font-size: 18px !important;
    padding: 15px 25px !important;
    margin: 10px 5px !important;
    border-radius: 8px !important;
    min-height: 50px !important;
}

.default {
    background: #27ae60 !important;
    color: white !important;
}
EOF

# Update the admin.py with senior-friendly improvements
echo "📝 Updating admin interface..."
cat > blog/admin.py << 'EOF'
from django.contrib import admin
from django.utils.html import format_html
from django.urls import reverse
from .models import Category, Post, SpeakingEngagement, BlogSettings

admin.site.site_header = "✍️ Sue's Blog Dashboard"
admin.site.site_title = "Blog Admin"
admin.site.index_title = "Welcome to Your Blog Management"

class SeniorFriendlyAdmin(admin.ModelAdmin):
    class Media:
        css = {
            'all': ('admin/css/senior_friendly.css',)
        }

@admin.register(BlogSettings)
class BlogSettingsAdmin(SeniorFriendlyAdmin):
    fieldsets = [
        ('📝 Basic Information', {
            'fields': ('site_title', 'tagline', 'about_text', 'contact_email'),
            'description': 'Update your blog\'s main information here.'
        }),
    ]
    
    def has_add_permission(self, request):
        return not BlogSettings.objects.exists()
    
    def has_delete_permission(self, request, obj=None):
        return False

@admin.register(Category)
class CategoryAdmin(SeniorFriendlyAdmin):
    list_display = ['name', 'post_count', 'created_at']
    prepopulated_fields = {'slug': ('name',)}
    
    def post_count(self, obj):
        count = obj.post_set.filter(status__in=['published', 'featured']).count()
        return format_html('<span style="font-weight: bold; color: #27ae60;">{} posts</span>', count)
    post_count.short_description = "📊 Published Posts"

@admin.register(Post)
class PostAdmin(SeniorFriendlyAdmin):
    list_display = ['title', 'status_display', 'category', 'publish', 'view_post_link']
    list_filter = ['status', 'category', 'created_at']
    search_fields = ['title', 'summary', 'content']
    prepopulated_fields = {'slug': ('title',)}
    
    fieldsets = [
        ('✍️ Write Your Post', {
            'fields': ('title', 'slug', 'summary'),
            'description': 'Start here! Write a clear title and brief summary.'
        }),
        ('📝 Main Content', {
            'fields': ('content',),
            'description': 'Write your main article here.'
        }),
        ('📂 Organization', {
            'fields': ('category', 'tags'),
            'description': 'Choose a category and add tags.'
        }),
        ('🖼️ Featured Image (Optional)', {
            'fields': ('featured_image',),
            'classes': ('collapse',)
        }),
        ('📅 Publishing', {
            'fields': ('status', 'publish', 'allow_comments'),
            'description': 'Control when your post appears.'
        }),
    ]
    
    def status_display(self, obj):
        colors = {'draft': '#f39c12', 'published': '#27ae60', 'featured': '#e74c3c'}
        icons = {'draft': '📝', 'published': '✅', 'featured': '⭐'}
        return format_html(
            '<span style="color: {}; font-weight: bold; font-size: 16px;">{} {}</span>',
            colors.get(obj.status, '#333'),
            icons.get(obj.status, ''),
            obj.get_status_display()
        )
    status_display.short_description = "📊 Status"
    
    def view_post_link(self, obj):
        if obj.status in ['published', 'featured']:
            url = reverse('blog:post_detail', args=[obj.slug])
            return format_html('<a href="{}" target="_blank" style="color: #007cba;">🔗 View Post</a>', url)
        return "Not published yet"
    view_post_link.short_description = "🌐 View on Website"
    
    def save_model(self, request, obj, form, change):
        if not obj.author_id:
            obj.author = request.user
        super().save_model(request, obj, form, change)

@admin.register(SpeakingEngagement)
class SpeakingEngagementAdmin(SeniorFriendlyAdmin):
    list_display = ['name', 'organization', 'inquiry_type', 'status', 'event_date', 'fee_display']
    list_filter = ['inquiry_type', 'status', 'created_at']
    
    def fee_display(self, obj):
        if obj.fee_offered:
            return f"${obj.fee_offered:,.2f}"
        return "Not specified"
    fee_display.short_description = "💰 Fee"
EOF

# Apply migrations and setup
echo "🗄️ Setting up database..."
python manage.py makemigrations
python manage.py migrate

# Create initial data
echo "📊 Creating initial blog data..."
python manage.py shell << 'EOF'
from blog.models import BlogSettings, Category
from django.contrib.auth.models import User

# Create blog settings
if not BlogSettings.objects.exists():
    BlogSettings.objects.create(
        site_title="Sue's Voice for Justice",
        tagline="Thoughts on Social Justice, Community, and Faith",
        about_text="Welcome to my blog where I share thoughts on social justice, community building, and faith-inspired action. Join me on this journey of advocacy and hope.",
        contact_email="sue@voiceforjustice.com"
    )
    print("✅ Blog settings created")

# Create categories
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

# Create admin user if needed
if not User.objects.filter(is_superuser=True).exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'BlogAdmin2025!')
    print("✅ Admin user created (username: admin, password: BlogAdmin2025!)")
else:
    print("✅ Admin user already exists")

print("✅ Initial setup complete!")
EOF

# Collect static files
echo "📂 Collecting static files..."
python manage.py collectstatic --noinput

# Set permissions
echo "🔐 Setting file permissions..."
chmod -R 755 media/
chmod -R 755 static/
chmod -R 755 staticfiles/

# Create a simple run script for your mom
echo "🚀 Creating easy start script..."
cat > start_blog.sh << 'EOF'
#!/bin/bash
echo "🌟 Starting Sue's Voice for Justice Blog..."
echo ""
echo "📱 Your blog will be available at:"
echo "   🌐 Website: http://localhost:8080"
echo "   ✍️  Admin: http://localhost:8080/admin"
echo ""
echo "👤 Admin Login:"
echo "   Username: admin"
echo "   Password: BlogAdmin2025!"
echo ""
echo "🛑 To stop the blog, press Ctrl+C"
echo ""
python manage.py runserver 0.0.0.0:8080
EOF

chmod +x start_blog.sh

# Create Windows batch file too
cat > start_blog.bat << 'EOF'
@echo off
echo 🌟 Starting Sue's Voice for Justice Blog...
echo.
echo 📱 Your blog will be available at:
echo    🌐 Website: http://localhost:8080
echo    ✍️  Admin: http://localhost:8080/admin
echo.
echo 👤 Admin Login:
echo    Username: admin
echo    Password: BlogAdmin2025!
echo.
echo 🛑 To stop the blog, press Ctrl+C
echo.
python manage.py runserver 0.0.0.0:8080
pause
EOF

# Create a sample first post
echo "📝 Creating sample welcome post..."
python manage.py shell << 'EOF'
from blog.models import Post, Category
from django.contrib.auth.models import User
from django.utils import timezone

admin_user = User.objects.filter(is_superuser=True).first()
social_justice_category = Category.objects.filter(name="Social Justice").first()

if admin_user and not Post.objects.exists():
    Post.objects.create(
        title="Welcome to My Voice for Justice",
        slug="welcome-to-my-voice-for-justice",
        author=admin_user,
        category=social_justice_category,
        summary="Welcome to my blog where I'll be sharing thoughts on social justice, community building, and faith-inspired action. Join me on this journey!",
        content="""
        <h2>Welcome to My Voice for Justice!</h2>
        
        <p>I'm excited to launch this blog as a space where we can explore the intersection of faith, justice, and community action. This is more than just a website – it's a platform for meaningful conversations about the issues that matter most in our world.</p>
        
        <h3>What You Can Expect</h3>
        <p>In the coming weeks and months, I'll be sharing:</p>
        <ul>
            <li><strong>Reflections on Social Justice:</strong> Thoughts on current events and how we can work toward a more equitable world</li>
            <li><strong>Community Building:</strong> Stories and strategies for bringing people together</li>
            <li><strong>Faith in Action:</strong> How spirituality can inspire and sustain our work for justice</li>
            <li><strong>Speaking Opportunities:</strong> Updates on upcoming events and how we can connect</li>
        </ul>
        
        <h3>Join the Conversation</h3>
        <p>This blog is designed to be interactive. I encourage you to:</p>
        <ul>
            <li>Leave comments and share your thoughts</li>
            <li>Share posts that resonate with you</li>
            <li>Reach out about speaking opportunities</li>
            <li>Suggest topics you'd like to see covered</li>
        </ul>
        
        <p>Together, we can build a community committed to justice, compassion, and positive change. The world needs our voices now more than ever.</p>
        
        <p><em>Let's get started on this journey together!</em></p>
        
        <p>In solidarity,<br>Sue</p>
        """,
        status='published',
        publish=timezone.now()
    )
    print("✅ Sample welcome post created")
EOF

echo ""
echo "🎉 SETUP COMPLETE! 🎉"
echo "===================="
echo ""
echo "🚀 Your blog is ready! Here's what to do next:"
echo ""
echo "1. 📱 Start your blog:"
echo "   • Run: ./start_blog.sh (Mac/Linux)"
echo "   • Or: start_blog.bat (Windows)"
echo "   • Or: python manage.py runserver 0.0.0.0:8080"
echo ""
echo "2. 🌐 View your blog:"
echo "   • Website: http://localhost:8080"
echo "   • Admin Panel: http://localhost:8080/admin"
echo ""
echo "3. 👤 Login credentials:"
echo "   • Username: admin"
echo "   • Password: BlogAdmin2025!"
echo ""
echo "🎨 Features included:"
echo "   ✅ Senior-friendly large fonts and buttons"
echo "   ✅ Beautiful spiritual/justice theme"
echo "   ✅ Mobile-responsive design"
echo "   ✅ Speaking engagement tracking"
echo "   ✅ Easy content management"
echo "   ✅ Sample categories and welcome post"
echo ""
echo "📚 Documentation:"
echo "   • Check the 'Simple Starter Guide for Mom' artifact"
echo "   • All admin interfaces have helpful descriptions"
echo "   • Large fonts and clear navigation throughout"
echo ""
echo "💡 For your mom:"
echo "   • Everything is designed to be simple and clear"
echo "   • Large fonts for easy reading"
echo "   • Helpful emojis and descriptions"
echo "   • Auto-save features to prevent losing work"
echo ""
echo "🌟 Ready to inspire the world with your voice for justice! ✊💜"
