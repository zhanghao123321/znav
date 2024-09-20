package controllers

import (
	"net/http"
	"znav/backend/services"

	"github.com/gin-gonic/gin"
)

func HitokotoHandler(c *gin.Context) {
	// 调用 services.GetHitokoto 函数
	hitokoto, err := services.GetHitokoto()
	if err != nil {
		// 返回错误信息给前端
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Failed to fetch hitokoto",
			"details": err.Error(),
		})
		return
	}

	// 成功时返回每日一言内容
	c.JSON(http.StatusOK, gin.H{
		"hitokoto": hitokoto,
	})
}
