

variable "transit_mount_path" {
  description = "Path of transit backend"
  type        = string
}

variable "key_name" {
  description = "Name of transit key"
  type        = string
}

variable "key_type" {
  description = "Key type"
  type        = string
  default     = "aes256-gcm96"

  validation {
    condition     = contains(["aes128-gcm96", "aes256-gcm96", "chacha20-poly1305", "ed25519", "ecdsa-p256", "ecdsa-p384", "ecdsa-p521", "rsa-2048", "rsa-3072", "rsa-4096"], var.key_type)
    error_message = "Invalid Key type"
  }

}

variable "min_decryption_version" {
  description = "Mininum key version for decryption"
  type        = number
  default     = 1
}

variable "min_encryption_version" {
  description = "Mininum key version for encryption"
  type        = number
  default     = 1
}

variable "auto_rotate_period" {
  description = "Key auto rotate period"
  type        = string
  default     = "0"
}
