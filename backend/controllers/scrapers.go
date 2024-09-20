package controllers

import (
	"net/http"
	"znav/backend/services"

	"github.com/gin-gonic/gin"
)

func ScrapeWebsiteHandler(c *gin.Context) {
	url := c.Query("url")
	if url == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "URL is required"})
		return
	}

	data, err := services.ScrapeWebsite(url)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, data)
}
