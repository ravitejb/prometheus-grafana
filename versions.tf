terraform {
  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.8.0"
    }
    template = {
      source = "hashicorp/template"
      version = "~> 2.2.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.1.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.7.0"
    }
  }
}