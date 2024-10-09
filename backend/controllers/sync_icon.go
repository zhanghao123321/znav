package controllers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"znav/backend/database"
	"znav/backend/models"
)

func SyncIconHandler(c *gin.Context) {
	var requestData struct {
		IconURL string `json:"icon_url"`
	}

	if err := c.ShouldBindJSON(&requestData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data"})
		return
	}

	if requestData.IconURL == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Icon URL is required"})
		return
	}

	db := database.GetDB()

	// 使用固定的 ID 获取设置
	var settings models.SiteSettings
	if err := db.First(&settings, 1).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "图床配置未设置，请先在网站设置中配置"})
		return
	}

	if settings.ImageHostUrl == "" || settings.ImageHostToken == "" {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "图床地址或 Token 未配置，请在网站设置中填写"})
		return
	}

	// 下载图标
	iconData, err := downloadImage(requestData.IconURL)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to download icon: %v", err)})
		return
	}

	// 上传图标到图床
	uploadedURL, err := uploadImage(iconData, settings.ImageHostUrl, settings.ImageHostToken)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to upload icon: %v", err)})
		return
	}

	c.JSON(http.StatusOK, gin.H{"icon_url": uploadedURL})
}

// 下载图片数据
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

func uploadImage(imageData []byte, baseURL string, token string) (string, error) {
	if baseURL == "" || token == "" {
		return "", fmt.Errorf("图床地址或 Token 未配置")
	}

	// 构建上传接口的完整 URL
	uploadURL := fmt.Sprintf("%s/api/v1/upload", baseURL)

	// 创建一个缓冲区用于存储 multipart/form-data 数据
	var body bytes.Buffer
	writer := multipart.NewWriter(&body)

	// 添加 Token 字段（如果需要在表单中传递）
	err := writer.WriteField("token", token)
	if err != nil {
		return "", fmt.Errorf("添加 Token 字段失败: %w", err)
	}

	// 创建文件字段，假设字段名为 "file"
	part, err := writer.CreateFormFile("file", "icon.png")
	if err != nil {
		return "", fmt.Errorf("创建文件字段失败: %w", err)
	}

	// 将图片数据写入文件字段
	_, err = part.Write(imageData)
	if err != nil {
		return "", fmt.Errorf("写入图片数据失败: %w", err)
	}

	// 关闭 multipart 写入器，添加结尾的 boundary
	err = writer.Close()
	if err != nil {
		return "", fmt.Errorf("关闭写入器失败: %w", err)
	}

	// 创建请求
	req, err := http.NewRequest("POST", uploadURL, &body)
	if err != nil {
		return "", fmt.Errorf("创建上传请求失败: %w", err)
	}

	// 设置请求头
	req.Header.Set("Content-Type", writer.FormDataContentType())
	// 如果 Token 需要在请求头中传递
	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", token))

	// 打印请求信息（调试用）
	// fmt.Printf("请求 URL: %s\n", uploadURL)
	// fmt.Printf("请求头部: %v\n", req.Header)
	// fmt.Printf("请求 Body: %s\n", body.String())

	// 发送请求
	client := &http.Client{
		Timeout: 10 * time.Second,
	}
	resp, err := client.Do(req)
	if err != nil {
		return "", fmt.Errorf("上传请求失败: %w", err)
	}
	defer resp.Body.Close()

	// 读取响应体
	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("读取响应体失败: %w", err)
	}

	// 打印响应信息（调试用）
	// fmt.Printf("响应状态码: %d\n", resp.StatusCode)
	// fmt.Printf("响应 Body: %s\n", string(respBody))

	// 检查响应状态码
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("上传失败，状态码: %d，响应: %s", resp.StatusCode, string(respBody))
	}

	// 解析响应
	var result struct {
		Status  bool   `json:"status"`
		Message string `json:"message"`
		Data    struct {
			Links struct {
				URL string `json:"url"`
			} `json:"links"`
		} `json:"data"`
	}

	err = json.Unmarshal(respBody, &result)
	if err != nil {
		return "", fmt.Errorf("解析上传响应失败: %w", err)
	}

	if !result.Status {
		return "", fmt.Errorf("上传失败: %s", result.Message)
	}

	return result.Data.Links.URL, nil
}
