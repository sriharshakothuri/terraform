terraform {
    backend "gcs"{
        bucket = "terraformsa-tfstate"
        prefix = "peerless-rock-346305"
        credentials = "key.json"
    }
}