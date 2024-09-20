// controllers/users.go

package controllers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"regexp"
	"time"
	"znav/backend/database"
	"znav/backend/models"
	"znav/backend/utils"
)

// 获取用户列表
func GetUsers(c *gin.Context) {
	// 从中间件中获取当前用户
	currentUser, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	currentUserData, ok := currentUser.(models.User)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve current user"})
		return
	}

	var users []models.User
	db := database.GetDB()

	if currentUserData.IsAdmin {
		// 管理员用户，返回所有用户
		if err := db.Find(&users).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch users"})
			return
		}
	} else {
		// 普通用户，只返回自己的信息
		if err := db.Where("id = ?", currentUserData.ID).Find(&users).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch user"})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{"users": users})
}

// 获取当前登录用户信息
func GetCurrentUser(c *gin.Context) {
	// 从中间件中获取用户信息
	user, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	// 返回用户信息
	c.JSON(http.StatusOK, gin.H{"user": user})
}

// 创建用户
func CreateUser(c *gin.Context) {
	// 从中间件中获取当前用户
	currentUser, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	currentUserData, ok := currentUser.(models.User)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve current user"})
		return
	}

	// 仅管理员可以创建新用户
	if !currentUserData.IsAdmin {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only admin users can create new users"})
		return
	}

	var user models.User
	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// 验证用户名格式: 只允许英文和数字
	match, _ := regexp.MatchString(`^[a-zA-Z0-9]+$`, user.Username)
	if !match {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Username can only contain letters and numbers"})
		return
	}

	// 验证密码长度: 至少5个字符
	if len(user.Password) < 5 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Password must be at least 5 characters long"})
		return
	}

	// 对密码进行哈希处理
	hashedPassword, err := utils.HashPassword(user.Password)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
		return
	}
	user.Password = hashedPassword

	// 设置创建时间
	now := time.Now()
	user.CreatedAt = now
	user.LoginAt = &now

	db := database.GetDB()
	if err := db.Create(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	c.JSON(http.StatusOK, user)
}

// 更新用户密码
func UpdateUserPassword(c *gin.Context) {
	var req struct {
		ID              uint   `json:"id"`
		CurrentPassword string `json:"current_password"`
		NewPassword     string `json:"new_password"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// 获取当前登录用户
	currentUser, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	currentUserData, ok := currentUser.(models.User)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve current user"})
		return
	}

	// 检查权限：用户只能修改自己的密码，管理员可以修改任何用户的密码
	if currentUserData.ID != req.ID && !currentUserData.IsAdmin {
		c.JSON(http.StatusForbidden, gin.H{"error": "You can only change your own password"})
		return
	}

	// 获取要修改的用户
	var user models.User
	db := database.GetDB()
	if err := db.Where("id = ?", req.ID).First(&user).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// 如果不是管理员，需要验证原密码
	if !currentUserData.IsAdmin {
		if err := utils.CheckPassword(req.CurrentPassword, user.Password); err != nil {
			// 返回明确的错误信息
			c.JSON(http.StatusBadRequest, gin.H{"error": "原密码不正确"})
			return
		}
	}

	// 更新密码
	hashedPassword, err := utils.HashPassword(req.NewPassword)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
		return
	}

	if err := db.Model(&user).Update("password", hashedPassword).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update password"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Password updated successfully"})
}

func UpdateUserStatus(c *gin.Context) {
	var req struct {
		ID     uint   `json:"id"`
		Status string `json:"status"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// 验证当前用户是否为管理员
	currentUser, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	currentUserData, ok := currentUser.(models.User)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve current user"})
		return
	}

	if !currentUserData.IsAdmin {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only administrators can change user status"})
		return
	}

	// 不允许管理员修改自己的状态
	if currentUserData.ID == req.ID {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Cannot change your own status"})
		return
	}

	// 更新用户状态
	var user models.User
	db := database.GetDB()
	if err := db.First(&user, req.ID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	user.Status = req.Status
	if err := db.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update user status"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User status updated successfully"})
}

func UpdateUserAdminStatus(c *gin.Context) {
	var req struct {
		ID      uint `json:"id"`
		IsAdmin bool `json:"is_admin"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// 验证当前用户是否为管理员
	currentUser, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	currentUserData, ok := currentUser.(models.User)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve current user"})
		return
	}

	if !currentUserData.IsAdmin {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only administrators can change admin status"})
		return
	}

	// 不允许管理员修改自己的管理员权限
	if currentUserData.ID == req.ID {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Cannot change your own admin status"})
		return
	}

	// 更新用户的管理员权限
	var user models.User
	db := database.GetDB()
	if err := db.First(&user, req.ID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	user.IsAdmin = req.IsAdmin
	if err := db.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update user admin status"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User admin status updated successfully"})
}

// 删除用户
func DeleteUser(c *gin.Context) {
	id := c.Param("id")

	// 获取当前登录用户
	currentUser, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	currentUserData, ok := currentUser.(models.User)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve current user"})
		return
	}

	// 仅管理员可以删除用户
	if !currentUserData.IsAdmin {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only admin users can delete users"})
		return
	}

	// 获取数据库连接
	db := database.GetDB()
	var user models.User

	// 查找用户
	if err := db.First(&user, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// 检查是否是当前登录用户
	if currentUserData.ID == user.ID {
		c.JSON(http.StatusForbidden, gin.H{"error": "Cannot delete your own account"})
		return
	}

	// 尝试删除用户
	if err := db.Delete(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User deleted successfully"})
}

// 更新用户信息
func UpdateUser(c *gin.Context) {
	var updatedUser models.User

	// 获取当前登录用户
	currentUser, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	currentUserData, ok := currentUser.(models.User)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve current user"})
		return
	}

	// 仅管理员可以更新用户信息
	if !currentUserData.IsAdmin {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only admin users can update user information"})
		return
	}

	// 绑定更新的数据
	if err := c.ShouldBindJSON(&updatedUser); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// 防止修改自己的管理员状态
	if currentUserData.ID == updatedUser.ID && currentUserData.IsAdmin != updatedUser.IsAdmin {
		c.JSON(http.StatusForbidden, gin.H{"error": "You cannot change your own admin status"})
		return
	}

	// 调试：打印接收到的数据
	// log.Printf("Updating user ID: %d, IsAdmin: %v", updatedUser.ID, updatedUser.IsAdmin)

	// 准备要更新的数据
	updateData := map[string]interface{}{
		"Status":  updatedUser.Status,
		"IsAdmin": updatedUser.IsAdmin,
	}

	// 如果密码不为空，则对密码进行哈希处理并添加到更新数据中
	if updatedUser.Password != "" {
		hashedPassword, err := utils.HashPassword(updatedUser.Password)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
			return
		}
		updateData["Password"] = hashedPassword
	}

	// 更新用户信息
	db := database.GetDB()
	if err := db.Model(&models.User{}).Where("id = ?", updatedUser.ID).Updates(updateData).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User updated successfully"})
}

// 获取用户总数
func GetTotalUsers(c *gin.Context) {
	var count int64
	db := database.GetDB()
	db.Model(&models.User{}).Count(&count)
	c.JSON(http.StatusOK, gin.H{"total": count})
}
