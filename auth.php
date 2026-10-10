<?php
// ============================================
// config/auth.php - Session & Authentication
// ============================================
session_start();

// Check if user is logged in
function checkAuth() {
    if (!isset($_SESSION['user_id'])) {
        header('Location: login.php');
        exit();
    }
}

// Get current user
function getCurrentUser() {
    if (isset($_SESSION['user_id'])) {
        $db = getDB();
        $stmt = $db->prepare("SELECT * FROM users WHERE id = ?");
        $stmt->execute([$_SESSION['user_id']]);
        return $stmt->fetch();
    }
    return null;
}

// Login function
function login($email, $password) {
    $db = getDB();
    $stmt = $db->prepare("SELECT * FROM users WHERE email = ? AND is_active = 1");
    $stmt->execute([$email]);
    $user = $stmt->fetch();
    
    if ($user && password_verify($password, $user['password_hash'])) {
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['user_name'] = $user['fullname'];
        $_SESSION['user_role'] = $user['role'];
        return true;
    }
    return false;
}

// Logout function
function logout() {
    session_unset();
    session_destroy();
}

// Register function
function register($fullname, $ic, $email, $phone, $password, $category, $address = '') {
    $db = getDB();
    $hashed = password_hash($password, PASSWORD_DEFAULT);
    
    try {
        $stmt = $db->prepare("
            INSERT INTO users (fullname, ic_number, email, phone, password_hash, category, address)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([$fullname, $ic, $email, $phone, $hashed, $category, $address]);
        return true;
    } catch (PDOException $e) {
        return false;
    }
}

// Update profile
function updateProfile($userId, $fullname, $ic, $phone, $category, $address) {
    $db = getDB();
    $stmt = $db->prepare("
        UPDATE users SET fullname = ?, ic_number = ?, phone = ?, category = ?, address = ?
        WHERE id = ?
    ");
    return $stmt->execute([$fullname, $ic, $phone, $category, $address, $userId]);
}

// Change password
function changePassword($userId, $currentPassword, $newPassword) {
    $db = getDB();
    
    // Get current password hash
    $stmt = $db->prepare("SELECT password_hash FROM users WHERE id = ?");
    $stmt->execute([$userId]);
    $user = $stmt->fetch();
    
    if (!$user || !password_verify($currentPassword, $user['password_hash'])) {
        return false;
    }
    
    // Update password
    $hashed = password_hash($newPassword, PASSWORD_DEFAULT);
    $stmt = $db->prepare("UPDATE users SET password_hash = ? WHERE id = ?");
    return $stmt->execute([$hashed, $userId]);
}

// Change email
function changeEmail($userId, $newEmail, $password) {
    $db = getDB();
    
    // Verify password
    $stmt = $db->prepare("SELECT password_hash FROM users WHERE id = ?");
    $stmt->execute([$userId]);
    $user = $stmt->fetch();
    
    if (!$user || !password_verify($password, $user['password_hash'])) {
        return false;
    }
    
    // Update email
    $stmt = $db->prepare("UPDATE users SET email = ? WHERE id = ?");
    return $stmt->execute([$newEmail, $userId]);
}
?>