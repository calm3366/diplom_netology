resource "yandex_vpc_network" "network" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public_subnet" {
  for_each       = { for k in var.vpc_subnet : index(var.vpc_subnet, k) => k }
  name           = each.value.vpc_name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = each.value.v4_cidr_blocks
}







