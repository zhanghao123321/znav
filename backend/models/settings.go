package models

import (
	"time"
)

type SiteSettings struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	Title     string    `json:"title"`
	Icon      string    `json:"icon"`
	IconColor string    `json:"icon_color"`
	Footer    string    `json:"footer"`
	Icp       string    `json:"icp"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}
