output "db_shape" {
  value = "${oci_database_db_system.db_system.shape}"
}
output "db_name" {
  value = "${oci_database_db_system.db_system.hostname}"
}
output "show-new-db_system" {
  value = "${oci_database_db_system.db_system.id}"
}
output "db_state" {
  value = "${oci_database_db_system.db_system.state}"
}
