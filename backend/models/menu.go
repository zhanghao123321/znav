package models

import (
	"gorm.io/gorm"
	"time"
)

type Menu struct {
	ID         uint          `json:"id" gorm:"primary_key"`
	Title      string        `json:"title"`
	Icon       string        `json:"icon"`
	IconColor  string        `json:"icon_color"` // 添加这个字段
	Status     string        `json:"status"`
	OrderID    int           `json:"order_id" gorm:"default:0"` // 设置默认值为0
	ParentID   *uint         `json:"parent_id"`                 // 新增父级菜单字段，允许为 null
	Apps       []Application `json:"apps" gorm:"foreignkey:MenuID"`
	CreatedAt  time.Time     `json:"created_at"`
	UpdatedAt  time.Time     `json:"updated_at"`
	gorm.Model `gorm:"-"`
}

// BeforeCreate 钩子，在创建数据之前执行
func (menu *Menu) BeforeCreate(tx *gorm.DB) (err error) {
	loc, _ := time.LoadLocation("Asia/Shanghai") // 设置时区为 Asia/Shanghai
	menu.CreatedAt = time.Now().In(loc)          // 使用当前时区的时间
	menu.UpdatedAt = time.Now().In(loc)
	return
}

// BeforeUpdate 钩子，在更新数据之前执行
func (menu *Menu) BeforeUpdate(tx *gorm.DB) (err error) {
	loc, _ := time.LoadLocation("Asia/Shanghai") // 确保更新时间也使用正确的时区
	menu.UpdatedAt = time.Now().In(loc)
	return
}
