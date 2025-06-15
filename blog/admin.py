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
