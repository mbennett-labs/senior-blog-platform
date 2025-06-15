# Create stylish frontend for the blog
# Run this to create beautiful templates and styling

echo "🎨 Creating stylish blog frontend..."

# Create the blog URLs file
cat > blog/urls.py << 'EOF'
from django.urls import path
from . import views

app_name = 'blog'
urlpatterns = [
    path('', views.post_list, name='post_list'),
    path('post/<slug:slug>/', views.post_detail, name='post_detail'),
]
EOF

# Create templates directory structure
mkdir -p templates/{blog,includes}
mkdir -p static/{css,js,images}

# Create base template with modern styling
cat > templates/base.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}{{ blog_settings.site_title|default:"Sue's Voice for Justice" }}{% endblock %}</title>
    <meta name="description" content="{{ blog_settings.tagline|default:'Thoughts on social justice, community, and faith' }}">
    
    <!-- Modern CSS Framework -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&family=Source+Sans+Pro:wght@300;400;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #2c3e50;
            --accent-color: #e74c3c;
            --text-light: #666;
            --text-dark: #2c3e50;
            --bg-light: #f8f9fa;
            --bg-white: #ffffff;
            --border-light: #e9ecef;
        }

        body {
            font-family: 'Source Sans Pro', sans-serif;
            font-size: 18px;
            line-height: 1.7;
            color: var(--text-dark);
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .main-content {
            background: var(--bg-white);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin: 20px 0;
            overflow: hidden;
        }

        /* Header Styles */
        .blog-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, #34495e 100%);
            color: white;
            padding: 60px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .blog-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.1"/><circle cx="10" cy="60" r="0.5" fill="white" opacity="0.1"/><circle cx="90" cy="40" r="0.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
        }

        .blog-title {
            font-family: 'Crimson Text', serif;
            font-size: 3.5rem;
            font-weight: 600;
            margin-bottom: 20px;
            position: relative;
            z-index: 1;
        }

        .blog-tagline {
            font-size: 1.3rem;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        /* Navigation */
        .blog-nav {
            background: var(--bg-white);
            border-bottom: 3px solid var(--accent-color);
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .nav-links {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .nav-links a {
            color: var(--text-dark);
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            padding: 10px 20px;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .nav-links a:hover {
            background: var(--accent-color);
            color: white;
            transform: translateY(-2px);
        }

        /* Content Area */
        .content-wrapper {
            padding: 50px 0;
        }

        /* Post Card Styles */
        .post-card {
            background: var(--bg-white);
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border-left: 5px solid var(--accent-color);
        }

        .post-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .post-title {
            font-family: 'Crimson Text', serif;
            font-size: 2.2rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--primary-color);
        }

        .post-title a {
            color: inherit;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .post-title a:hover {
            color: var(--accent-color);
        }

        .post-meta {
            color: var(--text-light);
            font-size: 1rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .post-meta i {
            color: var(--accent-color);
        }

        .category-badge {
            background: linear-gradient(45deg, var(--accent-color), #c0392b);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            transition: transform 0.3s ease;
        }

        .category-badge:hover {
            transform: scale(1.05);
            color: white;
        }

        .post-summary {
            font-size: 1.1rem;
            line-height: 1.8;
            margin-bottom: 25px;
            color: var(--text-dark);
        }

        .read-more {
            background: linear-gradient(45deg, var(--primary-color), #34495e);
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
        }

        .read-more:hover {
            transform: translateX(5px);
            color: white;
            background: linear-gradient(45deg, #34495e, var(--primary-color));
        }

        /* Single Post Styles */
        .post-content {
            font-family: 'Crimson Text', serif;
            font-size: 1.2rem;
            line-height: 1.9;
        }

        .post-content h2, .post-content h3 {
            font-family: 'Source Sans Pro', sans-serif;
            color: var(--primary-color);
            margin: 40px 0 20px 0;
        }

        .post-content p {
            margin-bottom: 25px;
        }

        .post-content img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
            margin: 30px 0;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        /* Tags */
        .post-tags {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid var(--border-light);
        }

        .tag {
            display: inline-block;
            background: var(--bg-light);
            color: var(--text-dark);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            margin: 5px 10px 5px 0;
            text-decoration: none;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .tag:hover {
            border-color: var(--accent-color);
            background: var(--accent-color);
            color: white;
        }

        /* Sidebar */
        .sidebar {
            padding-left: 40px;
        }

        .sidebar-widget {
            background: var(--bg-white);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        .widget-title {
            font-family: 'Crimson Text', serif;
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 3px solid var(--accent-color);
        }

        /* Newsletter Signup */
        .newsletter-form {
            background: linear-gradient(135deg, var(--primary-color), #34495e);
            color: white;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            margin: 40px 0;
        }

        .newsletter-form h3 {
            margin-bottom: 15px;
            font-family: 'Crimson Text', serif;
        }

        .newsletter-form input[type="email"] {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 25px;
            margin: 15px 0;
            font-size: 1.1rem;
        }

        .newsletter-form button {
            background: var(--accent-color);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .newsletter-form button:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }

        /* Footer */
        .blog-footer {
            background: var(--primary-color);
            color: white;
            text-align: center;
            padding: 40px 0;
            margin-top: 60px;
        }

        .social-links {
            margin: 20px 0;
        }

        .social-links a {
            color: white;
            font-size: 1.5rem;
            margin: 0 15px;
            transition: transform 0.3s ease;
        }

        .social-links a:hover {
            transform: translateY(-3px);
            color: var(--accent-color);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .blog-title {
                font-size: 2.5rem;
            }
            
            .blog-tagline {
                font-size: 1.1rem;
            }
            
            .nav-links {
                flex-direction: column;
                gap: 10px;
            }
            
            .post-card {
                padding: 25px;
            }
            
            .sidebar {
                padding-left: 0;
                margin-top: 40px;
            }
            
            .content-wrapper {
                padding: 30px 0;
            }
        }

        /* Animation */
        .fade-in {
            animation: fadeIn 0.8s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Featured Post Styling */
        .featured-post {
            border-left: 8px solid gold;
            background: linear-gradient(135deg, #fff9e6, #ffffff);
            position: relative;
        }

        .featured-post::before {
            content: "⭐ Featured";
            position: absolute;
            top: 20px;
            right: 20px;
            background: gold;
            color: var(--primary-color);
            padding: 5px 15px;
            border-radius: 15px;
            font-weight: 600;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid p-0">
        <!-- Header -->
        <header class="blog-header">
            <div class="container">
                <h1 class="blog-title">{{ blog_settings.site_title|default:"Sue's Voice for Justice" }}</h1>
                <p class="blog-tagline">{{ blog_settings.tagline|default:"Thoughts on social justice, community, and faith" }}</p>
            </div>
        </header>

        <!-- Navigation -->
        <nav class="blog-nav">
            <div class="container">
                <ul class="nav-links">
                    <li><a href="{% url 'blog:post_list' %}"><i class="fas fa-home"></i> Home</a></li>
                    <li><a href="#"><i class="fas fa-user"></i> About</a></li>
                    <li><a href="#"><i class="fas fa-microphone"></i> Speaking</a></li>
                    <li><a href="#"><i class="fas fa-envelope"></i> Contact</a></li>
                </ul>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="container">
            <div class="main-content">
                {% block content %}{% endblock %}
            </div>
        </div>

        <!-- Footer -->
        <footer class="blog-footer">
            <div class="container">
                <p>&copy; 2025 {{ blog_settings.site_title|default:"Sue's Voice for Justice" }}. All rights reserved.</p>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-linkedin"></i></a>
                </div>
                <p><small>Powered by love, justice, and technology ❤️</small></p>
            </div>
        </footer>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Add fade-in animation to posts
        document.addEventListener('DOMContentLoaded', function() {
            const posts = document.querySelectorAll('.post-card');
            posts.forEach((post, index) => {
                setTimeout(() => {
                    post.classList.add('fade-in');
                }, index * 100);
            });
        });

        // Smooth scrolling for navigation
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>
</html>
EOF

# Create post list template
cat > templates/blog/post_list.html << 'EOF'
{% extends 'base.html' %}

{% block content %}
<div class="content-wrapper">
    <div class="row">
        <div class="col-lg-8">
            {% if posts %}
                {% for post in posts %}
                    <article class="post-card {% if post.status == 'featured' %}featured-post{% endif %}">
                        <h2 class="post-title">
                            <a href="{% url 'blog:post_detail' post.slug %}">{{ post.title }}</a>
                        </h2>
                        
                        <div class="post-meta">
                            <span><i class="fas fa-calendar"></i> {{ post.publish|date:"F j, Y" }}</span>
                            {% if post.category %}
                                <a href="#" class="category-badge">{{ post.category.name }}</a>
                            {% endif %}
                            <span><i class="fas fa-clock"></i> {{ post.get_reading_time }} min read</span>
                        </div>
                        
                        {% if post.featured_image %}
                            <img src="{{ post.featured_image.url }}" alt="{{ post.title }}" class="img-fluid rounded mb-4">
                        {% endif %}
                        
                        <div class="post-summary">
                            {{ post.summary }}
                        </div>
                        
                        <a href="{% url 'blog:post_detail' post.slug %}" class="read-more">
                            Continue Reading <i class="fas fa-arrow-right"></i>
                        </a>
                    </article>
                {% endfor %}
            {% else %}
                <div class="post-card text-center">
                    <h2>Welcome to the Blog!</h2>
                    <p class="lead">New posts coming soon. Check back often for inspiring content about social justice, community, and faith.</p>
                    <a href="/admin/" class="read-more">Add Your First Post <i class="fas fa-plus"></i></a>
                </div>
            {% endif %}
        </div>
        
        <div class="col-lg-4">
            <aside class="sidebar">
                <!-- About Widget -->
                <div class="sidebar-widget">
                    <h3 class="widget-title">About</h3>
                    <p>{{ blog_settings.about_text|default:"Welcome to my blog where I share thoughts on social justice, community building, and faith. Join me on this journey of advocacy and hope." }}</p>
                </div>
                
                <!-- Newsletter Signup -->
                <div class="newsletter-form">
                    <h3><i class="fas fa-envelope"></i> Stay Connected</h3>
                    <p>Join our community and get updates on new posts and speaking events.</p>
                    <form method="post" action="#">
                        {% csrf_token %}
                        <input type="email" name="email" placeholder="Your email address" required>
                        <button type="submit">Subscribe</button>
                    </form>
                </div>
                
                <!-- Speaking Opportunities -->
                <div class="sidebar-widget">
                    <h3 class="widget-title">Speaking Engagements</h3>
                    <p>Available for speaking at conferences, workshops, and community events about social justice and community organizing.</p>
                    <a href="#" class="btn btn-outline-primary">Book a Speaking Event</a>
                </div>
            </aside>
        </div>
    </div>
</div>
{% endblock %}
EOF

# Create post detail template
cat > templates/blog/post_detail.html << 'EOF'
{% extends 'base.html' %}

{% block title %}{{ post.title }} - {{ block.super }}{% endblock %}

{% block content %}
<div class="content-wrapper">
    <div class="row">
        <div class="col-lg-8">
            <article class="post-card">
                <h1 class="post-title">{{ post.title }}</h1>
                
                <div class="post-meta">
                    <span><i class="fas fa-calendar"></i> {{ post.publish|date:"F j, Y" }}</span>
                    {% if post.category %}
                        <a href="#" class="category-badge">{{ post.category.name }}</a>
                    {% endif %}
                    <span><i class="fas fa-clock"></i> {{ post.get_reading_time }} min read</span>
                </div>
                
                {% if post.featured_image %}
                    <img src="{{ post.featured_image.url }}" alt="{{ post.title }}" class="img-fluid rounded mb-4">
                {% endif %}
                
                <div class="post-content">
                    {{ post.content|safe }}
                </div>
                
                {% if post.tags.all %}
                    <div class="post-tags">
                        <strong><i class="fas fa-tags"></i> Tags:</strong>
                        {% for tag in post.tags.all %}
                            <a href="#" class="tag">{{ tag.name }}</a>
                        {% endfor %}
                    </div>
                {% endif %}
            </article>
            
            <div class="text-center mt-4">
                <a href="{% url 'blog:post_list' %}" class="read-more">
                    <i class="fas fa-arrow-left"></i> Back to All Posts
                </a>
            </div>
        </div>
        
        <div class="col-lg-4">
            <aside class="sidebar">
                <!-- Share Widget -->
                <div class="sidebar-widget">
                    <h3 class="widget-title">Share This Post</h3>
                    <div class="d-flex gap-2">
                        <a href="#" class="btn btn-primary btn-sm"><i class="fab fa-facebook"></i> Facebook</a>
                        <a href="#" class="btn btn-info btn-sm"><i class="fab fa-twitter"></i> Twitter</a>
                        <a href="#" class="btn btn-primary btn-sm"><i class="fab fa-linkedin"></i> LinkedIn</a>
                    </div>
                </div>
                
                <!-- About Widget -->
                <div class="sidebar-widget">
                    <h3 class="widget-title">About the Author</h3>
                    <p>{{ blog_settings.about_text|default:"Passionate advocate for social justice, community organizer, and speaker dedicated to creating positive change in our world." }}</p>
                </div>
                
                <!-- Contact Widget -->
                <div class="sidebar-widget">
                    <h3 class="widget-title">Get in Touch</h3>
                    <p>Interested in having me speak at your event or collaborate on community initiatives?</p>
                    <a href="mailto:{{ blog_settings.contact_email }}" class="btn btn-outline-primary">
                        <i class="fas fa-envelope"></i> Contact Me
                    </a>
                </div>
            </aside>
        </div>
    </div>
</div>
{% endblock %}
EOF

# Update views to include blog settings context
cat > blog/views.py << 'EOF'
from django.shortcuts import render, get_object_or_404
from .models import Post, Category, BlogSettings

def get_blog_settings():
    """Get blog settings or create default ones"""
    try:
        return BlogSettings.objects.first()
    except BlogSettings.DoesNotExist:
        return None

def post_list(request):
    posts = Post.objects.filter(status__in=['published', 'featured']).order_by('-publish')
    blog_settings = get_blog_settings()
    
    context = {
        'posts': posts,
        'blog_settings': blog_settings,
    }
    return render(request, 'blog/post_list.html', context)

def post_detail(request, slug):
    post = get_object_or_404(Post, slug=slug, status__in=['published', 'featured'])
    blog_settings = get_blog_settings()
    
    context = {
        'post': post,
        'blog_settings': blog_settings,
    }
    return render(request, 'blog/post_detail.html', context)
EOF

# Update main URLs to include media files
cat > senior_blog/urls.py << 'EOF'
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('ckeditor/', include('ckeditor_uploader.urls')),
    path('', include('blog.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATICFILES_DIRS[0] if settings.STATICFILES_DIRS else settings.STATIC_ROOT)
EOF

echo "🎨 Stylish frontend created!"
echo ""
echo "✨ Your blog now has:"
echo "📱 Responsive design that works on all devices"
echo "🎨 Beautiful gradient backgrounds and animations"
echo "👵 Large, readable fonts perfect for seniors"
echo "📝 Professional post layouts with social sharing"
echo "💌 Newsletter signup integration"
echo "🎤 Speaking engagement promotion"
echo "⭐ Featured post highlighting"
echo ""
echo "🚀 Visit your beautiful blog at: http://69.62.69.140:8080"
echo "🔧 Manage content at: http://69.62.69.140:8080/admin"
EOF
