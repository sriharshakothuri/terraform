provider "google" {
  project     = "harsha-346511"
//   region  = "<YOUR REGION>"
//   zone    = "<YOUR ZONE>"
  credentials = file("key2.json")
}