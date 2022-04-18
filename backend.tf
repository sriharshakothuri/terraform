terraform {
    backend "gcs"{
        bucket = "harsha12345"
        prefix = "harsha-346511"
        credentials = "key2.json"
    }
}