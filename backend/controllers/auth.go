// controllers/auth.go

package controllers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strings"
	"znav/backend/database"
	"znav/backend/models"
	"znav/backend/utils"
)

func Login(c *gin.Context) {
	var loginData struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}

	if err := c.ShouldBindJSON(&loginData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "请求数据无效"})
		return
	}

	var user models.User
	db := database.GetDB()
	if err := db.Where("username = ?", loginData.Username).First(&user).Error; err != nil {
		// 用户未注册
		c.JSON(http.StatusUnauthorized, gin.H{"error": "用户未注册"})
		return
	}

	// 检查用户状态，确保用户是启用状态才能登录
	if user.Status == "disabled" {
		c.JSON(http.StatusForbidden, gin.H{"error": "用户已停用"})
		return
	}

	// 验证密码
	if !utils.CheckPasswordHash(loginData.Password, user.Password) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "密码验证失败"})
		return
	}

	// 生成 JWT token，设定24小时的过期时间
	token, err := utils.GenerateJWT(user.Username)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "生成令牌失败"})
		return
	}

	// 将 token 保存到用户记录中
	user.Token = token
	if err := db.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "保存令牌失败"})
		return
	}

	// 返回 token 给前端
	c.JSON(http.StatusOK, gin.H{"token": token})
}

func Logout(c *gin.Context) {
	token := c.GetHeader("Authorization")

	// 去除 Bearer 前缀
	if strings.HasPrefix(token, "Bearer ") {
		token = strings.TrimPrefix(token, "Bearer ")
	}

	username, err := utils.GetUsernameFromJWT(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "无效的令牌"})
		return
	}

	// 查找用户并清除 token
	db := database.GetDB()
	var user models.User
	if err := db.Where("username = ?", username).First(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "用户未找到"})
		return
	}

	// 清除用户的 token
	user.Token = ""
	if err := db.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "注销失败"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "注销成功"})
}
