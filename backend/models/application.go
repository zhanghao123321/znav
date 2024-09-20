package models

import (
	"gorm.io/gorm"
	"time"
)

type Application struct {
	ID          uint      `json:"id" gorm:"primary_key"`
	Title       string    `json:"title"`
	Icon        string    `json:"icon"`
	IconColor   string    `json:"icon_color"` // 添加这个字段
	Link        string    `json:"link"`
	Description string    `json:"description"`
	Status      string    `json:"status"`
	MenuID      uint      `json:"menu_id"`
	OrderID     int       `json:"order_id" gorm:"default:0"` // 设置默认值为0
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

func (app *Application) BeforeCreate(tx *gorm.DB) (err error) {
	loc, _ := time.LoadLocation("Asia/Shanghai") // 设置时区为 Asia/Shanghai
	app.CreatedAt = time.Now().In(loc)           // 使用当前时区的时间
	app.UpdatedAt = time.Now().In(loc)
	return
}

func (app *Application) BeforeUpdate(tx *gorm.DB) (err error) {
	loc, _ := time.LoadLocation("Asia/Shanghai") // 确保更新时间也使用正确的时区
	app.UpdatedAt = time.Now().In(loc)
	return
}
