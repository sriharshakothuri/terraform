provider "google" {
  project     = "peerless-rock-346305"
//   region  = "<YOUR REGION>"
//   zone    = "<YOUR ZONE>"
  credentials = file("key.json")
}