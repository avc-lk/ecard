# Proposed File Structure (PHP + SQL + HTML/CSS/JS)

```text
ecard/
├── app/
│   ├── config/
│   │   ├── config.php
│   │   └── database.php
│   ├── controllers/
│   │   ├── AuthController.php
│   │   ├── DashboardController.php
│   │   └── ProfileController.php
│   ├── models/
│   │   ├── User.php
│   │   ├── Company.php
│   │   ├── Branch.php
│   │   ├── Profile.php
│   │   ├── Subscription.php
│   │   └── OtpCode.php
│   ├── views/
│   │   ├── layouts/
│   │   │   └── main.php
│   │   ├── auth/
│   │   │   ├── login.php
│   │   │   └── register.php
│   │   └── dashboard/
│   │       └── index.php
│   └── helpers/
│       └── functions.php
├── database/
│   └── schema.sql
├── docs/
│   └── FILE_STRUCTURE.md
├── public/
│   ├── index.php
│   ├── assets/
│   │   ├── css/
│   │   │   └── style.css
│   │   └── js/
│   │       └── app.js
│   └── uploads/
├── routes/
│   └── web.php
├── storage/
│   └── logs/
├── .env.example
└── README.md
```

## Notes
- `public/` is the web root.
- `database/schema.sql` contains the first full relational schema for roles, users, OTP, profiles, companies, branches, staff mapping, plans, subscriptions, analytics and moderation.
- This scaffold is framework-free PHP so you can later move to Laravel/CodeIgniter without losing data model ideas.
