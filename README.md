# Susan's Voice for Justice Blog

A professional Django blog platform designed for senior users with a focus on social justice advocacy and speaking engagements.

## 🎯 Project Mission
Empowering voices for social justice through accessible, beautiful blogging. Built specifically for senior advocates, speakers, and community leaders.

## ✨ Features

### For Content Creators (Seniors)
- **Large, readable fonts** (18px+ throughout)
- **Simple, intuitive admin interface** 
- **One-click publishing** with clear status indicators
- **Rich text editor** optimized for accessibility
- **Speaking engagement tracking** for revenue management

### For Readers & Community
- **Beautiful spiritual/social justice theme** with professional design
- **Mobile-responsive** layout for all devices
- **Social sharing** integration
- **Newsletter signup** for community building

## 🛠 Tech Stack
- **Backend:** Django 5.2.3 with Python 3.12
- **Database:** PostgreSQL (production) / SQLite (development)
- **Frontend:** Django Templates with Bootstrap 5
- **Styling:** Custom CSS with spiritual theme design

## 🚀 Quick Start
```bash
# Clone and setup
git clone [repository-url]
cd susan-voice-for-justice-blog
python -m venv blog-platform-env
source blog-platform-env/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
