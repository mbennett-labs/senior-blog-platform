#!/bin/bash
# Complete setup script for senior-friendly blog interface

echo "🚀 Setting up senior-friendly blog interface..."

# Install additional packages
pip install django-colorfield pillow

# Create enhanced models
cp blog/models.py blog/models_backup.py

cat > blog/models.py << 'EOF'
from django.db import models
from django.contrib.auth.models import User
from django.urls import reverse
from django.utils import timezone
from ckeditor_uploader.fields import RichTextUploadingField
from taggit.managers import TaggableManager

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True, 
                          help_text="Category name (e.g., 'Social Justice', 'Community')")
    slug = models.SlugField(max_length=100, unique=True,
                           help_text="URL-friendly version (auto-generated)")
    description = models.TextField(blank=True, 
                                 help_text="Brief description of this category")
    color = models.CharField(max_length=7, default="#3498db",
                           help_text="Category color for visual organization")
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        verbose_name_plural = "Categories"
        ordering = ['name']
    
    def __str__(self):
        return self.name

class Post(models.Model):
    STATUS_CHOICES = [
        ('draft', '📝 Draft - Not published yet'),
        ('published', '✅ Published - Live on website'),
        ('featured', '⭐ Featured - Highlighted on homepage'),
    ]
    
    title = models.CharField(max_length=200, 
                           help_text="Clear, engaging title for your post")
    slug = models.SlugField(max_length=200, unique_for_date='publish',
                           help_text="URL-friendly version (auto-generated)")
    author = models.ForeignKey(User, on_delete=models.CASCADE, 
                             related_name='blog_posts')
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, 
                               null=True, blank=True,
                               help_text="Choose a category for organization")
    
    summary = models.TextField(max_length=300, 
                             help_text="Brief summary (2-3 sentences) for previews and social media")
    content = RichTextUploadingField(
        help_text="Your main article content. Use the toolbar for formatting, images, and links."
    )
    featured_image = models.ImageField(
        upload_to='blog/featured/', 
        blank=True, 
        null=True,
        help_text="Optional: Upload a main image for your post"
    )
    
    tags = TaggableManager(
        blank=True, 
        help_text="Add tags separated by commas (e.g., social-justice, community, faith)"
    )
    
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='draft')
    publish = models.DateTimeField(
        default=timezone.now,
        help_text="When to publish this post (can be set for future)"
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    meta_description = models.CharField(
        max_length=160, 
        blank=True,
        help_text="Optional: Description for Google search results (160 characters max)"
    )
    
    allow_comments = models.BooleanField(
        default=True, 
        help_text="Allow readers to comment on this post"
    )
    
    class Meta:
        ordering = ['-publish']
    
    def __str__(self):
        return self.title
    
    def is_published(self):
        return self.status in ['published', 'featured'] and self.publish <= timezone.now()

class SpeakingEngagement(models.Model):
    INQUIRY_TYPES = [
        ('speaking', '🎤 Speaking Engagement'),
        ('interview', '📺 Interview/Podcast'),
        ('workshop', '👥 Workshop/Training'),
        ('consultation', '💬 Consultation'),
        ('writing', '✍️ Writing/Guest Post'),
    ]
    
    STATUS_CHOICES = [
        ('new', '📩 New Inquiry'),
        ('contacted', '📞 Initial Contact Made'),
        ('discussing', '💬 In Discussion'),
        ('scheduled', '📅 Scheduled'),
        ('completed', '✅ Completed'),
        ('declined', '❌ Declined'),
    ]
    
    name = models.CharField(max_length=100, help_text="Contact person's name")
    email = models.EmailField(help_text="Contact email")
    organization = models.CharField(max_length=200, blank=True, help_text="Organization name")
    inquiry_type = models.CharField(max_length=20, choices=INQUIRY_TYPES)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='new')
    event_date = models.DateField(null=True, blank=True, help_text="Proposed event date")
    fee_offered = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True,
                                    help_text="Speaking fee offered (if any)")
    message = models.TextField(help_text="Original inquiry message")
    notes = models.TextField(blank=True, help_text="Your follow-up notes")
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f'{self.get_inquiry_type_display()} from {self.name}'

class BlogSettings(models.Model):
    site_title = models.CharField(max_length=100, default="My Blog",
                                help_text="Your blog's main title")
    tagline = models.CharField(max_length=200, 
                             default="Thoughts on social justice, community, and faith",
                             help_text="Brief description of your blog")
    about_text = models.TextField(help_text="About section text for your blog")
    contact_email = models.EmailField(help_text="Contact email displayed on your blog")
    
    class Meta:
        verbose_name = "Blog Settings"
        verbose_name_plural = "Blog Settings"
    
    def __str__(self):
        return f"Settings for {self.site_title}"
EOF

echo "✅ Enhanced models created."

# Create enhanced admin
cat > blog/admin.py << 'EOF'
from django.contrib import admin
from django.utils.html import format_html
from .models import Category, Post, SpeakingEngagement, BlogSettings

admin.site.site_header = "✍️ My Blog Dashboard"
admin.site.site_title = "Blog Admin"
admin.site.index_title = "Welcome to Your Blog Management"

@admin.register(BlogSettings)
class BlogSettingsAdmin(admin.ModelAdmin):
    fieldsets = [
        ('Basic Information', {
            'fields': ('site_title', 'tagline', 'about_text', 'contact_email'),
        }),
    ]
    
    def has_add_permission(self, request):
        return not BlogSettings.objects.exists()

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'post_count', 'created_at']
    prepopulated_fields = {'slug': ('name',)}
    
    def post_count(self, obj):
        count = obj.post_set.filter(status__in=['published', 'featured']).count()
        return f"{count} posts"
    post_count.short_description = "Published Posts"

@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ['title', 'status_display', 'category', 'publish']
    list_filter = ['status', 'category', 'created_at']
    search_fields = ['title', 'summary', 'content']
    prepopulated_fields = {'slug': ('title',)}
    
    fieldsets = [
        ('✍️ Write Your Post', {
            'fields': ('title', 'slug', 'summary'),
        }),
        ('📝 Content', {
            'fields': ('content',),
        }),
        ('📂 Organization', {
            'fields': ('category', 'tags'),
        }),
        ('🖼️ Featured Image', {
            'fields': ('featured_image',),
            'classes': ('collapse',)
        }),
        ('📅 Publishing', {
            'fields': ('status', 'publish', 'allow_comments'),
        }),
    ]
    
    def status_display(self, obj):
        colors = {'draft': '#f39c12', 'published': '#27ae60', 'featured': '#e74c3c'}
        return format_html(
            '<span style="color: {}; font-weight: bold;">{}</span>',
            colors.get(obj.status, '#333'),
            obj.get_status_display()
        )
    status_display.short_description = "Status"

@admin.register(SpeakingEngagement)
class SpeakingEngagementAdmin(admin.ModelAdmin):
    list_display = ['name', 'organization', 'inquiry_type', 'status', 'event_date', 'fee_display']
    list_filter = ['inquiry_type', 'status', 'created_at']
    
    def fee_display(self, obj):
        if obj.fee_offered:
            return f"${obj.fee_offered:,.2f}"
        return "Not specified"
    fee_display.short_description = "Fee"
EOF

echo "✅ Enhanced admin interface created."

# Create migrations and apply them
python manage.py makemigrations blog
python manage.py migrate

echo ""
echo "🎉 Setup complete! Your senior-friendly blog is ready!"
echo ""
echo "Next steps:"
echo "1. Start Django: python manage.py runserver 0.0.0.0:8080"
echo "2. Visit http://69.62.69.140:8080/admin"
echo "3. Add blog settings and create your first post"
echo ""
echo "Your mother will love the large fonts and simple interface! 👵✍️"
EOF
