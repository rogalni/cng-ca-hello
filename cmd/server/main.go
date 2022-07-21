package main

import (
	"fmt"
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/rogalni/cng-ca-hello/config"
)

func main() {
	config.Setup()
	app := fiber.New(fiber.Config{
		EnablePrintRoutes:     false,
		DisableStartupMessage: true,
	})

	setupRoutes(app)

	log.Print("Running server on port ", config.App.Port)
	if err := app.Listen(fmt.Sprintf(":%s", config.App.Port)); err != nil {
		log.Print("Error:", err)
	}
}

type HelloMessage struct {
	Message string `json:"message,omitempty"`
}

func setupRoutes(app *fiber.App) {
	app.Get("/hello", func(c *fiber.Ctx) error {
		log.Println("/hello called")
		c.JSON(HelloMessage{Message: "Welcome to cng-ca-hello"})
		return nil
	})
}
