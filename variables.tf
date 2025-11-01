variable "subscription_id" {
  description = "The ID of the Azure subscription."
  type        = string

}
variable "location" {
  description = "The Azure region to deploy resources in."
  type        = string
  default     = "East US"
}
variable "admin_username" {
  description = "The admin username for the virtual machines."
  type        = string
  default     = "localadmin"
}
variable "admin_password" {
  description = "The admin password for the virtual machines."
  type        = string
  sensitive   = true


}