-- ============================================
-- e-Digital System - Database Schema
-- Jabatan Mufti Negeri Perlis
-- ============================================

CREATE DATABASE IF NOT EXISTS e_digital_perlis;
USE e_digital_perlis;

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(255) NOT NULL,
    ic_number VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    category ENUM('pelajar', 'tenaga-pengajar', 'orang-awam', 'kakitangan') DEFAULT 'orang-awam',
    address TEXT,
    role ENUM('admin', 'staff', 'user') DEFAULT 'user',
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_ic (ic_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- GURU MAIPS TABLE (Teachers/Instructors)
-- ============================================
CREATE TABLE IF NOT EXISTS guru_maips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_name VARCHAR(255) NOT NULL,
    teacher_category ENUM('Guru al-Quran', 'Guru Agama', 'Guru Al-Quran dan Agama') NOT NULL,
    guru_takmir ENUM('Ya', 'Tidak') DEFAULT 'Tidak',
    tarikh_lantikan DATE,
    tarikh_penempatan DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_teacher_name (teacher_name),
    INDEX idx_category (teacher_category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- MOSQUES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS mosques (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mosque_name VARCHAR(255) NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_mosque_name (mosque_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- SCHEDULES TABLE (Jadual Penempatan & Mengajar)
-- ============================================
CREATE TABLE IF NOT EXISTS schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT,
    teacher_name VARCHAR(255) NOT NULL,
    mosque_id INT,
    mosque_name VARCHAR(255) NOT NULL,
    class_type VARCHAR(50) NOT NULL,
    reference_book VARCHAR(255),
    category VARCHAR(50),
    teacher_category ENUM('Guru al-Quran', 'Guru Agama', 'Guru Al-Quran dan Agama') NOT NULL,
    guru_takmir ENUM('Ya', 'Tidak') DEFAULT 'Tidak',
    day ENUM('Isnin', 'Selasa', 'Rabu', 'Khamis', 'Jumaat', 'Sabtu', 'Ahad') NOT NULL,
    frequency_per_month INT NOT NULL DEFAULT 1,
    tarikh_lantikan DATE,
    tarikh_penempatan DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES guru_maips(id) ON DELETE CASCADE,
    FOREIGN KEY (mosque_id) REFERENCES mosques(id) ON DELETE CASCADE,
    INDEX idx_teacher (teacher_name),
    INDEX idx_mosque (mosque_name),
    INDEX idx_class_type (class_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- ARAH KIBLAT TABLE (Qibla Direction)
-- ============================================
CREATE TABLE IF NOT EXISTS qibla_directions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(255) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    poskod VARCHAR(10),
    state VARCHAR(50),
    premis ENUM('Masjid', 'Surau', 'Bilik', 'Surau dan Bilik', 'Kawasan Lapang/Dewan', 'Kubur'),
    status ENUM('Dalam proses', 'Selesai') DEFAULT 'Dalam proses',
    alamat_premis TEXT,
    bilangan_lokasi INT DEFAULT 0,
    tarikh_permohonan DATE,
    koordinat_premis VARCHAR(100),
    azimut_kiblat VARCHAR(100),
    kaedah_ukuran VARCHAR(50),
    tarikh_pengesahan DATE,
    sijil_pengesahan ENUM('Ya', 'Tidak') DEFAULT 'Tidak',
    no_sijil VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_status (status),
    INDEX idx_tarikh_permohonan (tarikh_permohonan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- PERMOHONAN TUALIAH TABLE (Teaching Permit Applications)
-- ============================================
CREATE TABLE IF NOT EXISTS permohonan_tauliah (
    id INT AUTO_INCREMENT PRIMARY KEY,
    no_permohonan VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    no_kad_pengenalan VARCHAR(14) NOT NULL,
    alamat TEXT,
    pekerjaan_sekarang VARCHAR(255),
    position ENUM('Umum', 'Al-Quran') NOT NULL,
    telefon VARCHAR(15) NOT NULL,
    email VARCHAR(255) NOT NULL,
    status ENUM('Semakan', 'Ujian bertulis', 'Ujian lisan', 'Temuduga', 'Jawatankuasa Pengawasan', 'MAIPs', 'Lulus', 'KIV', 'Tolak') DEFAULT 'Semakan',
    tarikh_ujian_1 DATE,
    markah_ujian_1 DECIMAL(5,2),
    status_kehadiran_ujian_1 ENUM('Hadir', 'Tidak Hadir', 'Dikecualikan'),
    tarikh_ujian_2 DATE,
    markah_ujian_2 DECIMAL(5,2),
    permohonan_kali_ke INT DEFAULT 1,
    status_kehadiran ENUM('Hadir', 'Tidak Hadir'),
    catatan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_no_permohonan (no_permohonan),
    INDEX idx_name (name),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- PERMOHONAN GURU TABLE (Teacher Applications)
-- ============================================
CREATE TABLE IF NOT EXISTS permohonan_guru (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    no_kad_pengenalan VARCHAR(14) NOT NULL,
    alamat TEXT,
    pekerjaan_sekarang VARCHAR(255),
    position ENUM('Guru al-Quran', 'Guru Agama') NOT NULL,
    telefon VARCHAR(15) NOT NULL,
    email VARCHAR(255) NOT NULL,
    status ENUM('Semakan', 'Temuduga', 'Lulus', 'KIV', 'Tolak') DEFAULT 'Semakan',
    tarikh_ujian_1 DATE,
    markah_ujian_1 DECIMAL(5,2),
    nama_masjid_1 VARCHAR(255),
    nama_masjid_2 VARCHAR(255),
    bidang_pengajian_1 VARCHAR(255),
    bidang_pengajian_2 VARCHAR(255),
    catatan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_status (status),
    INDEX idx_position (position)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- REKOD KEHADIRAN TABLE (Attendance Records)
-- ============================================
CREATE TABLE IF NOT EXISTS attendance_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    kategori ENUM('Guru Agama', 'Guru Al-Quran') NOT NULL,
    nama_program VARCHAR(255) NOT NULL,
    tarikh DATE NOT NULL,
    tempat VARCHAR(255) NOT NULL,
    status ENUM('Hadir', 'Lewat', 'Tidak Hadir') DEFAULT 'Hadir',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_nama (nama),
    INDEX idx_nama_program (nama_program),
    INDEX idx_tarikh (tarikh)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

-- Sample Guru MAIPs
INSERT INTO guru_maips (teacher_name, teacher_category, guru_takmir, tarikh_lantikan, tarikh_penempatan) VALUES
('Ustaz Ahmad Fauzi', 'Guru al-Quran', 'Ya', '2024-01-15', '2024-02-01'),
('Ustazah Norhayati', 'Guru Agama', 'Tidak', '2024-03-10', '2024-03-25'),
('Ustaz Muhammad Hafiz', 'Guru Al-Quran dan Agama', 'Ya', '2023-11-05', '2023-12-01');

-- Sample Mosques (Perlis)
INSERT INTO mosques (mosque_name, address) VALUES
('MASJID ALWI, KANGAR', 'Jalan Masjid Alwi, 01000 Kangar, Perlis'),
('MASJID NEGERI, ARAU', 'Jalan Masjid Negeri, 02600 Arau, Perlis'),
('MASJID TUANKU SYED PUTRA JAMALULLAIL, KANGAR', 'Jalan Bukit Lagi, 01000 Kangar, Perlis'),
('MASJID JAMEK BESERI, BESERI', 'Jalan Masjid Jamek, 02400 Beseri, Perlis'),
('MASJID AL-MUBARAK, TASOH', 'Jalan Tasoh, 02400 Beseri, Perlis');

-- Sample Schedules
INSERT INTO schedules (teacher_name, mosque_name, class_type, reference_book, category, teacher_category, guru_takmir, day, frequency_per_month) VALUES
('Ustaz Ahmad Fauzi', 'MASJID ALWI, KANGAR', 'Kuliah Subuh', 'Al-Quran', 'Ulum al-Quran', 'Guru al-Quran', 'Ya', 'Isnin', 4),
('Ustazah Norhayati', 'MASJID NEGERI, ARAU', 'Kuliah Maghrib', 'Fiqh Al-Sunnah', 'Feqah', 'Guru Agama', 'Tidak', 'Rabu', 2),
('Ustaz Muhammad Hafiz', 'MASJID JAMEK BESERI', 'Kuliah Dhuha', 'Hadith 40', 'Hadis dan Sirah', 'Guru Al-Quran dan Agama', 'Ya', 'Khamis', 3);

-- Sample Qibla Directions
INSERT INTO qibla_directions (name, phone, email, address, city, poskod, state, premis, status, alamat_premis, bilangan_lokasi, koordinat_premis, azimut_kiblat, kaedah_ukuran) VALUES
('Ahmad bin Abdullah', '012-3456789', 'ahmad@example.com', '123 Jalan Kangar', 'Kangar', '01000', 'Perlis', 'Masjid', 'Selesai', 'Masjid Jamek Beseri', 2, '6.54167, 100.16833', '292° 45\' 12"', 'Bayang matahari'),
('Siti Aminah', '019-8765432', 'siti@example.com', '456 Jalan Arau', 'Arau', '02600', 'Perlis', 'Surau', 'Dalam proses', 'Surau Al-Ikhlas', 1, '6.43123, 100.26789', '291° 30\' 45"', 'Ukur trabas');

-- Sample Permohonan Tauliah
INSERT INTO permohonan_tauliah (no_permohonan, name, no_kad_pengenalan, alamat, pekerjaan_sekarang, position, telefon, email, status) VALUES
('0001', 'Muhammad Salihin', '900101-14-5678', '789 Jalan Padang Besar', 'Guru Sekolah', 'Umum', '013-4445556', 'salihin@example.com', 'Semakan'),
('0002', 'Nurul Izzah', '920202-12-3456', '321 Jalan Kaki Bukit', 'Pensyarah', 'Al-Quran', '017-2223334', 'nurul@example.com', 'Lulus');

-- Sample Permohonan Guru
INSERT INTO permohonan_guru (name, no_kad_pengenalan, alamat, pekerjaan_sekarang, position, telefon, email, status) VALUES
('Abdul Rahman', '880303-14-1234', '456 Jalan Simpang Empat', 'Imam', 'Guru Agama', '012-9998887', 'rahman@example.com', 'Temuduga'),
('Fatimah Zahra', '950505-14-5678', '789 Jalan Mata Ayer', 'Guru Al-Quran', 'Guru al-Quran', '016-7776665', 'fatimah@example.com', 'Semakan');

-- Sample Attendance Records
INSERT INTO attendance_records (nama, kategori, nama_program, tarikh, tempat, status) VALUES
('Ustaz Ahmad Fauzi', 'Guru Agama', 'Kursus Pengurusan Masjid', '2026-08-15', 'Dewan Serbaguna Kangar', 'Hadir'),
('Ustazah Norhayati', 'Guru Al-Quran', 'Seminar Falak', '2026-08-16', 'Masjid Negeri Arau', 'Lewat'),
('Ustaz Muhammad Hafiz', 'Guru Al-Quran', 'Kursus Pengurusan Masjid', '2026-08-15', 'Dewan Serbaguna Kangar', 'Hadir');

-- Sample User (password: admin123)
INSERT INTO users (fullname, ic_number, email, phone, password_hash, category, address) VALUES
('Admin Jabatan Mufti', '700101-14-5678', 'admin@perlis.gov.my', '012-3456789', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'kakitangan', 'Jabatan Mufti Negeri Perlis, Kangar, Perlis');

-- ============================================
-- STORED PROCEDURES / FUNCTIONS
-- ============================================

DELIMITER //

-- Get schedules by teacher
CREATE PROCEDURE GetSchedulesByTeacher(IN p_teacher_name VARCHAR(255))
BEGIN
    SELECT * FROM schedules WHERE teacher_name = p_teacher_name ORDER BY day;
END//

-- Get qibla records by year
CREATE PROCEDURE GetQiblaByYear(IN p_year INT)
BEGIN
    SELECT * FROM qibla_directions WHERE YEAR(tarikh_permohonan) = p_year;
END//

-- Get attendance summary
CREATE PROCEDURE GetAttendanceSummary()
BEGIN
    SELECT 
        COUNT(DISTINCT nama) as unique_names,
        SUM(CASE WHEN kategori = 'Guru Agama' THEN 1 ELSE 0 END) as guru_agama,
        SUM(CASE WHEN kategori = 'Guru Al-Quran' THEN 1 ELSE 0 END) as guru_alquran,
        COUNT(DISTINCT nama_program) as unique_programs
    FROM attendance_records;
END//

DELIMITER ;