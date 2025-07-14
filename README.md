# Sue's Voice for Justice Blog 🌟

A senior-friendly Django blog platform designed specifically for social justice advocates, speakers, and community leaders. Built with accessibility, large fonts, and intuitive interfaces in mind.

## 🎯 Project Mission
Empowering voices for social justice through accessible, beautiful blogging. This platform bridges the gap between powerful advocacy messages and user-friendly technology, ensuring that important voices aren't silenced by complex interfaces.

## ✨ Key Features

### 🎨 Senior-Friendly Design
- **Extra large fonts** (18px+ throughout admin interface)
- **Clear, emoji-labeled buttons** (💾 Save, ✍️ Write, 📅 Publish)
- **High contrast colors** and intuitive navigation
- **Simplified admin interface** with helpful descriptions
- **One-click publishing** with clear status indicators

### 💜 Beautiful Spiritual/Justice Theme
- **Professional gradient backgrounds** with spiritual patterns
- **Responsive design** that works on all devices
- **Social justice color palette** (deep purples, warm golds)
- **Accessibility-first** approach to design

### 🎤 Speaking Engagement Management
- **Built-in CRM** for managing speaking inquiries
- **Revenue tracking** for speaking fees
- **Status management** (New → Contacted → Scheduled → Completed)
- **Contact information** and notes organization

### 📝 Content Management
- **Rich text editor** optimized for seniors
- **Category organization** (Social Justice, Community, Faith, Speaking Events)
- **Tag system** for content discovery
- **Featured post highlighting**
- **Auto-save drafts** to prevent lost work

## 🛠 Technical Stack
- **Backend:** Django 5.2.3 with Python 3.12
- **Database:** SQLite (development) / PostgreSQL (production)
- **Editor:** CKEditor with senior-friendly toolbar
- **Styling:** Custom CSS with Bootstrap 5 foundation
- **Deployment:** Ready for production with gunicorn

## 🚀 Quick Setup

### Prerequisites
- Python 3.12+
- Git

### Installation
```bash
# Clone the repository
git clone https://github.com/mbennett-labs/senior-blog-platform.git
cd senior-blog-platform

# Create virtual environment
python -m venv blog-env
source blog-env/Scripts/activate  # Windows Git Bash
# or
source blog-env/bin/activate      # Mac/Linux

# Install dependencies
pip install -r requirements.txt

# Run setup script (creates admin user, sample content, etc.)
chmod +x final_setup.sh
./final_setup.sh

# Start the blog
./start_blog.sh
```

### Default Credentials
- **Username:** `admin`
- **Password:** `BlogAdmin2025!`
- **Admin Panel:** http://localhost:8080/admin
- **Website:** http://localhost:8080

## 📖 What Gets Created Automatically

### 📂 Categories
- **Social Justice** - Posts about fighting for equality and justice
- **Community** - Building stronger communities together  
- **Faith** - Spiritual reflections and faith-based action
- **Speaking Events** - Updates about speaking engagements

### 📝 Sample Content
- Welcome post explaining the blog's mission
- Blog settings configured for "Sue's Voice for Justice"
- Speaking engagement tracking system ready to use

### 🎨 Interface Customizations
- Senior-friendly CSS with large fonts
- Emoji-enhanced admin interface
- Helpful field descriptions throughout
- Status indicators with colors and icons

## 📱 For End Users (Seniors)

This blog is specifically designed for users who:
- Want large, readable fonts and clear interfaces
- Need simple, guided workflows for publishing
- Appreciate helpful descriptions and visual cues
- Require reliable auto-save features
- Want professional-looking results without technical complexity

### 🌟 User Experience Highlights
- **Write a post:** Clear step-by-step interface with helpful hints
- **Publish content:** One-click publishing with status tracking
- **Manage speaking engagements:** Simple CRM for tracking opportunities
- **Organize content:** Easy category and tag management
- **View analytics:** Post count and engagement tracking

## 🛡️ Security Features
- **CSRF protection** enabled
- **SQL injection** prevention
- **XSS protection** with content sanitization
- **Secure file uploads** with validation
- **Environment-based configuration** for sensitive data

## 🚀 Production Deployment

### Environment Variables
Create a `.env` file based on `.env.example`:
```bash
SECRET_KEY=your-production-secret-key
DEBUG=False
ALLOWED_HOSTS=yourdomain.com
USE_POSTGRES=True
DB_NAME=your_db_name
DB_USER=your_db_user
DB_PASSWORD=your_db_password
```

### Production Setup
```bash
# Install production dependencies
pip install -r requirements.txt

# Set up PostgreSQL database
# Configure your .env file

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Collect static files
python manage.py collectstatic

# Run with gunicorn
gunicorn senior_blog.wsgi:application
```

## 📂 Project Structure
```
senior-blog-platform/
├── blog/                   # Main blog application
│   ├── models.py          # Database models
│   ├── admin.py           # Senior-friendly admin interface
│   ├── views.py           # View logic
│   └── templates/         # HTML templates
├── static/                # CSS, JS, images
│   └── admin/css/         # Senior-friendly admin CSS
├── templates/             # Base templates
├── media/                 # User uploads
├── requirements.txt       # Python dependencies
├── final_setup.sh        # Automated setup script
├── start_blog.sh         # Easy start script
└── manage.py             # Django management
```

## 🎨 Customization

### Adding New Categories
```python
# In Django admin or shell
from blog.models import Category
Category.objects.create(
    name="New Category",
    slug="new-category", 
    description="Description here"
)
```

### Modifying Admin Interface
The admin interface customizations are in `blog/admin.py`. All classes inherit from `SeniorFriendlyAdmin` which loads the custom CSS.

### Styling Changes
Main styles are in:
- `static/admin/css/senior_friendly.css` (Admin interface)
- `templates/base.html` (Website styling)

## 🤝 Contributing

This project welcomes contributions, especially:
- **Accessibility improvements** for senior users
- **UI/UX enhancements** for better usability
- **Documentation** improvements
- **Security** enhancements
- **Mobile responsiveness** optimizations

### Development Setup
```bash
git clone https://github.com/mbennett-labs/senior-blog-platform.git
cd senior-blog-platform
python -m venv dev-env
source dev-env/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💬 Support
For technical support or questions:
- **GitHub Issues:** [Create an issue](https://github.com/mbennett-labs/senior-blog-platform/issues)
- **Email:** Contact through the blog admin interface

## 🌟 Success Stories
This platform empowers senior advocates to:
- Share their voices on social justice issues
- Manage speaking engagement opportunities 
- Build communities around shared values
- Maintain professional online presence without technical barriers

---

**Built with ❤️ for social justice advocates who refuse to be silenced by technology**

*"The arc of the moral universe is long, but it bends toward justice." - Dr. Martin Luther King Jr.*
