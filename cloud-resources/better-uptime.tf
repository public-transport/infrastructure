variable "betteruptime_api_token" {}

provider "betteruptime" {
  api_token = var.betteruptime_api_token
}

resource "betteruptime_status_page" "status_page" {
  company_name = "Public Transport FOSS"
  company_url  = "https://github.com/public-transport/infrastructure"
  subdomain    = "public-transport"
  timezone     = "Berlin"
  contact_url  = "mailto:mail@juliustens.eu"

  lifecycle {
    prevent_destroy = true
  }
}

resource "betteruptime_monitor_group" "bahn_guru" {
  name = "bahn.guru"
}

resource "betteruptime_monitor" "bahn_guru_start" {
  monitor_type     = "status"
  url              = "https://bahn.guru"
  monitor_group_id = betteruptime_monitor_group.bahn_guru.id
  check_frequency  = 180 # 3min is the minimum amount for the betteruptime free tier
}

resource "betteruptime_status_page_resource" "bahn_guru_start" {
  status_page_id = betteruptime_status_page.status_page.id
  resource_id    = betteruptime_monitor.bahn_guru_start.id
  resource_type  = "Monitor"
  public_name    = "bahn.guru (Start)"
  history        = true
}


resource "betteruptime_monitor" "bahn_guru_calendar" {
  monitor_type     = "status"
  url              = "https://bahn.guru/calendar?origin=Berlin+Hauptbahnhof&destination=Frankfurt+%28Main%29+Hbf&submit=Suchen&class=2&bc=0&departureAfter=&arrivalBefore=&duration=&maxChanges=&betterUptime=true"
  monitor_group_id = betteruptime_monitor_group.bahn_guru.id
  check_frequency  = 180 # 3min is the minimum amount for the betteruptime free tier
}

resource "betteruptime_status_page_resource" "bahn_guru_calendar" {
  status_page_id = betteruptime_status_page.status_page.id
  resource_id    = betteruptime_monitor.bahn_guru_calendar.id
  resource_type  = "Monitor"
  public_name    = "bahn.guru (Calendar)"
  history        = true
}


resource "betteruptime_monitor" "bahn_guru_impressum" {
  monitor_type     = "status"
  url              = "https://bahn.guru/impressum"
  monitor_group_id = betteruptime_monitor_group.bahn_guru.id
  check_frequency  = 180 # 3min is the minimum amount for the betteruptime free tier
}

resource "betteruptime_status_page_resource" "bahn_guru_impressum" {
  status_page_id = betteruptime_status_page.status_page.id
  resource_id    = betteruptime_monitor.bahn_guru_impressum.id
  resource_type  = "Monitor"
  public_name    = "bahn.guru (Impressum)"
  history        = true
}


resource "betteruptime_monitor_group" "api_direkt_bahn_guru" {
  name = "api.direkt.bahn.guru"
}

resource "betteruptime_monitor" "api_direkt_bahn_guru" {
  monitor_type     = "status"
  url              = "https://api.direkt.bahn.guru/8011160"
  monitor_group_id = betteruptime_monitor_group.api_direkt_bahn_guru.id
  check_frequency  = 180 # 3min is the minimum amount for the betteruptime free tier
}

resource "betteruptime_status_page_resource" "api_direkt_bahn_guru" {
  status_page_id = betteruptime_status_page.status_page.id
  resource_id    = betteruptime_monitor.api_direkt_bahn_guru.id
  resource_type  = "Monitor"
  public_name    = "api.direkt.bahn.guru"
  history        = true
}
