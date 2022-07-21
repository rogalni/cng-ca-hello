package config

import (
	"log"

	"github.com/spf13/viper"
)

var App Config

type Config struct {
	ServiceName string `mapstructure:"SERVICE_NAME"`
	Port        string `mapstructure:"PORT"`
}

func Setup() {
	viper.SetDefault("SERVICE_NAME", "cng-ca-hello")
	viper.SetDefault("PORT", "8080")

	viper.AddConfigPath("./config")
	viper.SetConfigName("app")
	viper.SetConfigType("env")

	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); ok {
			// Config file not found; ignore error if desired
		} else {
			log.Println("Failed to load from config file")
		}
	}

	viper.AutomaticEnv()

	err := viper.Unmarshal(&App)
	if err != nil {
		log.Fatal("Could not unmarshal config")
	}
}
