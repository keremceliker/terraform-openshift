
// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("../gcp-credentials.json")}"
  project     = "first-project-200708"
  region      = "west-europe4-a"
}
