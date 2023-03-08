extends Node

# to create the coins on the map, duplicate the coin node and change the amounts in the inspector

export var gold_amount = 0;
export var ether_amount = 0;

var player_node;
var collected;
var currency_node;



# start function
func _ready():
	player_node = get_parent().get_node("Player");
	currency_node = get_parent().get_node("PauseScreen").get_node("Currency");
	# initializes the area node, body_entered is the function for when a different collider enters it
	get_node("Area").connect("body_entered", self, "OnBodyEnter")

# update function
func _process(delta):
	pass
	
func OnBodyEnter(body: Node):
	if (collected):
		# can't collect it twice
		return;
	if (body == player_node):
		# collided with the player
		player_node.Currency_Update(ether_amount, gold_amount);
		collected = true;
		# destroys node
		queue_free();
