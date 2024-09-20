package config

import (
	"log"

	"github.com/joho/godotenv"
)

func LoadConfig() {
	if err := godotenv.Load("D:/GO/znav/backend/.env"); err != nil {
		log.Println("No .env file found")
	}
}
