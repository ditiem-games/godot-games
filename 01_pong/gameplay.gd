extends Node2D

@onready var ball: CharacterBody2D = $ball
@onready var player: CharacterBody2D = $player
@onready var ai: CharacterBody2D = $ai
@onready var player_area: Area2D = $player_area
@onready var ai_area: Area2D = $ai_area

@onready var play_btn: Button = $PanelContainer/play_btn
@onready var player_score: Label = $PanelContainer/player_score
@onready var ai_score: Label = $PanelContainer/ai_score


const BALL_SPEED = 150 # px per second
const RACKET_SPEED = 96
const TOP_MARGIN = 24
const COURT_BORDER = 8
const RACKET_HEIGHT = 32

var player_score_cnt = 0
var ai_score_cnt = 0

var is_playing = false
var ball_velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	play_btn.pressed.connect( play )


func play ( ):
	play_btn.hide( )
	
	var sz = get_viewport_rect().size
	sz.y -= TOP_MARGIN
	var margin = Vector2( 0, TOP_MARGIN )
	
	ball.position   = margin + sz / 2
	player.position = margin + Vector2(        32, sz.y / 2 )
	ai.position     = margin + Vector2( sz.x - 32, sz.y / 2 )
	is_playing      = true
	
	ball_velocity = Vector2( randf( ), randf( ) ).normalized() * BALL_SPEED

func _on_player_loose ( body: Node2D ) -> void:
	player_score_cnt += 1
	player_score.text = str(player_score_cnt)
	play( )

func _on_ai_loose ( body: Node2D ) -> void:
	ai_score_cnt += 1
	ai_score.text = str(ai_score_cnt)
	play( )

func _physics_process ( delta: float ) -> void:
	if !is_playing:
		return
	
	var collision = ball.move_and_collide( ball_velocity * delta )
	
	if collision:
		var pos = collision.get_position()
		var normal = collision.get_normal()
		ball_velocity = ball_velocity - 2.0 * ball_velocity.dot( normal ) * normal

	var new_ai_pos = ai.position.move_toward( Vector2( ai.position.x, ball.position.y ), RACKET_SPEED * delta )
	ai.position = clamp_racket( new_ai_pos )
	
	var player_y = Input.get_axis( "move_up", "move_down" )
	player.position = clamp_racket( player.position + Vector2( 0, player_y * delta  * RACKET_SPEED ) )

func clamp_racket ( pos: Vector2 ):
	pos.y = clampf( pos.y, TOP_MARGIN + COURT_BORDER + RACKET_HEIGHT / 2, 240 - COURT_BORDER - RACKET_HEIGHT / 2 )
	return pos
