package models

import (
	"gorm.io/gorm"
	"time"
)

type User struct {
	ID        uint           `json:"id" gorm:"primaryKey"`
	Username  string         `json:"username"`
	Password  string         `json:"password"`
	LoginAt   *time.Time     `json:"login_at,omitempty"` // 确保这个字段的类型正确
	Status    string         `json:"status"`             // 新增字段，表示启用或停用状态
	IsAdmin   bool           `json:"is_admin"`           // 新增的字段,是否启动管理员
	Token     string         `json:"token"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"deleted_at,omitempty" gorm:"index"`
}

// BeforeCreate 钩子
func (user *User) BeforeCreate(tx *gorm.DB) (err error) {
	loc, _ := time.LoadLocation("Asia/Shanghai")
	user.CreatedAt = time.Now().In(loc)
	user.UpdatedAt = time.Now().In(loc)
	return
}

// BeforeUpdate 钩子
func (user *User) BeforeUpdate(tx *gorm.DB) (err error) {
	loc, _ := time.LoadLocation("Asia/Shanghai")
	user.UpdatedAt = time.Now().In(loc)
	return
}
