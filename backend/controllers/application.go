package controllers

import (
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"strconv"
	"znav/backend/database"
	"znav/backend/models"
)

func CreateApplication(c *gin.Context) {
	var app models.Application
	if err := c.ShouldBindJSON(&app); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if app.MenuID == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid Menu ID"})
		return
	}

	db := database.GetDB()
	if err := db.Create(&app).Error; err != nil {
		log.Println("Error creating application:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create application"})
		return
	}

	c.JSON(http.StatusOK, app)
}

func GetApplications(c *gin.Context) {
	var applications []models.Application
	// 获取筛选参数
	title := c.Query("title")
	status := c.Query("status")
	menuIdStr := c.Query("menuId")

	// 获取分页参数
	pageStr := c.Query("page")
	pageSizeStr := c.Query("pageSize")

	// 默认分页参数
	page := 1
	pageSize := 10

	// 将参数转换为整数
	if pageStr != "" {
		page, _ = strconv.Atoi(pageStr)
	}
	if pageSizeStr != "" {
		pageSize, _ = strconv.Atoi(pageSizeStr)
	}

	// 计算偏移量
	offset := (page - 1) * pageSize

	// 查询条件
	db := database.GetDB()
	query := db.Model(&models.Application{})

	if title != "" {
		query = query.Where("title LIKE ?", "%"+title+"%")
	}
	if status != "" {
		query = query.Where("status = ?", status)
	}

	if menuIdStr != "" {
		menuID, err := strconv.Atoi(menuIdStr)
		if err == nil {
			// 获取指定菜单ID以及其子菜单的ID
			var menuIDs []uint
			menuIDs = append(menuIDs, uint(menuID))
			var subMenus []models.Menu
			db.Where("parent_id = ?", menuID).Find(&subMenus)
			for _, subMenu := range subMenus {
				menuIDs = append(menuIDs, subMenu.ID)
			}
			query = query.Where("menu_id IN ?", menuIDs)
		}
	}

	// 查询总数
	var total int64
	query.Count(&total)

	// 分页查询
	if err := query.Limit(pageSize).Offset(offset).Find(&applications).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"applications": applications,
		"total":        total,
	})
}

func UpdateApplication(c *gin.Context) {
	var app models.Application
	id := c.Param("id")

	db := database.GetDB()
	if err := db.First(&app, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Application not found"})
		return
	}

	if err := c.ShouldBindJSON(&app); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db.Save(&app)
	c.JSON(http.StatusOK, app)
}

func DeleteApplication(c *gin.Context) {
	id := c.Param("id")
	db := database.GetDB()
	if err := db.Delete(&models.Application{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Application deleted successfully"})
}

func BatchDeleteApplications(c *gin.Context) {
	var request struct {
		Ids []uint `json:"ids"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db := database.GetDB()

	if err := db.Where("id IN ?", request.Ids).Delete(&models.Application{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Applications deleted successfully"})
}

// 获取应用总数
func GetTotalApplications(c *gin.Context) {
	var count int64
	db := database.GetDB()
	db.Model(&models.Application{}).Count(&count)
	c.JSON(http.StatusOK, gin.H{"total": count})
}

// 获取最近新增的应用
func GetRecentApplications(c *gin.Context) {
	var applications []models.Application
	db := database.GetDB()
	db.Order("created_at desc").Limit(5).Find(&applications)
	c.JSON(http.StatusOK, gin.H{"applications": applications})
}
