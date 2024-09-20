package controllers

import (
	"net/http"
	"znav/backend/services"

	"github.com/gin-gonic/gin"
)

// HotRankHandler 处理热榜请求
func HotRankHandler(c *gin.Context) {
	// 获取前端传来的热榜类别
	category := c.Query("category")
	if category == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Category is required",
		})
		return
	}

	// 调用 services 层获取热榜数据
	hotRankData, err := services.GetHotRank(category)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Failed to fetch hot rank",
			"details": err.Error(),
		})
		return
	}

	// 返回热榜数据给前端
	c.JSON(http.StatusOK, hotRankData)
}
