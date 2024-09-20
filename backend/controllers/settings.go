package controllers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"znav/backend/database"
	"znav/backend/models"
)

func GetSiteSettings(c *gin.Context) {
	var settings models.SiteSettings
	db := database.GetDB()

	if err := db.First(&settings).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Settings not found"})
		return
	}

	c.JSON(http.StatusOK, settings)
}

func UpdateSiteSettings(c *gin.Context) {
	var settings models.SiteSettings
	db := database.GetDB()

	// 检查是否有现有记录，如果没有则创建新的
	if err := db.First(&settings).Error; err != nil {
		settings = models.SiteSettings{}
		db.Create(&settings) // 如果记录不存在，创建新记录
	}

	if err := c.ShouldBindJSON(&settings); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db.Save(&settings)
	c.JSON(http.StatusOK, settings)
}
