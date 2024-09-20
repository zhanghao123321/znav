package services

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"sort"
	"time"
)

// 定义结构体来解析热榜 API 响应
type HotItem struct {
	Title string  `json:"title"`
	Hot   float64 `json:"hot"` // 修改为 float64 类型来处理数字
	URL   string  `json:"url"`
}

type HotRankResponse struct {
	Code       int       `json:"code"`
	Message    string    `json:"message"`
	Title      string    `json:"title"`
	Subtitle   string    `json:"subtitle"`
	From       string    `json:"from"`
	Total      int       `json:"total"`
	UpdateTime string    `json:"updateTime"`
	Data       []HotItem `json:"data"`
}

// GetHotRank 获取指定热榜的内容
func GetHotRank(category string) ([]HotItem, error) {
	// 构建请求 URL
	apiURL := fmt.Sprintf("https://api.pearktrue.cn/api/dailyhot/?title=%s", category)

	// 创建 HTTP 客户端并设置超时时间
	client := &http.Client{
		Timeout: 60 * time.Second,
	}

	// 发起 GET 请求
	resp, err := client.Get(apiURL)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch hot rank: %w", err)
	}
	defer resp.Body.Close()

	// 检查 HTTP 状态码是否为 200 OK
	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("received non-200 response code")
	}

	// 读取响应数据
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Printf("Failed to read response body: %v", err)
		return nil, fmt.Errorf("failed to read response body: %w", err)
	}

	// 解析 JSON 数据
	var response HotRankResponse
	if err := json.Unmarshal(body, &response); err != nil {
		log.Printf("Failed to parse JSON: %v", err)
		return nil, fmt.Errorf("failed to parse JSON: %w", err)
	}

	// 排序并格式化数据
	hotItems := response.Data
	sort.Slice(hotItems, func(i, j int) bool {
		return hotItems[i].Hot > hotItems[j].Hot
	})

	// 只保留前 50 条数据
	if len(hotItems) > 50 {
		hotItems = hotItems[:50]
	}

	return hotItems, nil
}
