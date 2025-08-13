locals {
  file_ssh = file(var.ssh_file)

  # info_test_vm_public = [zipmap(
  #   ["1. Name", "2. EXTERNAL IP:", "3. INTERNAL IP:"],
  #   [
  #     yandex_compute_instance.test_vm_public.name,
  #     yandex_compute_instance.test_vm_public.network_interface[0].nat_ip_address,
  #     yandex_compute_instance.test_vm_public.network_interface[0].ip_address
  #   ]
  # )]


}

