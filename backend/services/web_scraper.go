package services

import (
	"fmt"
	"log"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
)

type ScrapedData struct {
	Title       string `json:"title"`
	LogoLink    string `json:"logo_link"`
	Description string `json:"description"`
}

func ScrapeWebsite(websiteURL string) (*ScrapedData, error) {
	// 创建带有超时设置的 HTTP 客户端
	client := &http.Client{
		Timeout: 10 * time.Second, // 设置超时时间为 5 秒
	}

	// 发起 HTTP 请求
	req, err := http.NewRequest("GET", websiteURL, nil)
	if err != nil {
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (compatible; Scraper/1.0)")

	res, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("请求失败: %w", err)
	}
	defer res.Body.Close()

	if res.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("请求失败: %d %s", res.StatusCode, res.Status)
	}

	// 解析 HTML
	doc, err := goquery.NewDocumentFromReader(res.Body)
	if err != nil {
		return nil, fmt.Errorf("解析 HTML 失败: %w", err)
	}

	// 获取标题
	title := doc.Find("title").Text()

	// 获取描述
	description, _ := doc.Find("meta[name='description']").Attr("content")

	// 获取 Logo 链接
	var logolink string

	// 定义可能的选择器和对应的属性
	type selectorAttr struct {
		selector string
		attr     string
	}

	logoSelectors := []selectorAttr{
		{"link[rel~='icon']", "href"},
		{"link[rel~='shortcut icon']", "href"},
		{"link[rel~='apple-touch-icon']", "href"},
		{"meta[property='og:image']", "content"},
	}

	for _, sa := range logoSelectors {
		selection := doc.Find(sa.selector)
		if selection.Length() > 0 {
			link, exists := selection.First().Attr(sa.attr)
			if exists && link != "" {
				logolink = link
				break
			}
		}
	}

	// 如果未找到图标链接，尝试使用默认的 /favicon.ico
	if logolink == "" {
		log.Println("Logo 链接未在 HTML 中找到，尝试获取默认的 /favicon.ico")
		logolink = resolveURL(websiteURL, "/favicon.ico")
	} else {
		// 处理相对路径和协议相对路径的情况
		logolink = resolveURL(websiteURL, logolink)
	}

	// 检查 favicon 是否存在
	if !urlExists(logolink, client) {
		log.Printf("无法访问图标链接: %s", logolink)
		logolink = ""
	}

	data := &ScrapedData{
		Title:       strings.TrimSpace(title),
		LogoLink:    logolink,
		Description: strings.TrimSpace(description),
	}

	return data, nil
}

// 解析相对 URL
func resolveURL(baseURL, relativeURL string) string {
	base, err := url.Parse(baseURL)
	if err != nil {
		return relativeURL
	}
	ref, err := url.Parse(relativeURL)
	if err != nil {
		return relativeURL
	}
	resolvedURL := base.ResolveReference(ref)
	return resolvedURL.String()
}

// 检查 URL 是否存在，使用带超时的客户端
func urlExists(u string, client *http.Client) bool {
	req, err := http.NewRequest("HEAD", u, nil)
	if err != nil {
		return false
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (compatible; Scraper/1.0)")

	resp, err := client.Do(req)
	if err != nil {
		return false
	}
	defer resp.Body.Close()
	return resp.StatusCode == http.StatusOK
}
