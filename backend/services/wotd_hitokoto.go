package services

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

// GetHitokoto 发送 HTTP 请求获取每日一言并返回纯文本内容
func GetHitokoto() (string, error) {
	// 创建 HTTP 客户端并设置超时时间
	client := &http.Client{
		Timeout: 10 * time.Second, // 设置超时时间为 10 秒
	}

	// 发起 GET 请求
	resp, err := client.Get("https://api.pearktrue.cn/api/hitokoto/")
	if err != nil {
		// 打印并返回错误信息
		fmt.Printf("Error fetching hitokoto: %v\n", err)
		return "", err
	}
	defer resp.Body.Close()

	// 检查 HTTP 状态码是否为 200 OK
	if resp.StatusCode != http.StatusOK {
		fmt.Printf("Error: received non-200 status code %d\n", resp.StatusCode)
		return "", fmt.Errorf("non-200 response code: %d", resp.StatusCode)
	}

	// 读取响应数据（假设是纯文本）
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("Error reading response body: %v\n", err)
		return "", err
	}

	// 返回每日一言的文本内容
	return string(body), nil
}
