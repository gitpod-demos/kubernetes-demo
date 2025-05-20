package main

import (
	"embed"
	"log"
	"net/http"
)

//go:embed web/*
var content embed.FS

func main() {
	mux := http.NewServeMux()
	mux.Handle("/", http.FileServer(http.FS(content)))

	addr := ":8080"
	log.Printf("listening on %s ...", addr)
	if err := http.ListenAndServe(addr, mux); err != nil {
		log.Fatal(err)
	}
}
