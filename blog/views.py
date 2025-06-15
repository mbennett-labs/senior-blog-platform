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
