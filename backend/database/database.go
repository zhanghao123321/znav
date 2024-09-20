package database

import (
	"fmt"
	"github.com/joho/godotenv" // 导入 godotenv 用于读取 .env 文件
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"log"
	"os"
	"znav/backend/models"
)

var DB *gorm.DB

func InitDB() {
	// 加载 .env 文件中的环境变量
	err := godotenv.Load()
	if err != nil {
		log.Println("No .env file found or unable to load .env file.")
	}

	// 从环境变量中读取数据库配置信息
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbName := os.Getenv("DB_NAME")

	// 拼接成 DSN (Data Source Name)
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Asia%%2FShanghai", dbUser, dbPassword, dbHost, dbPort, dbName)

	// 打印调试信息
	log.Println("Connecting to database with DSN:", dsn)

	// 连接数据库
	DB, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database: ", err)
	}

	// 自动迁移数据库
	models.Migrate(DB)
}

func GetDB() *gorm.DB {
	return DB
}
