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
