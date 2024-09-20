package controllers

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"znav/backend/database"
	"znav/backend/models"
)

func CreateMenu(c *gin.Context) {
	var menu models.Menu
	if err := c.ShouldBindJSON(&menu); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db := database.GetDB()
	if err := db.Create(&menu).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, menu)
}

func GetMenus(c *gin.Context) {
	title := c.Query("title")
	status := c.Query("status")
	pageStr := c.Query("page")
	pageSizeStr := c.Query("pageSize")

	page := 1
	pageSize := 10

	if pageStr != "" {
		page, _ = strconv.Atoi(pageStr)
	}
	if pageSizeStr != "" {
		pageSize, _ = strconv.Atoi(pageSizeStr)
	}

	offset := (page - 1) * pageSize

	var menus []models.Menu
	var total int64

	db := database.GetDB()
	query := db.Model(&models.Menu{})

	if title != "" {
		query = query.Where("title LIKE ?", "%"+title+"%")
	}
	if status != "" {
		query = query.Where("status = ?", status)
	}

	query.Count(&total)

	query.Preload("Apps").Order("order_id ASC").Limit(pageSize).Offset(offset).Find(&menus)

	c.JSON(http.StatusOK, gin.H{
		"menus": menus,
		"total": total,
	})
}

func UpdateMenu(c *gin.Context) {
	var menu models.Menu
	id := c.Param("id")

	db := database.GetDB()
	if err := db.First(&menu, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Menu not found"})
		return
	}

	if err := c.ShouldBindJSON(&menu); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db.Save(&menu)
	c.JSON(http.StatusOK, menu)
}

func DeleteMenu(c *gin.Context) {
	id := c.Param("id")
	db := database.GetDB()
	if err := db.Delete(&models.Menu{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Menu deleted successfully"})
}

func BatchDeleteMenus(c *gin.Context) {
	var request struct {
		Ids []uint `json:"ids"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db := database.GetDB()

	if err := db.Where("id IN ?", request.Ids).Delete(&models.Menu{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Menus deleted successfully"})
}

// 获取菜单总数
func GetTotalMenus(c *gin.Context) {
	var count int64
	db := database.GetDB()
	db.Model(&models.Menu{}).Count(&count)
	c.JSON(http.StatusOK, gin.H{"total": count})
}
