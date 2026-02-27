-- QR Digital Profile SaaS Platform Schema
-- MySQL 8+

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS activity_logs;
DROP TABLE IF EXISTS profile_analytics;
DROP TABLE IF EXISTS qr_codes;
DROP TABLE IF EXISTS profile_gallery;
DROP TABLE IF EXISTS profiles;
DROP TABLE IF EXISTS staff_branch_assignments;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS otp_codes;
DROP TABLE IF EXISTS user_sessions;
DROP TABLE IF EXISTS subscription_addons;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS pricing_plans;
DROP TABLE IF EXISTS templates;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

CREATE TABLE roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_key VARCHAR(50) NOT NULL UNIQUE,
    role_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT UNSIGNED NOT NULL,
    mobile_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    status ENUM('pending','active','suspended','disabled') NOT NULL DEFAULT 'pending',
    last_login_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE otp_codes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    mobile_number VARCHAR(20) NOT NULL,
    otp_code VARCHAR(12) NOT NULL,
    purpose ENUM('signup_verify','login_verify','password_change','forgot_password') NOT NULL,
    expires_at DATETIME NOT NULL,
    attempts INT UNSIGNED NOT NULL DEFAULT 0,
    max_attempts INT UNSIGNED NOT NULL DEFAULT 5,
    is_used TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_otp_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_otp_mobile (mobile_number),
    INDEX idx_otp_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE companies (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    owner_user_id BIGINT UNSIGNED NOT NULL,
    company_name VARCHAR(200) NOT NULL,
    slug VARCHAR(220) NOT NULL UNIQUE,
    registration_no VARCHAR(100) NULL,
    description TEXT NULL,
    logo_path VARCHAR(255) NULL,
    contact_phone VARCHAR(20) NULL,
    contact_whatsapp VARCHAR(20) NULL,
    address_line_1 VARCHAR(255) NULL,
    address_line_2 VARCHAR(255) NULL,
    city VARCHAR(100) NULL,
    country VARCHAR(100) DEFAULT 'Sri Lanka',
    is_verified TINYINT(1) NOT NULL DEFAULT 0,
    status ENUM('active','suspended','disabled') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_company_owner FOREIGN KEY (owner_user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE branches (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    manager_user_id BIGINT UNSIGNED NULL,
    branch_name VARCHAR(200) NOT NULL,
    slug VARCHAR(220) NOT NULL UNIQUE,
    phone VARCHAR(20) NULL,
    whatsapp VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
    address_line_1 VARCHAR(255) NULL,
    address_line_2 VARCHAR(255) NULL,
    city VARCHAR(100) NULL,
    latitude DECIMAL(10,7) NULL,
    longitude DECIMAL(10,7) NULL,
    status ENUM('active','suspended','disabled') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_branch_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_branch_manager FOREIGN KEY (manager_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE staff_branch_assignments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    branch_id BIGINT UNSIGNED NOT NULL,
    staff_user_id BIGINT UNSIGNED NOT NULL,
    staff_role_title VARCHAR(120) NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_staff_assignment_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_staff_assignment_branch FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE CASCADE,
    CONSTRAINT fk_staff_assignment_user FOREIGN KEY (staff_user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uq_branch_staff (branch_id, staff_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE templates (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    template_key VARCHAR(80) NOT NULL UNIQUE,
    template_name VARCHAR(120) NOT NULL,
    category ENUM('personal','company','branch','staff') NOT NULL,
    preview_image_path VARCHAR(255) NULL,
    css_file VARCHAR(255) NULL,
    is_premium TINYINT(1) NOT NULL DEFAULT 0,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE profiles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    profile_type ENUM('solo','company','branch','staff') NOT NULL,
    user_id BIGINT UNSIGNED NULL,
    company_id BIGINT UNSIGNED NULL,
    branch_id BIGINT UNSIGNED NULL,
    template_id BIGINT UNSIGNED NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    display_name VARCHAR(200) NOT NULL,
    headline VARCHAR(255) NULL,
    bio TEXT NULL,
    profile_photo VARCHAR(255) NULL,
    cover_photo VARCHAR(255) NULL,
    public_phone VARCHAR(20) NULL,
    public_whatsapp VARCHAR(20) NULL,
    public_email VARCHAR(255) NULL,
    website_url VARCHAR(255) NULL,
    vcard_enabled TINYINT(1) NOT NULL DEFAULT 1,
    language_code VARCHAR(10) DEFAULT 'en',
    is_public TINYINT(1) NOT NULL DEFAULT 1,
    status ENUM('active','moderated','suspended','disabled') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_profile_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_profile_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL,
    CONSTRAINT fk_profile_branch FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE SET NULL,
    CONSTRAINT fk_profile_template FOREIGN KEY (template_id) REFERENCES templates(id) ON DELETE SET NULL,
    INDEX idx_profile_type (profile_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE profile_gallery (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    profile_id BIGINT UNSIGNED NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    sort_order INT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_gallery_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE qr_codes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    profile_id BIGINT UNSIGNED NOT NULL,
    qr_token VARCHAR(120) NOT NULL UNIQUE,
    qr_image_path VARCHAR(255) NOT NULL,
    destination_url VARCHAR(255) NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_qr_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pricing_plans (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    plan_type ENUM('personal','company') NOT NULL,
    plan_name VARCHAR(150) NOT NULL,
    price_lkr DECIMAL(10,2) NOT NULL,
    billing_cycle ENUM('monthly','yearly','one_time') NOT NULL,
    profile_limit INT UNSIGNED NOT NULL DEFAULT 1,
    branch_limit INT UNSIGNED NULL,
    staff_limit INT UNSIGNED NULL,
    gallery_limit INT UNSIGNED NULL,
    template_limit INT UNSIGNED NULL,
    analytics_level ENUM('basic','standard','advanced') NOT NULL DEFAULT 'basic',
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE subscriptions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    company_id BIGINT UNSIGNED NULL,
    plan_id BIGINT UNSIGNED NOT NULL,
    payment_reference VARCHAR(120) NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    auto_renew TINYINT(1) NOT NULL DEFAULT 0,
    status ENUM('active','expired','cancelled','suspended') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_sub_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_plan FOREIGN KEY (plan_id) REFERENCES pricing_plans(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE subscription_addons (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    subscription_id BIGINT UNSIGNED NOT NULL,
    addon_type ENUM('extra_branch','extra_staff','premium_template','advanced_analytics') NOT NULL,
    quantity INT UNSIGNED NOT NULL DEFAULT 1,
    price_lkr DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_addon_subscription FOREIGN KEY (subscription_id) REFERENCES subscriptions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE profile_analytics (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    profile_id BIGINT UNSIGNED NOT NULL,
    event_type ENUM('view','qr_scan','call_click','whatsapp_click','vcard_download','share_click') NOT NULL,
    source VARCHAR(100) NULL,
    ip_address VARCHAR(45) NULL,
    user_agent VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_analytics_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
    INDEX idx_analytics_profile_event (profile_id, event_type),
    INDEX idx_analytics_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE activity_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    actor_user_id BIGINT UNSIGNED NULL,
    action VARCHAR(120) NOT NULL,
    entity_type VARCHAR(80) NOT NULL,
    entity_id BIGINT UNSIGNED NULL,
    metadata JSON NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_activity_user FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_activity_entity (entity_type, entity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE user_sessions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    session_token VARCHAR(255) NOT NULL UNIQUE,
    ip_address VARCHAR(45) NULL,
    user_agent VARCHAR(255) NULL,
    expires_at DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_session_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_session_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO roles (role_key, role_name) VALUES
('super_admin', 'Platform Owner (Super Admin)'),
('system_staff', 'System Staff'),
('company_owner', 'Company Owner'),
('branch_manager', 'Branch Manager'),
('personnel', 'Personnel (Staff)'),
('solo_user', 'Solo User');

SET FOREIGN_KEY_CHECKS = 1;
