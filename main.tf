terraform {
  required_providers {
    spotify = {
      version = "~> 0.2.6"
      source  = "conradludgate/spotify"
    }
  }
}

provider "spotify" {
  api_key = var.spotify_api_key
}

data "local_file" "songs" {
    filename = "${path.module}/songs.json"
}

locals {
  songs = jsondecode(data.local_file.songs.content)
}

resource "spotify_playlist" "playlist" {
  name        = "Terraform Car Playlist"
  description = "This Car Playlist is maintained by Terraform"
  public      = true

  tracks = flatten([
      data.spotify_search_track.by_song_names[*].tracks[*].id
  ])
}

data "spotify_search_track" "by_song_names" {
  count = length(local.songs)
  name  = local.songs[count.index]["name"]
  limit = 1   # Limit results to 1
}
