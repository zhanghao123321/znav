// middlewares/auth.go

package middlewares

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strings"
	"znav/backend/database"
	"znav/backend/models"
	"znav/backend/utils"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := c.GetHeader("Authorization")

		if token == "" || !strings.HasPrefix(token, "Bearer ") {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		token = strings.TrimPrefix(token, "Bearer ")

		// 验证 JWT
		username, err := utils.GetUsernameFromJWT(token)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}

		// 从数据库获取用户信息
		var user models.User
		db := database.GetDB()
		if err := db.Where("username = ?", username).First(&user).Error; err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
			c.Abort()
			return
		}

		// 检查用户状态
		if user.Status == "disabled" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Your account has been disabled"})
			c.Abort()
			return
		}

		// 将用户信息存储到上下文中
		c.Set("user", user)

		c.Next()
	}
}
