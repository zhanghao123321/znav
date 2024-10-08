package controllers

import (
	"net/http"
	"znav/backend/database"
	"znav/backend/models"

	"github.com/gin-gonic/gin"
)

func GetSiteSettings(c *gin.Context) {
	var settings models.SiteSettings
	db := database.GetDB()

	// 使用固定的 ID 查询
	if err := db.First(&settings, 1).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Settings not found"})
		return
	}

	c.JSON(http.StatusOK, settings)
}

func UpdateSiteSettings(c *gin.Context) {
	var settings models.SiteSettings
	db := database.GetDB()

	// 使用固定的 ID 查询
	if err := db.First(&settings, 1).Error; err != nil {
		// 如果记录不存在，创建新记录并设置 ID 为 1
		settings.ID = 1
		if err := c.ShouldBindJSON(&settings); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if err := db.Create(&settings).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
	} else {
		// 更新现有的记录
		if err := c.ShouldBindJSON(&settings); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		settings.ID = 1 // 确保 ID 不变
		if err := db.Save(&settings).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
	}

	c.JSON(http.StatusOK, settings)
}
