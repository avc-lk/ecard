# ECard - QR Digital Profile SaaS (Starter)

This repository provides an initial PHP + SQL + HTML/CSS/JS starter structure for a centralized QR Digital Profile platform.

## First Deliverables Included
1. **File structure scaffold** for web app and modules.
2. **Production-oriented SQL schema** (`database/schema.sql`) covering:
   - Users, roles, OTP auth
   - Solo/company/branch/staff profile hierarchy
   - QR records
   - Subscriptions and plans
   - Analytics and activity logs

## Quick Start
```bash
cp .env.example .env
# import SQL schema into MySQL
mysql -u root -p ecard < database/schema.sql
php -S localhost:8000 -t public
```

Open: `http://localhost:8000`
