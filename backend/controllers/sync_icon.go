// controllers/controllers.go

package controllers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"time"
	"znav/backend/database"
	"znav/backend/models"

	"github.com/gin-gonic/gin"
)

func SyncIconHandler(c *gin.Context) {
	var requestData struct {
		IconURL string `json:"icon_url"`
		Token   string `json:"token"`
	}

	if err := c.ShouldBindJSON(&requestData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data"})
		return
	}

	if requestData.IconURL == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Icon URL is required"})
		return
	}

	if requestData.Token == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Token is required"})
		return
	}

	// 下载图标
	iconData, err := downloadImage(requestData.IconURL)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to download icon: %v", err)})
		return
	}

	// 上传图标到图床
	uploadedURL, err := uploadImage(iconData, requestData.Token)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to upload icon: %v", err)})
		return
	}

	// 成功时，返回图床上传成功后的 URL
	c.JSON(http.StatusOK, gin.H{"icon_url": uploadedURL})
}

func uploadImage(imageData []byte, token string) (string, error) {
	uploadURL := "https://img.ink/api/upload"

	var body bytes.Buffer
	writer := multipart.NewWriter(&body)

	// 设置图片文件的字段
	part, err := writer.CreateFormFile("image", "icon.png")
	if err != nil {
		return "", fmt.Errorf("创建文件字段失败: %w", err)
	}

	_, err = part.Write(imageData)
	if err != nil {
		return "", fmt.Errorf("写入图片数据失败: %w", err)
	}

	// 设置文件夹字段为 "icofolder"
	err = writer.WriteField("folder", "icofolder")
	if err != nil {
		return "", fmt.Errorf("写入 folder 字段失败: %w", err)
	}

	err = writer.Close()
	if err != nil {
		return "", fmt.Errorf("关闭写入器失败: %w", err)
	}

	// 创建请求
	req, err := http.NewRequest("POST", uploadURL, &body)
	if err != nil {
		return "", fmt.Errorf("创建上传请求失败: %w", err)
	}

	// 设置 token 头，而不是 Authorization
	req.Header.Set("token", token)
	req.Header.Set("Content-Type", writer.FormDataContentType())

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return "", fmt.Errorf("上传请求失败: %w", err)
	}
	defer resp.Body.Close()

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("读取响应体失败: %w", err)
	}

	// 打印图床返回的状态码和响应体
	//fmt.Printf("图床返回的状态码: %d\n", resp.StatusCode)
	//fmt.Printf("图床返回的响应体: %s\n", string(respBody))

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("上传失败，状态码: %d，响应: %s", resp.StatusCode, string(respBody))
	}

	// 解析图床返回的结果
	var result struct {
		Code int    `json:"code"`
		Msg  string `json:"msg"`
		Data struct {
			URL string `json:"url"`
		} `json:"data"`
	}

	err = json.Unmarshal(respBody, &result)
	if err != nil {
		return "", fmt.Errorf("解析上传响应失败: %w", err)
	}

	if result.Code != 200 {
		return "", fmt.Errorf("上传失败: %s", result.Msg)
	}

	return result.Data.URL, nil
}

func downloadImage(imageURL string) ([]byte, error) {
	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	req, err := http.NewRequest("GET", imageURL, nil)
	if err != nil {
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (compatible; Scraper/1.0)")

	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("请求失败: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("请求失败: %d %s", resp.StatusCode, resp.Status)
	}

	imageData, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取图片数据失败: %w", err)
	}

	return imageData, nil
}

// 保存图床 Token 的接口
func SaveImageHostTokenHandler(c *gin.Context) {
	var requestData struct {
		Token string `json:"token"`
	}

	if err := c.ShouldBindJSON(&requestData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data"})
		return
	}

	if requestData.Token == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Token is required"})
		return
	}

	db := database.GetDB()

	var settings models.SiteSettings
	if err := db.First(&settings, 1).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "无法获取站点设置"})
		return
	}

	settings.ImageHostToken = requestData.Token

	if err := db.Save(&settings).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "无法保存 Token"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Token 保存成功"})
}
