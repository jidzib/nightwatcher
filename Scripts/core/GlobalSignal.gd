extends Node

signal open_shop
signal update_player_coins(amount: int)
signal shop_item_selected(item_id: int)
signal next_day()

var day: int = 1
