# blog/admin.py - Enhanced admin interface for seniors

from django.contrib import admin
from django.utils.html import format_html
from django.urls import reverse
from .models import Category, Post, SpeakingEngagement, BlogSettings

# Customize admin site headers
admin.site.site_header = "✍️ Sue's Blog Dashboard"
admin.site.site_title = "Blog Admin"
admin.site.index_title = "Welcome to Your Blog Management"

# Add custom CSS for larger fonts and better visibility
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
            'description': 'Update your blog\'s main information here. These appear on your website.'
        }),
    ]
    
    def has_add_permission(self, request):
        # Only allow one settings object
        return not BlogSettings.objects.exists()
    
    def has_delete_permission(self, request, obj=None):
        # Don't allow deleting blog settings
        return False

@admin.register(Category)
class CategoryAdmin(SeniorFriendlyAdmin):
    list_display = ['name', 'post_count', 'description_preview', 'created_at']
    prepopulated_fields = {'slug': ('name',)}
    fields = ['name', 'slug', 'description', 'color']
    
    def post_count(self, obj):
        count = obj.post_set.filter(status__in=['published', 'featured']).count()
        return format_html(
            '<span style="font-size: 16px; font-weight: bold; color: #27ae60;">{} posts</span>',
            count
        )
    post_count.short_description = "📊 Published Posts"
    
    def description_preview(self, obj):
        if obj.description:
            preview = obj.description[:50] + "..." if len(obj.description) > 50 else obj.description
            return format_html('<span style="font-style: italic;">{}</span>', preview)
        return "No description"
    description_preview.short_description = "📄 Description"

@admin.register(Post)
class PostAdmin(SeniorFriendlyAdmin):
    list_display = ['title', 'status_display', 'category', 'publish_date', 'view_post_link']
    list_filter = ['status', 'category', 'created_at']
    search_fields = ['title', 'summary', 'content']
    prepopulated_fields = {'slug': ('title',)}
    date_hierarchy = 'publish'
    
    fieldsets = [
        ('✍️ Write Your Post', {
            'fields': ('title', 'slug', 'summary'),
            'description': 'Start here! Write a clear title and brief summary of your post.'
        }),
        ('📝 Main Content', {
            'fields': ('content',),
            'description': 'Write your main article here. Use the toolbar for formatting.'
        }),
        ('📂 Organization', {
            'fields': ('category', 'tags'),
            'description': 'Choose a category and add tags to help readers find your post.'
        }),
        ('🖼️ Featured Image (Optional)', {
            'fields': ('featured_image',),
            'classes': ('collapse',),
            'description': 'Upload a main image for your post (optional).'
        }),
        ('📅 Publishing Options', {
            'fields': ('status', 'publish', 'allow_comments'),
            'description': 'Control when and how your post appears on the website.'
        }),
        ('🔍 SEO (Advanced - Optional)', {
            'fields': ('meta_description',),
            'classes': ('collapse',),
            'description': 'Advanced options for search engines.'
        }),
    ]
    
    def status_display(self, obj):
        colors = {
            'draft': '#f39c12',
            'published': '#27ae60',
            'featured': '#e74c3c'
        }
        icons = {
            'draft': '📝',
            'published': '✅',
            'featured': '⭐'
        }
        return format_html(
            '<span style="color: {}; font-weight: bold; font-size: 16px;">{} {}</span>',
            colors.get(obj.status, '#333'),
            icons.get(obj.status, ''),
            obj.get_status_display()
        )
    status_display.short_description = "📊 Status"
    
    def publish_date(self, obj):
        return format_html(
            '<span style="font-size: 14px;">{}</span>',
            obj.publish.strftime('%B %d, %Y at %I:%M %p')
        )
    publish_date.short_description = "📅 Publish Date"
    
    def view_post_link(self, obj):
        if obj.status in ['published', 'featured']:
            url = reverse('blog:post_detail', args=[obj.slug])
            return format_html(
                '<a href="{}" target="_blank" style="color: #007cba; font-weight: bold;">🔗 View Post</a>',
                url
            )
        return "Not published yet"
    view_post_link.short_description = "🌐 View on Website"
    
    def save_model(self, request, obj, form, change):
        if not obj.author_id:
            obj.author = request.user
        super().save_model(request, obj, form, change)

@admin.register(SpeakingEngagement)
class SpeakingEngagementAdmin(SeniorFriendlyAdmin):
    list_display = ['name', 'organization', 'inquiry_type_display', 'status_display', 'event_date', 'fee_display', 'created_date']
    list_filter = ['inquiry_type', 'status', 'created_at']
    readonly_fields = ['created_at']
    
    fieldsets = [
        ('👤 Contact Information', {
            'fields': ('name', 'email', 'organization'),
        }),
        ('🎤 Event Details', {
            'fields': ('inquiry_type', 'event_date', 'fee_offered'),
        }),
        ('💬 Messages', {
            'fields': ('message', 'notes'),
        }),
        ('📊 Status & Tracking', {
            'fields': ('status', 'created_at'),
        }),
    ]
    
    def inquiry_type_display(self, obj):
        return format_html(
            '<span style="font-size: 14px;">{}</span>',
            obj.get_inquiry_type_display()
        )
    inquiry_type_display.short_description = "🎤 Type"
    
    def status_display(self, obj):
        colors = {
            'new': '#e74c3c',
            'contacted': '#f39c12',
            'discussing': '#3498db',
            'scheduled': '#27ae60',
            'completed': '#95a5a6',
            'declined': '#7f8c8d'
        }
        return format_html(
            '<span style="color: {}; font-weight: bold; font-size: 14px;">{}</span>',
            colors.get(obj.status, '#333'),
            obj.get_status_display()
        )
    status_display.short_description = "📊 Status"
    
    def fee_display(self, obj):
        if obj.fee_offered:
            return format_html(
                '<span style="color: #27ae60; font-weight: bold;">${:,.2f}</span>',
                obj.fee_offered
            )
        return format_html('<span style="color: #7f8c8d;">Not specified</span>')
    fee_display.short_description = "💰 Fee"
    
    def created_date(self, obj):
        return format_html(
            '<span style="font-size: 14px;">{}</span>',
            obj.created_at.strftime('%B %d, %Y')
        )
    created_date.short_description = "📅 Received"

# Customize the admin interface further
admin.site.empty_value_display = '(Not set)'
